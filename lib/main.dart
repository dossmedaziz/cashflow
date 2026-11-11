import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/l10n/l10n.dart';
import 'core/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final results = await Future.wait<Object?>([
    SharedPreferences.getInstance(),
    Supabase.initialize(url: Env.supabaseUrl, publishableKey: Env.supabasePublishableKey),
    initIntl(),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(results[0]! as SharedPreferences),
        supabaseClientProvider.overrideWithValue(Supabase.instance.client),
      ],
      child: const CashflowApp(),
    ),
  );
}
