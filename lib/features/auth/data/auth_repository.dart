import '../../../core/utils/failures.dart';

export '../../../core/utils/failures.dart' show SignInCancelled, SignInMisconfigured;

/// The signed-in user, independent of the auth backend.
class AppUser {
  const AppUser({required this.id, this.name, this.email, this.photoUrl});

  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;

  String? get firstName {
    final n = name?.trim();
    if (n == null || n.isEmpty) return null;
    return n.split(RegExp(r'\s+')).first;
  }

  /// One letter for the avatar.
  String get initial {
    final source = (name?.trim().isNotEmpty ?? false) ? name!.trim() : (email ?? '?');
    return source.characters.first.toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      other is AppUser && other.id == id && other.name == name && other.email == email && other.photoUrl == photoUrl;

  @override
  int get hashCode => Object.hash(id, name, email, photoUrl);
}

extension on String {
  Iterable<String> get characters => runes.map(String.fromCharCode);
}

abstract interface class AuthRepository {
  /// Emits the current user immediately, then on every change.
  Stream<AppUser?> authStateChanges();

  AppUser? get currentUser;

  /// Throws [SignInCancelled], [SignInMisconfigured], [NetworkFailure]
  /// or [UnknownFailure].
  Future<void> signInWithGoogle();

  Future<void> signOut();
}
