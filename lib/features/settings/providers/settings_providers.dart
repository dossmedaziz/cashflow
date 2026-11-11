import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/utils/money.dart';
import '../../auth/providers/auth_providers.dart';
import '../data/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => SupabaseProfileRepository(ref.watch(supabaseClientProvider), ref.watch(userIdProvider)),
);

/// Current UI language. Switching it rebuilds MaterialApp with the new
/// locale and text direction instantly — no restart.
class LanguageController extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => ref.watch(settingsRepositoryProvider).language;

  Future<void> set(AppLanguage language) async {
    state = language;
    await ref.read(settingsRepositoryProvider).setLanguage(language);
  }
}

final languageProvider = NotifierProvider<LanguageController, AppLanguage>(LanguageController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ref.watch(settingsRepositoryProvider).themeMode;

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref.read(settingsRepositoryProvider).setThemeMode(mode);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class CurrencyController extends Notifier<Currency> {
  @override
  Currency build() {
    // Pull the account's currency once per signed-in user.
    final user = ref.watch(currentUserProvider);
    if (user != null) Future.microtask(_syncFromProfile);
    return ref.read(settingsRepositoryProvider).currency;
  }

  Future<void> _syncFromProfile() async {
    try {
      final code = await ref.read(profileRepositoryProvider).fetchCurrency();
      if (code == null) return;
      final remote = Currency.byCode(code);
      if (remote != state) {
        state = remote;
        await ref.read(settingsRepositoryProvider).setCurrency(remote);
      }
    } catch (_) {
      // Offline: keep the device value.
    }
  }

  Future<void> set(Currency currency) async {
    state = currency;
    await ref.read(settingsRepositoryProvider).setCurrency(currency);
    try {
      await ref.read(profileRepositoryProvider).updateCurrency(currency.code);
    } catch (_) {
      // Saved locally; the account copy syncs next time.
    }
  }
}

final currencyProvider = NotifierProvider<CurrencyController, Currency>(CurrencyController.new);
