// Renders README screenshots of the real screens with demo data.
//
//   SCREENSHOTS=1 flutter test test/screenshots
//
// Writes PNGs to docs/screenshots/. Skipped in a normal `flutter test` run.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:cashflow/app.dart';
import 'package:cashflow/core/l10n/l10n.dart';
import 'package:cashflow/core/providers.dart';
import 'package:cashflow/features/auth/data/auth_repository.dart';
import 'package:cashflow/features/auth/providers/auth_providers.dart';
import 'package:cashflow/features/categories/providers/categories_providers.dart';
import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:cashflow/features/expenses/providers/expenses_providers.dart';
import 'package:cashflow/features/settings/providers/settings_providers.dart';
import 'package:cashflow/features/today_widget/providers/today_widget_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fakes/fakes.dart';

final _enabled = Platform.environment.containsKey('SCREENSHOTS');
final _now = DateTime(2026, 11, 11, 14);
const _outDir = 'docs/screenshots';
final _boundary = GlobalKey();

Future<void> _loadFonts() async {
  Future<void> family(String name, List<String> files) async {
    final loader = FontLoader(name);
    for (final f in files) {
      loader.addFont(rootBundle.load('assets/fonts/$f.ttf'));
    }
    await loader.load();
  }

  await family('Inter', ['Inter-Regular', 'Inter-Medium', 'Inter-SemiBold', 'Inter-Bold', 'Inter-ExtraBold']);
  await family('IBMPlexSansArabic', [
    'IBMPlexSansArabic-Regular',
    'IBMPlexSansArabic-Medium',
    'IBMPlexSansArabic-SemiBold',
    'IBMPlexSansArabic-Bold',
  ]);
}

/// The design's sample month: 1,284.500 TND, 12% less than October.
List<Expense> _demo(String lang) {
  String t(String ar, String en, String fr) => switch (lang) { 'ar' => ar, 'fr' => fr, _ => en };
  Expense e(String id, int amount, String cat, DateTime d, String note) =>
      Expense(id: id, amount: amount, categoryId: cat, date: d, note: note);
  return [
    e('e3', 23750, 'health', DateTime(2026, 11, 11, 13, 5), t('صيدلية', 'Pharmacy', 'Pharmacie')),
    e('e1', 8500, 'food', DateTime(2026, 11, 11, 9, 40), t('قهوة مع الأصدقاء', 'Coffee with friends', 'Café entre amis')),
    e('e2', 12000, 'transport', DateTime(2026, 11, 11, 8, 15), t('تاكسي إلى العمل', 'Taxi to work', 'Taxi pour le bureau')),
    e('e4', 96400, 'bills', DateTime(2026, 11, 10, 18, 30), t('فاتورة الكهرباء', 'Electricity bill', 'Facture d’électricité')),
    e('e5', 34200, 'food', DateTime(2026, 11, 10, 11, 20), t('سوق الخضار', 'Vegetable market', 'Marché aux légumes')),
    e('e6', 189000, 'shopping', DateTime(2026, 11, 10, 10, 2), t('حذاء رياضي', 'Running shoes', 'Chaussures de sport')),
    e('e7', 45000, 'bills', DateTime(2026, 11, 9, 20, 10), t('اشتراك الإنترنت', 'Internet plan', 'Abonnement Internet')),
    e('e8', 60000, 'other', DateTime(2026, 11, 9, 17, 45), t('هدية عيد ميلاد', 'Birthday gift', 'Cadeau d’anniversaire')),
    e('e9', 600000, 'bills', DateTime(2026, 11, 3, 9), t('الإيجار', 'Rent', 'Loyer')),
    e('e10', 215650, 'food', DateTime(2026, 11, 5, 18), t('المغازة', 'Supermarket', 'Supermarché')),
    e('oct', 1459660, 'other', DateTime(2026, 10, 15), t('أكتوبر', 'October', 'Octobre')),
  ];
}

class _Shot {
  _Shot(this.tester);

  final WidgetTester tester;
  late final InMemoryExpenseRepository expenses;
  late final InMemoryCategoryRepository categories;
  late final ProviderContainer container;

  Future<void> start({String lang = 'ar', bool light = false, bool signedIn = true, bool empty = false}) async {
    SharedPreferences.setMockInitialValues({
      'settings.language': lang,
      'settings.theme': light ? 'light' : 'dark',
    });
    final prefs = await SharedPreferences.getInstance();
    tester.view
      ..physicalSize = const Size(390 * 3, 844 * 3)
      ..devicePixelRatio = 3
      ..padding = const FakeViewPadding(top: 47 * 3, bottom: 34 * 3);
    tester.platformDispatcher.accessibilityFeaturesTestValue = const _NoMotion();
    addTearDown(() {
      tester.view.reset();
      tester.platformDispatcher.clearAccessibilityFeaturesTestValue();
    });

    expenses = InMemoryExpenseRepository();
    if (!empty) expenses.seed(_demo(lang));
    categories = InMemoryCategoryRepository(expenses: expenses);
    final user = AppUser(
      id: 'u1',
      name: lang == 'ar' ? 'أمين بن علي' : 'Amine Ben Ali',
      email: 'amine.b@gmail.com',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          clockProvider.overrideWithValue(() => _now),
          authRepositoryProvider.overrideWithValue(FakeAuthRepository(user: signedIn ? user : null)),
          categoryRepositoryProvider.overrideWithValue(categories),
          expenseRepositoryProvider.overrideWithValue(expenses),
          profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
          todayWidgetBridgeProvider.overrideWithValue(FakeTodayWidgetBridge()),
        ],
        child: RepaintBoundary(key: _boundary, child: const CashflowApp()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(String key) async {
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  Future<void> save(String name) async {
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final boundary = _boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('$_outDir/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
    });
  }
}

class _NoMotion implements ui.AccessibilityFeatures {
  const _NoMotion();

  @override
  bool get disableAnimations => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => false;
}

void main() {
  setUpAll(() async {
    await initIntl();
    await _loadFonts();
  });

  void shot(String name, Future<void> Function(_Shot s) body) {
    testWidgets(name, (tester) async => body(_Shot(tester)), skip: !_enabled);
  }

  shot('01-login', (s) async {
    await s.start(signedIn: false);
    await s.save('01-login');
  });

  shot('02-home', (s) async {
    await s.start();
    await s.save('02-home');
  });

  shot('03-empty', (s) async {
    await s.start(empty: true);
    await s.save('03-empty');
  });

  shot('04-add-expense', (s) async {
    await s.start();
    await s.tapKey('add-expense');
    for (final k in ['2', '4', '.', '5']) {
      await s.tester.tap(find.byKey(ValueKey('key-$k')));
      await s.tester.pump();
    }
    await s.tapKey('pick-food');
    await s.save('04-add-expense');
  });

  shot('05-edit-expense', (s) async {
    await s.start();
    await s.tester.tap(find.text('فاتورة الكهرباء'));
    await s.tester.pumpAndSettle();
    await s.save('05-edit-expense');
  });

  shot('06-categories', (s) async {
    await s.start();
    await s.tester.tap(find.bySemanticsLabel('الفئات').first);
    await s.tester.pumpAndSettle();
    await s.save('06-categories');
  });

  shot('07-new-category', (s) async {
    await s.start();
    await s.tester.tap(find.bySemanticsLabel('الفئات').first);
    await s.tester.pumpAndSettle();
    await s.tester.tap(find.bySemanticsLabel('إضافة فئة').first);
    await s.tester.pumpAndSettle();
    await s.tester.enterText(find.byType(TextField), 'رياضة');
    await s.tester.pump();
    await s.save('07-new-category');
  });

  shot('08-settings', (s) async {
    await s.start();
    await s.tester.tap(find.text('أ'));
    await s.tester.pumpAndSettle();
    await s.save('08-settings');
  });

  shot('09-home-en', (s) async {
    await s.start(lang: 'en');
    await s.save('09-home-en');
  });

  shot('10-add-fr', (s) async {
    await s.start(lang: 'fr');
    await s.tapKey('add-expense');
    for (final k in ['2', '4', '.', '5']) {
      await s.tester.tap(find.byKey(ValueKey('key-$k')));
      await s.tester.pump();
    }
    await s.tapKey('pick-food');
    await s.save('10-add-fr');
  });

  shot('11-home-light', (s) async {
    await s.start(light: true);
    await s.save('11-home-light');
  });
}
