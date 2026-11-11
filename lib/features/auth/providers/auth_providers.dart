import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../core/utils/failures.dart';
import '../data/auth_repository.dart';
import '../data/supabase_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => SupabaseAuthRepository(ref.watch(supabaseClientProvider)),
);

final authStateProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

/// The signed-in user, or null. Synchronous convenience over [authStateProvider].
final currentUserProvider = Provider<AppUser?>((ref) {
  final state = ref.watch(authStateProvider);
  return state.value ?? ref.watch(authRepositoryProvider).currentUser;
});

/// Id of the signed-in user; throws if used while signed out.
final userIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) throw StateError('No signed-in user');
  return user.id;
});

/// Drives the Login button: idle / loading / failure.
class SignInController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signIn() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(AppFailure.from(e), st);
    }
  }

  Future<void> signOut() async {
    final userId = ref.read(currentUserProvider)?.id;
    await ref.read(authRepositoryProvider).signOut();
    if (userId != null) await ref.read(snapshotCacheProvider).clearUser(userId);
    state = const AsyncData(null);
  }
}

final signInControllerProvider = NotifierProvider<SignInController, AsyncValue<void>>(SignInController.new);
