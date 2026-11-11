import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/failures.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/expense_tile.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/total_card.dart';
import '../../auth/providers/auth_providers.dart';
import '../../categories/data/category.dart';
import '../../categories/providers/categories_providers.dart';
import '../../settings/providers/settings_providers.dart';
import '../../today_widget/ui/widget_launch_listener.dart';
import '../data/expense.dart';
import '../data/monthly_summary.dart';
import '../providers/expenses_providers.dart';
import 'expense_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final filter = ref.watch(categoryFilterProvider);
    final groups = ref.watch(dayGroupsProvider);
    final summary = ref.watch(monthlySummaryProvider);

    Future<void> refresh() async {
      await Future.wait([ref.read(expenseRepositoryProvider).refresh(), ref.read(categoryRepositoryProvider).refresh()])
          .catchError((Object e) {
            if (context.mounted) showErrorToast(context, describeFailure(context, e));
            return const <void>[];
          });
    }

    return Scaffold(
      body: WidgetLaunchListener(
        // Tapping the home-screen widget opens the Add sheet.
        onAddExpense: () => showExpenseSheet(context, initialCategoryId: ref.read(categoryFilterProvider)),
        child: Stack(
          children: [
            RefreshIndicator(
              color: c.primary,
              backgroundColor: c.card,
              onRefresh: refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverSafeArea(bottom: false, sliver: SliverToBoxAdapter(child: _Header())),
                  const SliverToBoxAdapter(child: _Hero()),
                  const SliverToBoxAdapter(child: _FilterChips()),
                  ...groups.when(
                    skipLoadingOnReload: true,
                    loading: () => [const SliverFillRemaining(hasScrollBody: false, child: LoadingState())],
                    error: (e, _) => [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: ErrorState(error: e, onRetry: refresh),
                        ),
                      ),
                    ],
                    data: (list) {
                      if (list.isEmpty) {
                        return [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 110),
                              child: Center(child: _Empty(filtered: filter != null && summary.value?.count != 0)),
                            ),
                          ),
                        ];
                      }
                      return [
                        SliverPadding(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 14, 20, 120 + safeBottom),
                          sliver: SliverList.separated(
                            itemCount: list.length,
                            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.groupGap),
                            itemBuilder: (context, i) => _DayGroupView(key: ValueKey(list[i].day), group: list[i]),
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
            // Soft fade so the list slides under the add button.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 150,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [c.bg.withValues(alpha: 0), c.bg],
                      stops: const [0, 0.7],
                    ),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              end: 20,
              bottom: math.max(24, safeBottom + 4),
              child: Pressable(
                key: const ValueKey('add-expense'),
                semanticLabel: context.l10n.addExpense,
                onTap: () => showExpenseSheet(context, initialCategoryId: filter),
                child: Container(
                  width: AppSizes.fabWidth,
                  height: AppSizes.fabHeight,
                  decoration: BoxDecoration(color: c.fab, borderRadius: AppRadii.pillAll),
                  alignment: Alignment.center,
                  child: AppIcon(AppIcons.add, size: 28, strokeWidth: 2.2, color: c.fabFg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);
    final now = ref.watch(clockProvider)();
    final first = user?.firstName;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateLabels(l10n, context.lang).long(now), style: t.subtitle),
                const SizedBox(height: 2),
                Text(
                  first == null ? l10n.helloNoName : l10n.hello(first),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.heading,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          CircleIconButton(
            icon: AppIcons.other,
            strokeWidth: 1.8,
            semanticLabel: l10n.categoriesTooltip,
            onPressed: () => context.push(Routes.categories),
          ),
          const SizedBox(width: 10),
          Pressable(
            semanticLabel: l10n.settingsTooltip,
            onTap: () => context.push(Routes.settings),
            child: Container(
              width: AppSizes.iconButton,
              height: AppSizes.iconButton,
              decoration: BoxDecoration(color: c.avatarBg, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                user?.initial ?? '',
                style: t.body.copyWith(fontSize: 16, fontWeight: FontWeight.w700, color: c.avatarFg, height: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends ConsumerWidget {
  const _Hero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = context.lang;
    final currency = ref.watch(currencyProvider);
    final summary = ref.watch(monthlySummaryProvider).value;
    final now = ref.watch(clockProvider)();
    final labels = DateLabels(l10n, lang);

    String? comparison;
    var trend = TotalTrend.less;
    if (summary != null && summary.hasComparison) {
      final prevMonth = labels.monthName(startOfPreviousMonth(now));
      final pct = '${summary.percentChange}';
      (comparison, trend) = switch (summary.trend) {
        Trend.less => (l10n.compareLess(pct, prevMonth), TotalTrend.less),
        Trend.more => (l10n.compareMore(pct, prevMonth), TotalTrend.more),
        Trend.same => (l10n.compareSame(prevMonth), TotalTrend.same),
      };
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 0),
      child: AppearIn(
        child: TotalCard(
          label: l10n.monthTotalLabel(labels.monthName(now)),
          monthChip: labels.monthChip(now),
          total: MoneyFormat.format(summary?.total ?? 0, currency, lang),
          currencySymbol: currency.symbolFor(lang),
          comparison: comparison,
          trend: trend,
          emptyHint: summary != null && summary.count == 0 ? l10n.heroEmpty : null,
        ),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider).value ?? const <Category>[];
    final filter = ref.watch(categoryFilterProvider);
    final select = ref.read(categoryFilterProvider.notifier).select;

    return Semantics(
      label: l10n.filterLabel,
      container: true,
      child: SizedBox(
        height: AppSizes.chip + 22,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsetsDirectional.fromSTEB(20, 18, 20, 4),
          itemCount: categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.chipGap),
          itemBuilder: (context, i) {
            if (i == 0) {
              return CategoryChip(label: l10n.filterAll, selected: filter == null, onTap: () => select(null));
            }
            final cat = categories[i - 1];
            return CategoryChip(
              key: ValueKey('chip-${cat.id}'),
              label: cat.displayName(l10n),
              iconKey: cat.iconKey,
              colorHex: cat.colorHex,
              selected: filter == cat.id,
              onTap: () => select(filter == cat.id ? null : cat.id),
            );
          },
        ),
      ),
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty({required this.filtered});

  final bool filtered;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    if (filtered) {
      final id = ref.watch(categoryFilterProvider);
      final cat = ref.watch(categoriesByIdProvider)[id];
      return EmptyState(
        title: l10n.emptyFilteredTitle(cat?.displayName(l10n) ?? ''),
        subtitle: l10n.emptyFilteredSubtitle,
      );
    }
    return EmptyState(title: l10n.emptyTitle, subtitle: l10n.emptySubtitle);
  }
}

class _DayGroupView extends ConsumerWidget {
  const _DayGroupView({super.key, required this.group});

  final DayGroup group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final lang = context.lang;
    final currency = ref.watch(currencyProvider);
    final byId = ref.watch(categoriesByIdProvider);
    final now = ref.watch(clockProvider)();
    final labels = DateLabels(l10n, lang);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(labels.day(group.day, now), style: t.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                ),
              ),
              Text(
                MoneyFormat.withSymbol(group.total, currency, lang),
                style: t.subtitle.copyWith(fontFeatures: AppTextStyles.tabular),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: AppRadii.heroAll,
          child: ColoredBox(
            color: c.card,
            child: MotionSize(
              child: Column(
                children: [
                  for (var i = 0; i < group.expenses.length; i++)
                    _ExpenseRow(
                      key: ValueKey(group.expenses[i].id),
                      expense: group.expenses[i],
                      category: byId[group.expenses[i].categoryId],
                      showDivider: i > 0,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpenseRow extends ConsumerWidget {
  const _ExpenseRow({super.key, required this.expense, required this.category, required this.showDivider});

  final Expense expense;
  final Category? category;
  final bool showDivider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final l10n = context.l10n;
    final lang = context.lang;
    final currency = ref.watch(currencyProvider);
    final catName = category?.displayName(l10n) ?? l10n.catOther;
    final title = expense.note ?? catName;

    return AppearIn(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: showDivider ? Border(top: BorderSide(color: c.stroke)) : null,
        ),
        child: SwipeToDelete(
          deleteLabel: l10n.delete,
          background: c.card,
          onDelete: () => deleteExpenseWithUndo(context, ref, expense, title),
          child: ExpenseTile(
            title: title,
            categoryName: catName,
            iconKey: category?.iconKey ?? 'other',
            colorHex: category?.colorHex ?? '#C4C4CC',
            time: DateLabels(l10n, lang).time(expense.date),
            amount: MoneyFormat.format(expense.amount, currency, lang),
            currencySymbol: currency.symbolFor(lang),
            onTap: () async {
              final toDelete = await showExpenseSheet(context, expense: expense);
              if (toDelete != null && context.mounted) {
                await deleteExpenseWithUndo(context, ref, toDelete, title);
              }
            },
          ),
        ),
      ),
    );
  }
}

/// Deletes immediately (optimistic) and offers Undo for 5 s.
Future<void> deleteExpenseWithUndo(BuildContext context, WidgetRef ref, Expense expense, String title) async {
  final repo = ref.read(expenseRepositoryProvider);
  final l10n = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  try {
    await repo.delete(expense.id);
  } catch (e) {
    final offline = AppFailure.from(e) is NetworkFailure;
    messenger.showSnackBar(
      SnackBar(
        content: Text(offline ? l10n.signInNetworkError : l10n.errorGeneric),
        margin: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 116),
      ),
    );
    return;
  }
  showUndoToast(
    messenger,
    message: l10n.expenseDeleted(title),
    actionLabel: l10n.undo,
    onUndo: () => unawaited(
      repo.restore(expense).catchError((Object e) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.errorGeneric)));
      }),
    ),
  );
}
