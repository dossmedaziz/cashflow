-- Cover the composite (category_id, user_id) foreign key.
drop index if exists public.expenses_category_idx;
create index expenses_category_user_idx on public.expenses (category_id, user_id);
