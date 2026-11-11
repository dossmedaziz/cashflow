import 'expense.dart';

/// Expenses of the signed-in user. Implementations keep a local cache and
/// update it optimistically, so the UI reacts instantly.
abstract interface class ExpenseRepository {
  /// Expenses dated on or after [from], newest first.
  Stream<List<Expense>> watchSince(DateTime from);

  Future<void> refresh();

  Future<Expense> create(ExpenseInput input);

  Future<Expense> update(String id, ExpenseInput input);

  Future<void> delete(String id);

  /// Re-inserts a deleted expense with its original id (undo).
  Future<void> restore(Expense expense);

  void dispose();
}
