import 'dart:async';

import 'package:cashflow/core/utils/value_store.dart';
import 'package:cashflow/features/auth/data/auth_repository.dart';
import 'package:cashflow/features/categories/data/category.dart';
import 'package:cashflow/features/categories/data/category_repository.dart';
import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:cashflow/features/expenses/data/expense_repository.dart';
import 'package:cashflow/features/settings/data/settings_repository.dart';
import 'package:cashflow/features/today_widget/data/today_widget.dart';

/// In-memory backend fakes. They follow the same contracts as the Supabase
/// repositories (optimistic cache, delete-category moves expenses to Other).

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.user});

  AppUser? user;
  final _changes = StreamController<AppUser?>.broadcast();
  int signInCalls = 0;

  /// Next sign-in result; null = success.
  Object? nextError;

  static const demoUser = AppUser(id: 'u1', name: 'Amine Ben Ali', email: 'amine.b@gmail.com');

  @override
  AppUser? get currentUser => user;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield user;
    yield* _changes.stream;
  }

  @override
  Future<void> signInWithGoogle() async {
    signInCalls++;
    if (nextError != null) throw nextError!;
    user = demoUser;
    _changes.add(user);
  }

  @override
  Future<void> signOut() async {
    user = null;
    _changes.add(null);
  }
}

class InMemoryExpenseRepository implements ExpenseRepository {
  final _store = ValueStore<List<Expense>>(const []);
  final List<Expense> _all = [];
  DateTime? _from;
  int _nextId = 1;

  List<Expense> get all => List.unmodifiable(_all);

  void seed(Iterable<Expense> expenses) {
    _all.addAll(expenses);
    _emit();
  }

  void _emit() {
    final from = _from;
    _store.value = (_all.where((e) => from == null || !e.date.isBefore(from)).toList()
      ..sort((a, b) => b.date.compareTo(a.date)));
  }

  @override
  Stream<List<Expense>> watchSince(DateTime from) {
    _from = from;
    _emit();
    return _store.stream;
  }

  @override
  Future<void> refresh() async => _emit();

  @override
  Future<Expense> create(ExpenseInput input) async {
    final e = Expense(
      id: 'e${_nextId++}',
      amount: input.amount,
      categoryId: input.categoryId,
      note: input.note,
      date: input.date,
    );
    _all.add(e);
    _emit();
    return e;
  }

  @override
  Future<Expense> update(String id, ExpenseInput input) async {
    final i = _all.indexWhere((e) => e.id == id);
    if (i < 0) throw StateError('not found');
    _all[i] = _all[i].copyWith(
      amount: input.amount,
      categoryId: input.categoryId,
      note: input.note,
      clearNote: input.note == null,
      date: input.date,
    );
    _emit();
    return _all[i];
  }

  @override
  Future<void> delete(String id) async {
    _all.removeWhere((e) => e.id == id);
    _emit();
  }

  @override
  Future<void> restore(Expense expense) async {
    _all
      ..removeWhere((e) => e.id == expense.id)
      ..add(expense);
    _emit();
  }

  /// Backend side effect of deleting a category.
  void reassignCategory(String fromId, String toId) {
    for (var i = 0; i < _all.length; i++) {
      if (_all[i].categoryId == fromId) _all[i] = _all[i].copyWith(categoryId: toId);
    }
    _emit();
  }

  @override
  void dispose() => _store.close();
}

class InMemoryCategoryRepository implements CategoryRepository {
  InMemoryCategoryRepository({this.expenses, bool seedDefaults = true}) {
    if (seedDefaults) {
      const colors = ['#FDBA74', '#93C5FD', '#F9A8D4', '#FDE68A', '#6EE7B7', '#C4C4CC'];
      for (var i = 0; i < DefaultCategory.keys.length; i++) {
        final key = DefaultCategory.keys[i];
        _all.add(
          Category(
            id: key,
            defaultKey: key,
            colorHex: colors[i],
            iconKey: key,
            order: i,
            isDefault: true,
          ),
        );
      }
    }
    _emit();
  }

  final InMemoryExpenseRepository? expenses;
  final List<Category> _all = [];
  final _store = ValueStore<List<Category>>();
  int _nextId = 1;

  List<Category> get all => List.unmodifiable(_all);

  void _emit() => _store.value = (_all.toList()..sort((a, b) => a.order.compareTo(b.order)));

  @override
  Stream<List<Category>> watchAll() => _store.stream;

  @override
  Future<void> refresh() async => _emit();

  @override
  Future<Category> create(CategoryInput input) async {
    final c = Category(
      id: 'c${_nextId++}',
      name: input.name,
      colorHex: input.colorHex,
      iconKey: input.iconKey,
      order: _all.length,
    );
    _all.add(c);
    _emit();
    return c;
  }

  @override
  Future<Category> update(String id, CategoryInput input) async {
    final i = _all.indexWhere((c) => c.id == id);
    _all[i] = _all[i].copyWith(
      name: input.name,
      clearName: input.name == null,
      colorHex: input.colorHex,
      iconKey: input.iconKey,
    );
    _emit();
    return _all[i];
  }

  @override
  Future<void> delete(String id) async {
    final other = _all.firstWhere((c) => c.isOther);
    if (other.id == id) throw StateError('cannot delete the Other category');
    expenses?.reassignCategory(id, other.id);
    _all.removeWhere((c) => c.id == id);
    _emit();
  }

  @override
  Future<void> reorder(List<String> orderedIds) async {
    for (var i = 0; i < orderedIds.length; i++) {
      final j = _all.indexWhere((c) => c.id == orderedIds[i]);
      if (j >= 0) _all[j] = _all[j].copyWith(order: i);
    }
    _emit();
  }

  @override
  void dispose() => _store.close();
}

class FakeProfileRepository implements ProfileRepository {
  String currency = 'TND';

  @override
  Future<String?> fetchCurrency() async => currency;

  @override
  Future<void> updateCurrency(String code) async => currency = code;
}

class FakeTodayWidgetBridge implements TodayWidgetBridge {
  final pushes = <TodayWidgetData>[];
  final _clicks = StreamController<Uri?>.broadcast();
  Uri? launchedFrom;

  TodayWidgetData? get last => pushes.isEmpty ? null : pushes.last;

  void tap() => _clicks.add(Uri.parse('cashflow://add?homeWidget'));

  @override
  Future<void> init() async {}

  @override
  Future<void> push(TodayWidgetData data) async => pushes.add(data);

  @override
  Future<Uri?> initialLaunch() async => launchedFrom;

  @override
  Stream<Uri?> get clicks => _clicks.stream;
}
