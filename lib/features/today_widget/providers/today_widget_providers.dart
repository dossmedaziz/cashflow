import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../../expenses/providers/expenses_providers.dart';
import '../../settings/providers/settings_providers.dart';
import '../data/today_widget.dart';

final todayWidgetBridgeProvider = Provider<TodayWidgetBridge>((ref) => HomeWidgetBridge());

/// Today's total as the widget should show it. Signed out → 0.
final todayWidgetDataProvider = Provider<TodayWidgetData?>((ref) {
  final signedIn = ref.watch(currentUserProvider) != null;
  final expenses = signedIn ? ref.watch(expensesProvider) : null;
  // Wait for real data rather than flashing 0 while loading.
  if (signedIn && expenses?.hasValue != true) return null;
  return TodayWidgetData.compute(
    expenses: expenses?.value ?? const [],
    now: ref.watch(clockProvider)(),
    currency: ref.watch(currencyProvider),
    language: ref.watch(languageProvider),
    dark: ref.watch(themeModeProvider) != ThemeMode.light,
  );
});
