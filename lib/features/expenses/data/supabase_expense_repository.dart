import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/data/snapshot_cache.dart';
import '../../../core/utils/failures.dart';
import '../../../core/utils/value_store.dart';
import 'expense.dart';
import 'expense_repository.dart';

class SupabaseExpenseRepository implements ExpenseRepository {
  SupabaseExpenseRepository(this._client, this._userId, this._snapshots);

  static const _scope = 'expenses';
  static const _columns = 'id,amount,category_id,note,date,created_at,updated_at';

  final SupabaseClient _client;
  final String _userId;
  final SnapshotCache _snapshots;
  final _store = ValueStore<List<Expense>>();
  DateTime? _from;

  SupabaseQueryBuilder get _table => _client.from('expenses');

  List<Expense> get _current => _store.value ?? const [];

  static List<Expense> _sorted(Iterable<Expense> list) => list.toList()..sort((a, b) => b.date.compareTo(a.date));

  void _emit(Iterable<Expense> list) {
    final from = _from;
    final sorted = _sorted(from == null ? list : list.where((e) => !e.date.isBefore(from)));
    _store.value = sorted;
    unawaited(_snapshots.write(_scope, _userId, sorted.map((e) => e.toJson()).toList()));
  }

  @override
  Stream<List<Expense>> watchSince(DateTime from) {
    if (_from != from) {
      _from = from;
      final cached = _snapshots.read(_scope, _userId);
      if (cached != null && !_store.hasValue) {
        _store.value = _sorted(cached.map(Expense.fromJson).where((e) => !e.date.isBefore(from)));
      }
      refresh().ignore();
    }
    return _store.stream;
  }

  @override
  Future<void> refresh() async {
    final from = _from;
    if (from == null) return;
    try {
      final rows = await _table
          .select(_columns)
          .gte('date', from.toUtc().toIso8601String())
          .order('date', ascending: false)
          .limit(5000);
      _emit(rows.map(Expense.fromJson));
    } catch (e, st) {
      final failure = AppFailure.from(e);
      if (!_store.hasValue) _store.addError(failure, st);
      throw failure;
    }
  }

  Map<String, dynamic> _payload(ExpenseInput input) => {
        'amount': input.amount,
        'category_id': input.categoryId,
        'note': input.note,
        'date': input.date.toUtc().toIso8601String(),
      };

  @override
  Future<Expense> create(ExpenseInput input) async {
    try {
      final row = await _table.insert({..._payload(input), 'user_id': _userId}).select(_columns).single();
      final created = Expense.fromJson(row);
      _emit([created, ..._current]);
      return created;
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  @override
  Future<Expense> update(String id, ExpenseInput input) async {
    final previous = _current;
    _emit([
      for (final e in previous)
        e.id == id
            ? e.copyWith(
                amount: input.amount,
                categoryId: input.categoryId,
                note: input.note,
                clearNote: input.note == null,
                date: input.date,
              )
            : e,
    ]);
    try {
      final row = await _table.update(_payload(input)).eq('id', id).select(_columns).single();
      final saved = Expense.fromJson(row);
      _emit([for (final e in _current) e.id == id ? saved : e]);
      return saved;
    } catch (e) {
      _emit(previous);
      throw AppFailure.from(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    final previous = _current;
    _emit(previous.where((e) => e.id != id));
    try {
      await _table.delete().eq('id', id);
    } catch (e) {
      _emit(previous);
      throw AppFailure.from(e);
    }
  }

  @override
  Future<void> restore(Expense expense) async {
    final previous = _current;
    _emit([expense, ...previous.where((e) => e.id != expense.id)]);
    try {
      await _table.upsert({
        'id': expense.id,
        'user_id': _userId,
        'amount': expense.amount,
        'category_id': expense.categoryId,
        'note': expense.note,
        'date': expense.date.toUtc().toIso8601String(),
      });
    } catch (e) {
      _emit(previous);
      throw AppFailure.from(e);
    }
  }

  @override
  void dispose() => _store.close();
}
