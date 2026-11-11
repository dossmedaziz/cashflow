import 'package:cashflow/core/l10n/l10n.dart';
import 'package:cashflow/core/utils/money.dart';
import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:cashflow/features/today_widget/data/today_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(initIntl);

  final now = DateTime(2026, 11, 11, 15);
  final expenses = [
    Expense(id: 'a', amount: 23750, categoryId: 'health', date: DateTime(2026, 11, 11, 13, 5)),
    Expense(id: 'b', amount: 8500, categoryId: 'food', date: DateTime(2026, 11, 11, 9, 40)),
    Expense(id: 'c', amount: 12000, categoryId: 'transport', date: DateTime(2026, 11, 11, 8, 15)),
    Expense(id: 'y', amount: 96400, categoryId: 'bills', date: DateTime(2026, 11, 10, 18, 30)),
  ];

  test('sums only today, Arabic RTL by default', () {
    final d = TodayWidgetData.compute(
      expenses: expenses,
      now: now,
      currency: Currency.tnd,
      language: AppLanguage.ar,
      dark: true,
    );
    expect(d.amount, '44.250');
    expect(d.currency, 'د.ت');
    expect(d.label, 'اليوم');
    expect(d.rtl, isTrue);
    expect(d.isZero, isFalse);
    expect(d.date, '2026-11-11');
    expect(d.semantics, 'مصاريف اليوم: 44.250 د.ت');
  });

  test('French formatting, LTR, light', () {
    final d = TodayWidgetData.compute(
      expenses: expenses,
      now: now,
      currency: Currency.tnd,
      language: AppLanguage.fr,
      dark: false,
    );
    expect(d.amount, '44,250');
    expect(d.label, 'Aujourd’hui');
    expect(d.rtl, isFalse);
    expect(d.dark, isFalse);
    expect(d.toMap()['today_dark'], false);
  });

  test('nothing today → zero in the currency format', () {
    final d = TodayWidgetData.compute(
      expenses: expenses,
      now: DateTime(2026, 11, 12, 8),
      currency: Currency.eur,
      language: AppLanguage.en,
      dark: true,
    );
    expect(d.amount, '0.00');
    expect(d.zeroAmount, '0.00');
    expect(d.isZero, isTrue);
  });

  test('widget link detection', () {
    expect(isAddExpenseLink(Uri.parse('cashflow://add?homeWidget')), isTrue);
    expect(isAddExpenseLink(Uri.parse('cashflow://add')), isTrue);
    expect(isAddExpenseLink(Uri.parse('https://example.com/add')), isFalse);
    expect(isAddExpenseLink(null), isFalse);
  });
}
