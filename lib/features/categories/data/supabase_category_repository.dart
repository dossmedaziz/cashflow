import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/snapshot_cache.dart';
import '../../../core/utils/failures.dart';
import '../../../core/utils/value_store.dart';
import 'category.dart';
import 'category_repository.dart';

class SupabaseCategoryRepository implements CategoryRepository {
  SupabaseCategoryRepository(this._client, this._userId, this._snapshots) {
    final cached = _snapshots.read(_scope, _userId);
    if (cached != null) _store.value = _sorted(cached.map(Category.fromJson));
  }

  static const _scope = 'categories';
  static const _columns = 'id,name,default_key,color_hex,icon_key,sort_order,is_default';

  final SupabaseClient _client;
  final String _userId;
  final SnapshotCache _snapshots;
  final _store = ValueStore<List<Category>>();
  bool _loaded = false;

  SupabaseQueryBuilder get _table => _client.from('categories');

  List<Category> get _current => _store.value ?? const [];

  static List<Category> _sorted(Iterable<Category> list) => list.toList()..sort((a, b) => a.order.compareTo(b.order));

  void _emit(Iterable<Category> list) {
    final sorted = _sorted(list);
    _store.value = sorted;
    unawaited(_snapshots.write(_scope, _userId, sorted.map((c) => c.toJson()).toList()));
  }

  @override
  Stream<List<Category>> watchAll() {
    if (!_loaded) refresh().ignore();
    return _store.stream;
  }

  @override
  Future<void> refresh() async {
    try {
      final rows = await _table.select(_columns).order('sort_order');
      _loaded = true;
      _emit(rows.map(Category.fromJson));
    } catch (e, st) {
      final failure = AppFailure.from(e);
      // Keep showing the device snapshot when offline.
      if (!_store.hasValue) _store.addError(failure, st);
      throw failure;
    }
  }

  @override
  Future<Category> create(CategoryInput input) async {
    final nextOrder = _current.isEmpty ? 0 : _current.map((c) => c.order).reduce((a, b) => a > b ? a : b) + 1;
    try {
      final row = await _table
          .insert({
            'user_id': _userId,
            'name': input.name?.trim(),
            'color_hex': input.colorHex,
            'icon_key': input.iconKey,
            'sort_order': nextOrder,
          })
          .select(_columns)
          .single();
      final created = Category.fromJson(row);
      _emit([..._current, created]);
      return created;
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  @override
  Future<Category> update(String id, CategoryInput input) async {
    final previous = _current;
    final old = previous.firstWhere((c) => c.id == id);
    final optimistic = old.copyWith(
      name: input.name?.trim(),
      clearName: input.name == null,
      colorHex: input.colorHex,
      iconKey: input.iconKey,
    );
    _emit([for (final c in previous) c.id == id ? optimistic : c]);
    try {
      final row = await _table
          .update({'name': input.name?.trim(), 'color_hex': input.colorHex, 'icon_key': input.iconKey})
          .eq('id', id)
          .select(_columns)
          .single();
      final saved = Category.fromJson(row);
      _emit([for (final c in _current) c.id == id ? saved : c]);
      return saved;
    } catch (e) {
      _emit(previous);
      throw AppFailure.from(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    final previous = _current;
    _emit(previous.where((c) => c.id != id));
    try {
      await _client.rpc<void>('delete_category', params: {'p_category_id': id});
    } catch (e) {
      _emit(previous);
      throw AppFailure.from(e);
    }
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    final previous = _current;
    final byId = {for (final c in previous) c.id: c};
    _emit([
      for (var i = 0; i < orderedIds.length; i++)
        if (byId[orderedIds[i]] != null) byId[orderedIds[i]]!.copyWith(order: i),
    ]);
    try {
      await _client.rpc<void>('reorder_categories', params: {'p_ids': orderedIds});
    } catch (e) {
      _emit(previous);
      throw AppFailure.from(e);
    }
  }

  @override
  void dispose() => _store.close();
}
