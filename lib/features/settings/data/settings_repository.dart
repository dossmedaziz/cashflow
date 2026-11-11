import 'package:flutter/material.dart' show ThemeMode;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/failures.dart';
import '../../../core/utils/money.dart';

/// Device-local preferences: language, theme, currency.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _kLanguage = 'settings.language';
  static const _kTheme = 'settings.theme';
  static const _kCurrency = 'settings.currency';

  /// Arabic by default.
  AppLanguage get language => AppLanguage.fromCode(_prefs.getString(_kLanguage));
  Future<void> setLanguage(AppLanguage l) => _prefs.setString(_kLanguage, l.name);

  /// Dark by default.
  ThemeMode get themeMode => _prefs.getString(_kTheme) == 'light' ? ThemeMode.light : ThemeMode.dark;
  Future<void> setThemeMode(ThemeMode m) => _prefs.setString(_kTheme, m == ThemeMode.light ? 'light' : 'dark');

  /// TND by default.
  Currency get currency => Currency.byCode(_prefs.getString(_kCurrency));
  Future<void> setCurrency(Currency c) => _prefs.setString(_kCurrency, c.code);
}

/// The user's profile row (currency is synced so it follows the account).
abstract interface class ProfileRepository {
  Future<String?> fetchCurrency();

  Future<void> updateCurrency(String code);
}

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(this._client, this._userId);

  final SupabaseClient _client;
  final String _userId;

  @override
  Future<String?> fetchCurrency() async {
    try {
      final row = await _client.from('profiles').select('currency').eq('id', _userId).maybeSingle();
      return row?['currency'] as String?;
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  @override
  Future<void> updateCurrency(String code) async {
    try {
      await _client.from('profiles').update({'currency': code}).eq('id', _userId);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}
