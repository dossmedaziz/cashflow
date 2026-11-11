import 'dart:ui';

import 'package:cashflow/app.dart';
import 'package:cashflow/core/l10n/l10n.dart';
import 'package:cashflow/core/providers.dart';
import 'package:cashflow/features/auth/providers/auth_providers.dart';
import 'package:cashflow/features/categories/providers/categories_providers.dart';
import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:cashflow/features/expenses/providers/expenses_providers.dart';
import 'package:cashflow/features/settings/providers/settings_providers.dart';
import 'package:cashflow/features/today_widget/providers/today_widget_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fakes/fakes.dart';

final _now = DateTime(2026, 11, 11, 10, 30);

class _Harness {
  final auth = FakeAuthRepository(user: FakeAuthRepository.demoUser);
  final expenses = InMemoryExpenseRepository();
  late final categories = InMemoryCategoryRepository(expenses: expenses);
  final profile = FakeProfileRepository();
  final widget = FakeTodayWidgetBridge();

  Future<void> pump(WidgetTester tester, {String language = 'en'}) async {
    SharedPreferences.setMockInitialValues({'settings.language': language});
    final prefs = await SharedPreferences.getInstance();
    tester.view
      ..physicalSize = const Size(390 * 3, 844 * 3)
      ..devicePixelRatio = 3;
    tester.platformDispatcher.accessibilityFeaturesTestValue = const _NoMotion();
    addTearDown(() {
      tester.view.reset();
      tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          clockProvider.overrideWithValue(() => _now),
          authRepositoryProvider.overrideWithValue(auth),
          categoryRepositoryProvider.overrideWithValue(categories),
          expenseRepositoryProvider.overrideWithValue(expenses),
          profileRepositoryProvider.overrideWithValue(profile),
          todayWidgetBridgeProvider.overrideWithValue(widget),
        ],
        child: const CashflowApp(),
      ),
    );
    await tester.pumpAndSettle();
  }
}

/// Turns on "Reduce motion" so looping animations (caret) don't block settle.
class _NoMotion implements AccessibilityFeatures {
  const _NoMotion();

  @override
  bool get disableAnimations => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => false;
}

Future<void> tapKeys(WidgetTester tester, String keys) async {
  for (final k in keys.split('')) {
    await tester.tap(find.byKey(ValueKey('key-$k')));
    await tester.pump();
  }
}

void main() {
  setUpAll(initIntl);

  testWidgets('add an expense: amount, category, save → appears on Home', (tester) async {
    final h = _Harness();
    await h.pump(tester);

    expect(find.text('No expenses yet'), findsOneWidget);
    expect(find.text('Hello, Amine'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('add-expense')));
    await tester.pumpAndSettle();
    expect(find.text('New expense'), findsOneWidget);

    await tapKeys(tester, '24.5');
    expect(find.text('24.5'), findsOneWidget);

    // Category is required.
    // Category is required.
    await tester.tap(find.byKey(const ValueKey('expense-save')));
    await tester.pumpAndSettle();
    expect(find.text('Choose a category.'), findsOneWidget);
    expect(h.expenses.all, isEmpty);

    await tester.tap(find.byKey(const ValueKey('pick-food')));
    await tester.enterText(find.byType(TextField), 'Coffee with friends');
    await tester.tap(find.byKey(const ValueKey('expense-save')));
    await tester.pumpAndSettle();

    // Saved as an integer number of millimes.
    final saved = h.expenses.all.single;
    expect(saved.amount, 24500);
    expect(saved.categoryId, 'food');
    expect(saved.note, 'Coffee with friends');

    // Sheet closed; Home shows the row, the day group and the month total.
    expect(find.text('New expense'), findsNothing);
    expect(find.text('Coffee with friends'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('24.500'), findsWidgets);

    // The home-screen widget got today's new total.
    expect(h.widget.last?.amount, '24.500');
    expect(h.widget.last?.isZero, isFalse);
    expect(h.widget.last?.label, 'Today');
  });

  testWidgets('tapping the home-screen widget opens the Add sheet', (tester) async {
    final h = _Harness();
    await h.pump(tester);
    expect(h.widget.last?.amount, '0.000', reason: 'widget starts at zero');

    h.widget.tap();
    await tester.pumpAndSettle();
    expect(find.text('New expense'), findsOneWidget);
  });

  testWidgets('amount must be greater than zero', (tester) async {
    final h = _Harness();
    await h.pump(tester);

    await tester.tap(find.byKey(const ValueKey('add-expense')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('pick-food')));
    await tester.tap(find.byKey(const ValueKey('expense-save')));
    await tester.pumpAndSettle();

    expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
    expect(h.expenses.all, isEmpty);
  });

  testWidgets('Arabic is the default and lays out right-to-left', (tester) async {
    final h = _Harness();
    h.expenses.seed([
      Expense(id: 'x', amount: 96400, categoryId: 'bills', note: 'فاتورة الكهرباء', date: DateTime(2026, 11, 10, 18, 30)),
      Expense(id: 'y', amount: 120000, categoryId: 'food', date: DateTime(2026, 10, 5)),
    ]);
    await h.pump(tester, language: 'ar');

    final ctx = tester.element(find.text('فاتورة الكهرباء'));
    expect(Directionality.of(ctx), TextDirection.rtl);
    expect(find.text('أمس'), findsOneWidget, reason: 'localized "Yesterday"');
    expect(find.text('96.400'), findsWidgets, reason: 'Western digits in Arabic');
    // 96.400 vs 120.000 last month → 20% less.
    expect(find.textContaining('أقل بـ 20%'), findsOneWidget);
  });

  testWidgets('switching language to French flips to LTR without restart', (tester) async {
    final h = _Harness();
    await h.pump(tester, language: 'ar');
    expect(find.text('لا توجد مصاريف بعد'), findsOneWidget);

    final container = ProviderScope.containerOf(tester.element(find.byType(CashflowApp)));
    await container.read(languageProvider.notifier).set(AppLanguage.fr);
    await tester.pumpAndSettle();

    final ctx = tester.element(find.text('Aucune dépense pour l’instant'));
    expect(Directionality.of(ctx), TextDirection.ltr);
  });

  testWidgets('swipe to delete shows an undo toast that restores the expense', (tester) async {
    final h = _Harness();
    h.expenses.seed([
      Expense(id: 'bill', amount: 96400, categoryId: 'bills', note: 'Electricity bill', date: DateTime(2026, 11, 11, 8)),
    ]);
    await h.pump(tester);

    // LTR: swipe toward the start (left) past half the width.
    await tester.drag(find.text('Electricity bill'), const Offset(-300, 0));
    await tester.pumpAndSettle();

    expect(h.expenses.all, isEmpty);
    expect(find.text('“Electricity bill” deleted'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(h.expenses.all.single.id, 'bill');
    expect(find.text('Electricity bill'), findsOneWidget);
  });
}
