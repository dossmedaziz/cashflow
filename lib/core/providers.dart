import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'data/snapshot_cache.dart';

/// Overridden in main() with the loaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden'),
);

/// Overridden in main() after Supabase.initialize.
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => throw UnimplementedError('supabaseClientProvider must be overridden'),
);

/// Injectable clock so tests can pin "today".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final snapshotCacheProvider = Provider<SnapshotCache>((ref) => SnapshotCache(ref.watch(sharedPreferencesProvider)));
