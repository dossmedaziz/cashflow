import '../../../core/utils/dates.dart';
import 'expense.dart';

enum Trend { less, more, same }

/// Period shown on the Home total card. Weeks start on Monday.
enum SummaryPeriod {
  day,
  week,
  month;

  static SummaryPeriod fromName(String? name) =>
      SummaryPeriod.values.firstWhere((p) => p.name == name, orElse: () => SummaryPeriod.month);

  /// First instant of the period containing [now].
  DateTime startOf(DateTime now) => switch (this) {
        SummaryPeriod.day => dateOnly(now),
        SummaryPeriod.week => startOfWeek(now),
        SummaryPeriod.month => startOfMonth(now),
      };

  /// First instant of the next period (exclusive end).
  DateTime endOf(DateTime now) => switch (this) {
        SummaryPeriod.day => DateTime(now.year, now.month, now.day + 1),
        SummaryPeriod.week => DateTime(startOfWeek(now).year, startOfWeek(now).month, startOfWeek(now).day + 7),
        SummaryPeriod.month => startOfNextMonth(now),
      };

  /// Start of the period before (yesterday, last week, last month).
  DateTime previousStartOf(DateTime now) => switch (this) {
        SummaryPeriod.day => DateTime(now.year, now.month, now.day - 1),
        SummaryPeriod.week => DateTime(startOfWeek(now).year, startOfWeek(now).month, startOfWeek(now).day - 7),
        SummaryPeriod.month => startOfPreviousMonth(now),
      };
}

/// Total for a period (today / this week / this month) and the comparison
/// with the period before it.
class PeriodSummary {
  const PeriodSummary({
    required this.period,
    required this.start,
    required this.end,
    required this.total,
    required this.previousTotal,
    required this.count,
  });

  final SummaryPeriod period;

  /// Inclusive start / exclusive end of the current period.
  final DateTime start;
  final DateTime end;

  /// In thousandths.
  final int total;
  final int previousTotal;
  final int count;

  /// Comparison is only meaningful when the previous period had spending.
  bool get hasComparison => previousTotal > 0;

  Trend get trend => total < previousTotal
      ? Trend.less
      : total > previousTotal
          ? Trend.more
          : Trend.same;

  /// Whole-percent change vs. the previous period (always ≥ 0; see [trend]).
  int get percentChange {
    if (previousTotal == 0) return 0;
    final diff = (total - previousTotal).abs();
    // Integer rounding (half up) without doubles.
    return (diff * 100 + previousTotal ~/ 2) ~/ previousTotal;
  }

  /// Computes the summary for the [period] containing [now].
  static PeriodSummary compute(
    Iterable<Expense> expenses,
    DateTime now, {
    SummaryPeriod period = SummaryPeriod.month,
    String? categoryId,
  }) {
    final start = period.startOf(now);
    final end = period.endOf(now);
    final prevStart = period.previousStartOf(now);
    var total = 0, previous = 0, count = 0;
    for (final e in expenses) {
      if (categoryId != null && e.categoryId != categoryId) continue;
      if (!e.date.isBefore(start) && e.date.isBefore(end)) {
        total += e.amount;
        count++;
      } else if (!e.date.isBefore(prevStart) && e.date.isBefore(start)) {
        previous += e.amount;
      }
    }
    return PeriodSummary(
      period: period,
      start: start,
      end: end,
      total: total,
      previousTotal: previous,
      count: count,
    );
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
