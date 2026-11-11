-- Cashflow — initial schema
-- Tables: profiles, categories, expenses. Every row belongs to one auth user
-- and Row Level Security restricts all access to that user.

-- ---------------------------------------------------------------------------
-- profiles (one row per auth user, created by trigger on signup)
-- ---------------------------------------------------------------------------
create table public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  name        text,
  email       text,
  photo_url   text,
  currency    text not null default 'TND' check (currency ~ '^[A-Z]{3}$'),
  created_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- categories
-- Default categories carry a default_key and a NULL name so the app can show
-- the localized name; once the user renames one, name is set and wins.
-- ---------------------------------------------------------------------------
create table public.categories (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid() references auth.users (id) on delete cascade,
  name         text check (name is null or char_length(btrim(name)) between 1 and 40),
  default_key  text check (default_key in ('food','transport','shopping','bills','health','other')),
  color_hex    text not null check (color_hex ~ '^#[0-9A-Fa-f]{6}$'),
  icon_key     text not null check (char_length(icon_key) between 1 and 32),
  sort_order   integer not null default 0,
  is_default   boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  constraint categories_name_or_key check (name is not null or default_key is not null),
  constraint categories_id_user_unique unique (id, user_id),
  constraint categories_default_key_unique unique (user_id, default_key)
);

create index categories_user_order_idx on public.categories (user_id, sort_order);

-- ---------------------------------------------------------------------------
-- expenses — amount is an integer in thousandths of the currency unit
-- (millimes for TND). Never a float.
-- ---------------------------------------------------------------------------
create table public.expenses (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null default auth.uid() references auth.users (id) on delete cascade,
  amount       bigint not null check (amount > 0 and amount <= 999999999999),
  category_id  uuid not null,
  note         text check (note is null or char_length(note) <= 200),
  date         timestamptz not null,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  -- The category must belong to the same user.
  constraint expenses_category_fk foreign key (category_id, user_id)
    references public.categories (id, user_id) on delete restrict
);

create index expenses_user_date_idx on public.expenses (user_id, date desc);
create index expenses_category_idx on public.expenses (category_id);

-- ---------------------------------------------------------------------------
-- updated_at
-- ---------------------------------------------------------------------------
create or replace function public.touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

create trigger categories_touch before update on public.categories
  for each row execute function public.touch_updated_at();
create trigger expenses_touch before update on public.expenses
  for each row execute function public.touch_updated_at();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
alter table public.profiles   enable row level security;
alter table public.categories enable row level security;
alter table public.expenses   enable row level security;

create policy "profiles: read own"   on public.profiles for select to authenticated
  using (id = (select auth.uid()));
create policy "profiles: update own" on public.profiles for update to authenticated
  using (id = (select auth.uid())) with check (id = (select auth.uid()));

create policy "categories: read own"   on public.categories for select to authenticated
  using (user_id = (select auth.uid()));
create policy "categories: insert own" on public.categories for insert to authenticated
  with check (user_id = (select auth.uid()) and default_key is null and is_default = false);
create policy "categories: update own" on public.categories for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
-- The default "Other" category can never be deleted (it receives orphaned expenses).
create policy "categories: delete own" on public.categories for delete to authenticated
  using (user_id = (select auth.uid()) and default_key is distinct from 'other');

create policy "expenses: read own"   on public.expenses for select to authenticated
  using (user_id = (select auth.uid()));
create policy "expenses: insert own" on public.expenses for insert to authenticated
  with check (user_id = (select auth.uid()));
create policy "expenses: update own" on public.expenses for update to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "expenses: delete own" on public.expenses for delete to authenticated
  using (user_id = (select auth.uid()));

-- Users may not flip default_key / is_default on their own categories.
revoke update on public.categories from authenticated;
grant update (name, color_hex, icon_key, sort_order) on public.categories to authenticated;
revoke update on public.profiles from authenticated;
grant update (name, currency) on public.profiles to authenticated;

-- ---------------------------------------------------------------------------
-- Signup: create the profile and seed the six default categories.
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.profiles (id, name, email, photo_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name'),
    new.email,
    coalesce(new.raw_user_meta_data ->> 'avatar_url', new.raw_user_meta_data ->> 'picture')
  )
  on conflict (id) do nothing;

  insert into public.categories (user_id, default_key, color_hex, icon_key, sort_order, is_default)
  values
    (new.id, 'food',      '#FDBA74', 'food',      0, true),
    (new.id, 'transport', '#93C5FD', 'transport', 1, true),
    (new.id, 'shopping',  '#F9A8D4', 'shopping',  2, true),
    (new.id, 'bills',     '#FDE68A', 'bills',     3, true),
    (new.id, 'health',    '#6EE7B7', 'health',    4, true),
    (new.id, 'other',     '#C4C4CC', 'other',     5, true)
  on conflict (user_id, default_key) do nothing;

  return new;
end;
$$;

revoke execute on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ---------------------------------------------------------------------------
-- Delete a category: move its expenses to the user's "Other" category,
-- then delete it — atomically. Runs as the caller, so RLS still applies.
-- ---------------------------------------------------------------------------
create or replace function public.delete_category(p_category_id uuid)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_uid   uuid := auth.uid();
  v_other uuid;
begin
  if v_uid is null then
    raise exception 'not authenticated' using errcode = '42501';
  end if;

  select id into v_other
  from public.categories
  where user_id = v_uid and default_key = 'other';

  if v_other is null then
    raise exception 'other category missing' using errcode = 'P0002';
  end if;
  if v_other = p_category_id then
    raise exception 'cannot delete the Other category' using errcode = '42501';
  end if;

  update public.expenses
     set category_id = v_other
   where user_id = v_uid and category_id = p_category_id;

  delete from public.categories
   where id = p_category_id and user_id = v_uid;

  if not found then
    raise exception 'category not found' using errcode = 'P0002';
  end if;
end;
$$;

revoke execute on function public.delete_category(uuid) from public, anon;
grant execute on function public.delete_category(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Reorder categories in one call.
-- ---------------------------------------------------------------------------
create or replace function public.reorder_categories(p_ids uuid[])
returns void
language sql
security invoker
set search_path = ''
as $$
  update public.categories c
     set sort_order = t.ord - 1
    from unnest(p_ids) with ordinality as t(id, ord)
   where c.id = t.id and c.user_id = auth.uid();
$$;

revoke execute on function public.reorder_categories(uuid[]) from public, anon;
grant execute on function public.reorder_categories(uuid[]) to authenticated;

-- ---------------------------------------------------------------------------
-- Realtime: the app streams categories and expenses.
-- ---------------------------------------------------------------------------
alter publication supabase_realtime add table public.categories, public.expenses, public.profiles;
