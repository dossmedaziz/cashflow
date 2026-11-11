import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/utils/dates.dart';
import '../../auth/providers/auth_providers.dart';
import '../../settings/providers/settings_providers.dart';
import '../data/expense.dart';
import '../data/expense_repository.dart';
import '../data/summary.dart';
import '../data/supabase_expense_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final repo = SupabaseExpenseRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(userIdProvider),
    ref.watch(snapshotCacheProvider),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

/// Start of the current month (re-evaluated when the app rebuilds).
final currentMonthProvider = Provider<DateTime>((ref) => startOfMonth(ref.watch(clockProvider)()));

/// Expenses of this month and last month (needed for the comparison).
final expensesProvider = StreamProvider<List<Expense>>((ref) {
  final from = startOfPreviousMonth(ref.watch(currentMonthProvider));
  return ref.watch(expenseRepositoryProvider).watchSince(from);
});

/// Selected category chip on Home; null = All.
class CategoryFilter extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}

final categoryFilterProvider = NotifierProvider<CategoryFilter, String?>(CategoryFilter.new);

/// This month's total (all categories).
final monthlySummaryProvider = Provider<AsyncValue<PeriodSummary>>((ref) {
  final now = ref.watch(clockProvider)();
  return ref.watch(expensesProvider).whenData((list) => PeriodSummary.compute(list, now));
});

/// Period chosen on the Home total card (today / this week / this month).
/// Remembered on the device.
class SummaryPeriodController extends Notifier<SummaryPeriod> {
  @override
  SummaryPeriod build() => SummaryPeriod.fromName(ref.watch(settingsRepositoryProvider).heroPeriod);

  Future<void> set(SummaryPeriod period) async {
    state = period;
    await ref.read(settingsRepositoryProvider).setHeroPeriod(period.name);
  }
}

final summaryPeriodProvider = NotifierProvider<SummaryPeriodController, SummaryPeriod>(SummaryPeriodController.new);

/// Total card: selected period + comparison with the one before
/// (all categories, as in the design).
final heroSummaryProvider = Provider<AsyncValue<PeriodSummary>>((ref) {
  final now = ref.watch(clockProvider)();
  final period = ref.watch(summaryPeriodProvider);
  return ref.watch(expensesProvider).whenData((list) => PeriodSummary.compute(list, now, period: period));
});

/// This month's expenses grouped by day, filtered by the selected chip.
final dayGroupsProvider = Provider<AsyncValue<List<DayGroup>>>((ref) {
  final now = ref.watch(clockProvider)();
  final filter = ref.watch(categoryFilterProvider);
  return ref.watch(expensesProvider).whenData((list) => groupByDay(list, now, categoryId: filter));
});

/// Per-category count/total for this month (Categories screen).
final categoryStatsProvider = Provider<Map<String, ({int count, int total})>>((ref) {
  final now = ref.watch(clockProvider)();
  final list = ref.watch(expensesProvider).value ?? const [];
  return categoryStats(list, now);
});
