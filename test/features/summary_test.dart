import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:cashflow/features/expenses/data/summary.dart';
import 'package:flutter_test/flutter_test.dart';

Expense e(String id, int amount, DateTime date, {String cat = 'food'}) =>
    Expense(id: id, amount: amount, categoryId: cat, date: date);

PeriodSummary _month(int total, int previous, int count) => PeriodSummary(
      period: SummaryPeriod.month,
      start: DateTime(2026, 11),
      end: DateTime(2026, 12),
      total: total,
      previousTotal: previous,
      count: count,
    );

void main() {
  // Wednesday 11 November 2026.
  final now = DateTime(2026, 11, 11, 10);

  group('PeriodSummary — day', () {
    test('today vs yesterday', () {
      final s = PeriodSummary.compute([
        e('a', 8500, DateTime(2026, 11, 11, 9, 40)),
        e('b', 12000, DateTime(2026, 11, 11, 0, 0)),
        e('y', 41000, DateTime(2026, 11, 10, 23, 59)),
        e('old', 99000, DateTime(2026, 11, 9, 12)),
      ], now, period: SummaryPeriod.day);
      expect(s.start, DateTime(2026, 11, 11));
      expect(s.end, DateTime(2026, 11, 12));
      expect(s.total, 20500);
      expect(s.count, 2);
      expect(s.previousTotal, 41000);
      expect(s.trend, Trend.less);
      expect(s.percentChange, 50);
    });

    test('the first of the month compares with the last day of the previous month', () {
      final s = PeriodSummary.compute(
        [e('a', 3000, DateTime(2026, 12, 1, 8)), e('b', 1000, DateTime(2026, 11, 30, 20))],
        DateTime(2026, 12, 1, 9),
        period: SummaryPeriod.day,
      );
      expect(s.total, 3000);
      expect(s.previousTotal, 1000);
      expect(s.trend, Trend.more);
      expect(s.percentChange, 200);
    });
  });

  group('PeriodSummary — week (Monday start)', () {
    test('this week vs last week', () {
      final s = PeriodSummary.compute([
        e('mon', 10000, DateTime(2026, 11, 9, 8)), // Monday, this week
        e('wed', 5000, DateTime(2026, 11, 11, 9)),
        e('sun', 20000, DateTime(2026, 11, 8, 22)), // Sunday, last week
        e('lastMon', 10000, DateTime(2026, 11, 2)), // Monday, last week
        e('older', 7000, DateTime(2026, 11, 1, 23)), // Sunday two weeks ago
      ], now, period: SummaryPeriod.week);
      expect(s.start, DateTime(2026, 11, 9));
      expect(s.end, DateTime(2026, 11, 16));
      expect(s.total, 15000);
      expect(s.previousTotal, 30000);
      expect(s.percentChange, 50);
      expect(s.trend, Trend.less);
    });

    test('a week spanning two months and years', () {
      // Thursday 1 Jan 2027 → week of Mon 28 Dec 2026.
      final s = PeriodSummary.compute(
        [e('a', 4000, DateTime(2026, 12, 29)), e('b', 2000, DateTime(2026, 12, 22))],
        DateTime(2027, 1, 1, 12),
        period: SummaryPeriod.week,
      );
      expect(s.start, DateTime(2026, 12, 28));
      expect(s.end, DateTime(2027, 1, 4));
      expect(s.total, 4000);
      expect(s.previousTotal, 2000);
    });

    test('Monday itself starts the week', () {
      expect(SummaryPeriod.week.startOf(DateTime(2026, 11, 9, 0, 1)), DateTime(2026, 11, 9));
      expect(SummaryPeriod.week.startOf(DateTime(2026, 11, 15, 23, 59)), DateTime(2026, 11, 9));
    });
  });

  test('SummaryPeriod.fromName falls back to month', () {
    expect(SummaryPeriod.fromName('week'), SummaryPeriod.week);
    expect(SummaryPeriod.fromName(null), SummaryPeriod.month);
    expect(SummaryPeriod.fromName('year'), SummaryPeriod.month);
  });

  group('PeriodSummary.compute', () {
    test('sums only this month and last month', () {
      final s = PeriodSummary.compute([
        e('a', 8500, DateTime(2026, 11, 11, 9)),
        e('b', 12000, DateTime(2026, 11, 1)),
        e('c', 100000, DateTime(2026, 10, 31, 23, 59)),
        e('d', 50000, DateTime(2026, 10, 1)),
        e('old', 999000, DateTime(2026, 9, 30)),
        e('future', 1000, DateTime(2026, 12, 1)),
      ], now);
      expect(s.total, 20500);
      expect(s.count, 2);
      expect(s.previousTotal, 150000);
      expect(s.start, DateTime(2026, 11));
      expect(s.end, DateTime(2026, 12));
    });

    test('less than last month → rounded percent', () {
      // 1,284.500 vs 1,459.659 → 12.0% less
      final s = _month(1284500, 1459659, 8);
      expect(s.trend, Trend.less);
      expect(s.percentChange, 12);
      expect(s.hasComparison, isTrue);
    });

    test('more than last month', () {
      final s = _month(150000, 100000, 3);
      expect(s.trend, Trend.more);
      expect(s.percentChange, 50);
    });

    test('rounds half up', () {
      // 1/8 = 12.5% → 13
      final s = _month(7000, 8000, 1);
      expect(s.percentChange, 13);
    });

    test('no comparison when last month is empty', () {
      final s = PeriodSummary.compute([e('a', 5000, now)], now);
      expect(s.hasComparison, isFalse);
      expect(s.percentChange, 0);
    });

    test('same total', () {
      final s = _month(5000, 5000, 1);
      expect(s.trend, Trend.same);
      expect(s.percentChange, 0);
    });

    test('January compares with December of the previous year', () {
      final jan = DateTime(2027, 1, 5);
      final s = PeriodSummary.compute([e('a', 3000, DateTime(2027, 1, 2)), e('b', 6000, DateTime(2026, 12, 20))], jan);
      expect(s.total, 3000);
      expect(s.previousTotal, 6000);
      expect(s.percentChange, 50);
    });

    test('can be filtered by category', () {
      final s = PeriodSummary.compute(
        [e('a', 1000, now), e('b', 2000, now, cat: 'bills')],
        now,
        categoryId: 'bills',
      );
      expect(s.total, 2000);
    });
  });

  group('groupByDay', () {
    test('groups this month by day, newest first, with day totals', () {
      final groups = groupByDay([
        e('1', 23750, DateTime(2026, 11, 11, 13, 5)),
        e('2', 8500, DateTime(2026, 11, 11, 9, 40)),
        e('3', 96400, DateTime(2026, 11, 10, 18, 30)),
        e('4', 1000, DateTime(2026, 10, 31)),
      ], now);
      expect(groups.map((g) => g.day), [DateTime(2026, 11, 11), DateTime(2026, 11, 10)]);
      expect(groups.first.expenses.map((x) => x.id), ['1', '2']);
      expect(groups.first.total, 32250);
    });

    test('applies the category filter', () {
      final groups = groupByDay([e('1', 1, now), e('2', 2, now, cat: 'bills')], now, categoryId: 'bills');
      expect(groups.single.expenses.single.id, '2');
    });
  });

  test('categoryStats counts and sums this month per category', () {
    final stats = categoryStats([
      e('1', 1000, now),
      e('2', 2000, now),
      e('3', 5000, now, cat: 'bills'),
      e('4', 9000, DateTime(2026, 10, 2)),
    ], now);
    expect(stats['food'], (count: 2, total: 3000));
    expect(stats['bills'], (count: 1, total: 5000));
  });
}
