import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/l10n.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_providers.dart';
import 'features/today_widget/ui/today_widget_sync.dart';

class CashflowApp extends ConsumerWidget {
  const CashflowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);
    final arabic = language == AppLanguage.ar;

    return MaterialApp.router(
      title: 'Cashflow',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      // Changing the locale flips the whole app between RTL and LTR live.
      locale: language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: themeMode,
      theme: AppTheme.light(arabic: arabic),
      darkTheme: AppTheme.dark(arabic: arabic),
      themeAnimationDuration: const Duration(milliseconds: 200),
      // Keeps the home-screen "Today" widget up to date.
      builder: (context, child) => TodayWidgetSync(child: child ?? const SizedBox.shrink()),
    );
  }
}
