import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../../expenses/providers/expenses_providers.dart';
import '../data/category.dart';
import '../data/category_repository.dart';
import '../data/supabase_category_repository.dart';

/// Scoped to the signed-in user; rebuilt (and the old cache dropped) on
/// sign-out / account switch.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final repo = SupabaseCategoryRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(userIdProvider),
    ref.watch(snapshotCacheProvider),
  );
  ref.onDispose(repo.dispose);
  return repo;
});

final categoriesProvider = StreamProvider<List<Category>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);

/// id → category, for fast lookups in lists.
final categoriesByIdProvider = Provider<Map<String, Category>>((ref) {
  final list = ref.watch(categoriesProvider).value ?? const [];
  return {for (final c in list) c.id: c};
});

/// Mutations that touch more than one repository.
class CategoryActions {
  CategoryActions(this._ref);

  final Ref _ref;

  CategoryRepository get _repo => _ref.read(categoryRepositoryProvider);

  Future<Category> create(CategoryInput input) => _repo.create(input);

  Future<Category> update(String id, CategoryInput input) => _repo.update(id, input);

  Future<void> reorder(List<String> ids) => _repo.reorder(ids);

  /// Deletes the category; the backend moves its expenses to "Other",
  /// so the expense cache is refreshed afterwards.
  Future<void> delete(String id) async {
    await _repo.delete(id);
    await _ref.read(expenseRepositoryProvider).refresh();
  }
}

final categoryActionsProvider = Provider<CategoryActions>(CategoryActions.new);
