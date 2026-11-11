import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/utils/dates.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/expense.dart';
import '../data/expense_repository.dart';
import '../data/monthly_summary.dart';
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

/// Month total + comparison with last month (all categories, as in the design).
final monthlySummaryProvider = Provider<AsyncValue<MonthlySummary>>((ref) {
  final now = ref.watch(clockProvider)();
  return ref.watch(expensesProvider).whenData((list) => MonthlySummary.compute(list, now));
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
