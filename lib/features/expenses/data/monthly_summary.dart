import '../../../core/utils/dates.dart';
import 'expense.dart';

enum Trend { less, more, same }

/// Month total and comparison with the previous month.
class MonthlySummary {
  const MonthlySummary({
    required this.month,
    required this.total,
    required this.previousTotal,
    required this.count,
  });

  /// First day of the month being summarized.
  final DateTime month;

  /// In thousandths.
  final int total;
  final int previousTotal;
  final int count;

  /// Comparison is only meaningful when last month had spending.
  bool get hasComparison => previousTotal > 0;

  Trend get trend => total < previousTotal
      ? Trend.less
      : total > previousTotal
          ? Trend.more
          : Trend.same;

  /// Whole-percent change vs. last month (always ≥ 0; see [trend]).
  int get percentChange {
    if (previousTotal == 0) return 0;
    final diff = (total - previousTotal).abs();
    // Integer rounding (half up) without doubles.
    return (diff * 100 + previousTotal ~/ 2) ~/ previousTotal;
  }

  /// Computes the summary for the month containing [now].
  static MonthlySummary compute(Iterable<Expense> expenses, DateTime now, {String? categoryId}) {
    final month = startOfMonth(now);
    final prev = startOfPreviousMonth(now);
    var total = 0, previous = 0, count = 0;
    for (final e in expenses) {
      if (categoryId != null && e.categoryId != categoryId) continue;
      if (isSameMonth(e.date, month)) {
        total += e.amount;
        count++;
      } else if (isSameMonth(e.date, prev)) {
        previous += e.amount;
      }
    }
    return MonthlySummary(month: month, total: total, previousTotal: previous, count: count);
  }
}

/// Expenses of one calendar day, newest first.
class DayGroup {
  const DayGroup({required this.day, required this.expenses});

  final DateTime day;
  final List<Expense> expenses;

  int get total => expenses.fold(0, (sum, e) => sum + e.amount);
}

/// Groups this month's expenses by day (newest day first).
List<DayGroup> groupByDay(Iterable<Expense> expenses, DateTime now, {String? categoryId}) {
  final map = <DateTime, List<Expense>>{};
  for (final e in expenses) {
    if (!isSameMonth(e.date, now)) continue;
    if (categoryId != null && e.categoryId != categoryId) continue;
    map.putIfAbsent(dateOnly(e.date), () => []).add(e);
  }
  final days = map.keys.toList()..sort((a, b) => b.compareTo(a));
  return [
    for (final d in days) DayGroup(day: d, expenses: map[d]!..sort((a, b) => b.date.compareTo(a.date))),
  ];
}

/// Per-category count and total for the month containing [now].
Map<String, ({int count, int total})> categoryStats(Iterable<Expense> expenses, DateTime now) {
  final out = <String, ({int count, int total})>{};
  for (final e in expenses) {
    if (!isSameMonth(e.date, now)) continue;
    final s = out[e.categoryId] ?? (count: 0, total: 0);
    out[e.categoryId] = (count: s.count + 1, total: s.total + e.amount);
  }
  return out;
}
