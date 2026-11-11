import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// Supported UI languages. Arabic is the default and runs right-to-left.
enum AppLanguage {
  ar('العربية', 'ع'),
  fr('Français', 'FR'),
  en('English', 'EN');

  const AppLanguage(this.nativeName, this.shortLabel);

  final String nativeName;
  final String shortLabel;

  Locale get locale => Locale(name);

  bool get isRtl => this == AppLanguage.ar;

  static AppLanguage fromCode(String? code) =>
      AppLanguage.values.firstWhere((l) => l.name == code, orElse: () => AppLanguage.ar);
}

/// Loads intl date symbols and forces Western digits (0–9) everywhere.
Future<void> initIntl() async {
  for (final l in AppLanguage.values) {
    await initializeDateFormatting(l.name);
    DateFormat.useNativeDigitsByDefaultFor(l.name, false);
  }
}

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// 'ar' | 'fr' | 'en'
  String get lang => Localizations.localeOf(this).languageCode;
}
