import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../expenses/data/expense.dart';

/// What the home-screen "Today" widget shows: one number, today's spending.
@immutable
class TodayWidgetData {
  const TodayWidgetData({
    required this.date,
    required this.amount,
    required this.zeroAmount,
    required this.isZero,
    required this.currency,
    required this.label,
    required this.semantics,
    required this.rtl,
    required this.dark,
  });

  /// Day the total belongs to (`yyyy-MM-dd`). The native widget shows
  /// [zeroAmount] once the device date moves past it.
  final String date;

  /// Formatted total, e.g. `44.250` / `44,250`.
  final String amount;
  final String zeroAmount;
  final bool isZero;
  final String currency;

  /// "Today" in the app language.
  final String label;

  /// Screen-reader description.
  final String semantics;
  final bool rtl;
  final bool dark;

  static TodayWidgetData compute({
    required Iterable<Expense> expenses,
    required DateTime now,
    required Currency currency,
    required AppLanguage language,
    required bool dark,
  }) {
    final l10n = lookupAppLocalizations(language.locale);
    final lang = language.name;
    final total = expenses.where((e) => isSameDay(e.date, now)).fold<int>(0, (sum, e) => sum + e.amount);
    final amount = MoneyFormat.format(total, currency, lang);
    final symbol = currency.symbolFor(lang);
    return TodayWidgetData(
      date: DateFormat('yyyy-MM-dd', 'en').format(now),
      amount: amount,
      zeroAmount: MoneyFormat.format(0, currency, lang),
      isZero: total == 0,
      currency: symbol,
      label: l10n.today,
      semantics: l10n.widgetTodayA11y(amount, symbol),
      rtl: language.isRtl,
      dark: dark,
    );
  }

  Map<String, Object> toMap() => {
        'today_date': date,
        'today_amount': amount,
        'today_zero': zeroAmount,
        'today_is_zero': isZero,
        'today_currency': currency,
        'today_label': label,
        'today_a11y': semantics,
        'today_rtl': rtl,
        'today_dark': dark,
      };

  @override
  bool operator ==(Object other) => other is TodayWidgetData && mapEquals(other.toMap(), toMap());

  @override
  int get hashCode => Object.hashAll(toMap().values);
}

/// Bridge to the native widget. Interface so tests can swap it out.
abstract interface class TodayWidgetBridge {
  Future<void> init();

  Future<void> push(TodayWidgetData data);

  /// URI the app was cold-started from (widget tap), if any.
  Future<Uri?> initialLaunch();

  /// Widget taps while the app is running.
  Stream<Uri?> get clicks;
}

class HomeWidgetBridge implements TodayWidgetBridge {
  static const appGroupId = 'group.com.cashflow.cashflow';
  static const androidProvider = 'TodayWidgetProvider';
  static const iOSKind = 'TodayWidget';

  bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Future<void> init() async {
    if (!kIsWeb && Platform.isIOS) await HomeWidget.setAppGroupId(appGroupId);
  }

  @override
  Future<void> push(TodayWidgetData data) async {
    if (!_supported) return;
    try {
      await Future.wait([for (final e in data.toMap().entries) HomeWidget.saveWidgetData<Object>(e.key, e.value)]);
      await HomeWidget.updateWidget(androidName: androidProvider, iOSName: iOSKind);
    } catch (e) {
      // The widget is a convenience; never break the app over it.
      debugPrint('Today widget update failed: $e');
    }
  }

  @override
  Future<Uri?> initialLaunch() async {
    if (!_supported) return null;
    try {
      return await HomeWidget.initiallyLaunchedFromHomeWidget();
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<Uri?> get clicks => _supported ? HomeWidget.widgetClicked : const Stream.empty();
}

/// Deep link the widget opens: `cashflow://add` → Add sheet.
bool isAddExpenseLink(Uri? uri) => uri != null && uri.scheme == 'cashflow' && uri.host == 'add';
