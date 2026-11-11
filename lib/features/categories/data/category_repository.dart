import 'category.dart';

/// Categories of the signed-in user. Implementations keep a local cache and
/// update it optimistically, so the UI reacts instantly.
abstract interface class CategoryRepository {
  /// Sorted by [Category.order]. Emits cached data first when available.
  Stream<List<Category>> watchAll();

  Future<void> refresh();

  Future<Category> create(CategoryInput input);

  Future<Category> update(String id, CategoryInput input);

  /// Moves the category's expenses to "Other", then deletes it.
  /// The "Other" category itself cannot be deleted.
  Future<void> delete(String id);

  /// Persists a new order (ids from first to last).
  Future<void> reorder(List<String> orderedIds);

  void dispose();
}
