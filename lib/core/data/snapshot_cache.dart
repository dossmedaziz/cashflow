import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persists the last successful server snapshot on the device so the app
/// can still show data when it starts offline. Read-only cache; writes
/// always go to the backend.
class SnapshotCache {
  SnapshotCache(this._prefs);

  final SharedPreferences _prefs;

  String _key(String scope, String userId) => 'snapshot.$scope.$userId';

  List<Map<String, dynamic>>? read(String scope, String userId) {
    final raw = _prefs.getString(_key(scope, userId));
    if (raw == null) return null;
    try {
      return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
    } on FormatException {
      return null;
    }
  }

  Future<void> write(String scope, String userId, List<Map<String, dynamic>> rows) =>
      _prefs.setString(_key(scope, userId), jsonEncode(rows));

  Future<void> clearUser(String userId) async {
    for (final key in _prefs.getKeys().where((k) => k.startsWith('snapshot.') && k.endsWith('.$userId'))) {
      await _prefs.remove(key);
    }
  }
}
