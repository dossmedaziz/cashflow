import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:cashflow/features/expenses/data/monthly_summary.dart';
import 'package:flutter_test/flutter_test.dart';

Expense e(String id, int amount, DateTime date, {String cat = 'food'}) =>
    Expense(id: id, amount: amount, categoryId: cat, date: date);

void main() {
  final now = DateTime(2026, 11, 11, 10);

  group('MonthlySummary.compute', () {
    test('sums only this month and last month', () {
      final s = MonthlySummary.compute([
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
      expect(s.month, DateTime(2026, 11));
    });

    test('less than last month → rounded percent', () {
      // 1,284.500 vs 1,459.659 → 12.0% less
      final s = MonthlySummary(month: DateTime(2026, 11), total: 1284500, previousTotal: 1459659, count: 8);
      expect(s.trend, Trend.less);
      expect(s.percentChange, 12);
      expect(s.hasComparison, isTrue);
    });

    test('more than last month', () {
      final s = MonthlySummary(month: DateTime(2026, 11), total: 150000, previousTotal: 100000, count: 3);
      expect(s.trend, Trend.more);
      expect(s.percentChange, 50);
    });

    test('rounds half up', () {
      // 1/8 = 12.5% → 13
      final s = MonthlySummary(month: DateTime(2026, 11), total: 7000, previousTotal: 8000, count: 1);
      expect(s.percentChange, 13);
    });

    test('no comparison when last month is empty', () {
      final s = MonthlySummary.compute([e('a', 5000, now)], now);
      expect(s.hasComparison, isFalse);
      expect(s.percentChange, 0);
    });

    test('same total', () {
      final s = MonthlySummary(month: DateTime(2026, 11), total: 5000, previousTotal: 5000, count: 1);
      expect(s.trend, Trend.same);
      expect(s.percentChange, 0);
    });

    test('January compares with December of the previous year', () {
      final jan = DateTime(2027, 1, 5);
      final s = MonthlySummary.compute([e('a', 3000, DateTime(2027, 1, 2)), e('b', 6000, DateTime(2026, 12, 20))], jan);
      expect(s.total, 3000);
      expect(s.previousTotal, 6000);
      expect(s.percentChange, 50);
    });

    test('can be filtered by category', () {
      final s = MonthlySummary.compute(
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
