import 'package:cashflow/core/l10n/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:cashflow/features/categories/data/category.dart';
import 'package:cashflow/features/expenses/data/expense.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fakes.dart';

void main() {
  final today = DateTime(2026, 11, 11, 9, 40);

  group('ExpenseRepository (in-memory fake)', () {
    late InMemoryExpenseRepository repo;

    setUp(() => repo = InMemoryExpenseRepository());
    tearDown(() => repo.dispose());

    test('watchSince emits newest first and only from the start date', () async {
      repo.seed([
        Expense(id: 'old', amount: 1000, categoryId: 'food', date: DateTime(2026, 9, 1)),
        Expense(id: 'a', amount: 2000, categoryId: 'food', date: DateTime(2026, 11, 1)),
        Expense(id: 'b', amount: 3000, categoryId: 'food', date: DateTime(2026, 11, 10)),
      ]);
      final list = await repo.watchSince(DateTime(2026, 10)).first;
      expect(list.map((e) => e.id), ['b', 'a']);
    });

    test('create → update → delete → restore', () async {
      Future<List<Expense>> latest() => repo.watchSince(DateTime(2026, 10)).first;
      final created = await repo.create(ExpenseInput(amount: 24500, categoryId: 'food', date: today, note: '  Coffee  '));
      expect(created.note, 'Coffee', reason: 'note is trimmed');
      expect((await latest()).single.amount, 24500);

      await repo.update(created.id, ExpenseInput(amount: 30000, categoryId: 'bills', date: today, note: ''));
      final updated = (await latest()).single;
      expect(updated.amount, 30000);
      expect(updated.categoryId, 'bills');
      expect(updated.note, isNull, reason: 'empty note clears it');

      await repo.delete(created.id);
      expect(await latest(), isEmpty);

      await repo.restore(updated);
      expect((await latest()).single.id, created.id, reason: 'undo keeps the same id');
    });
  });

  group('ExpenseInput validation', () {
    test('amount must be > 0 and a category is required', () {
      expect(ExpenseInput(amount: 0, categoryId: '', date: today).validate(),
          [ExpenseInputError.amount, ExpenseInputError.category]);
      expect(ExpenseInput(amount: 1, categoryId: 'food', date: today).validate(), isEmpty);
    });
  });

  group('CategoryRepository (in-memory fake)', () {
    late InMemoryExpenseRepository expenses;
    late InMemoryCategoryRepository categories;

    setUp(() {
      expenses = InMemoryExpenseRepository();
      categories = InMemoryCategoryRepository(expenses: expenses);
    });

    test('seeds the six default categories in order', () async {
      final list = await categories.watchAll().first;
      expect(list.map((c) => c.defaultKey), DefaultCategory.keys);
      expect(list.every((c) => c.isDefault && c.name == null), isTrue);
    });

    test('deleting a category moves its expenses to Other', () async {
      final sport = await categories.create(const CategoryInput(name: 'Sport', colorHex: '#67E8F9', iconKey: 'dumbbell'));
      expenses.seed([Expense(id: 'x', amount: 45000, categoryId: sport.id, date: today)]);

      await categories.delete(sport.id);

      expect(categories.all.any((c) => c.id == sport.id), isFalse);
      expect(expenses.all.single.categoryId, 'other');
    });

    test('Other cannot be deleted', () async {
      expect(() => categories.delete('other'), throwsStateError);
    });

    test('reorder persists the new order', () async {
      await categories.reorder(['other', 'food', 'transport', 'shopping', 'bills', 'health']);
      final list = await categories.watchAll().first;
      expect(list.first.id, 'other');
      expect(list[1].id, 'food');
    });
  });

  group('Category', () {
    test('default categories show a localized name until renamed', () async {
      const food = Category(id: '1', defaultKey: 'food', colorHex: '#FDBA74', iconKey: 'food', order: 0, isDefault: true);
      final ar = await AppLocalizations.delegate.load(const Locale('ar'));
      final fr = await AppLocalizations.delegate.load(const Locale('fr'));
      expect(food.displayName(ar), 'طعام');
      expect(food.displayName(fr), 'Alimentation');
      expect(food.copyWith(name: 'Courses').displayName(fr), 'Courses');
    });

    test('JSON mapping matches the database columns', () {
      final json = {
        'id': 'abc',
        'name': null,
        'default_key': 'bills',
        'color_hex': '#FDE68A',
        'icon_key': 'bills',
        'sort_order': 3,
        'is_default': true,
      };
      final c = Category.fromJson(json);
      expect(c.defaultKey, 'bills');
      expect(c.order, 3);
      expect(c.toJson(), json);
    });
  });

  test('Expense JSON uses integer amounts and UTC dates', () {
    final e = Expense(id: 'e', amount: 96400, categoryId: 'bills', date: DateTime.utc(2026, 11, 10, 17, 30).toLocal());
    final json = e.toJson();
    expect(json['amount'], isA<int>());
    expect(json['date'], '2026-11-10T17:30:00.000Z');
    final back = Expense.fromJson({...json, 'amount': 96400});
    expect(back, e);
  });
}
