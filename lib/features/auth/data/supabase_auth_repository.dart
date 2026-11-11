import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';
import '../../../core/utils/failures.dart';
import 'auth_repository.dart';

/// Native Google Sign-In → Supabase `signInWithIdToken`.
///
/// Signing in for the first time also registers the user: Supabase creates
/// the auth user and the `on_auth_user_created` trigger seeds the profile
/// and default categories.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client, {GoogleSignIn? googleSignIn})
      : _google = googleSignIn ?? GoogleSignIn.instance;

  final SupabaseClient _client;
  final GoogleSignIn _google;
  Future<void>? _googleInit;

  GoTrueClient get _auth => _client.auth;

  static AppUser? _map(User? u) {
    if (u == null) return null;
    final meta = u.userMetadata ?? const {};
    return AppUser(
      id: u.id,
      email: u.email,
      name: (meta['full_name'] ?? meta['name']) as String?,
      photoUrl: (meta['avatar_url'] ?? meta['picture']) as String?,
    );
  }

  @override
  AppUser? get currentUser => _map(_auth.currentUser);

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield currentUser;
    yield* _auth.onAuthStateChange.map((s) => _map(s.session?.user)).distinct();
  }

  Future<void> _ensureGoogle() {
    return _googleInit ??= _google.initialize(
      clientId: !kIsWeb && Platform.isIOS && Env.googleIosClientId.isNotEmpty ? Env.googleIosClientId : null,
      serverClientId: Env.googleWebClientId.isEmpty ? null : Env.googleWebClientId,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    if (Env.googleWebClientId.isEmpty) {
      throw const SignInMisconfigured('GOOGLE_WEB_CLIENT_ID is not set');
    }
    try {
      await _ensureGoogle();
      final account = await _google.authenticate(scopeHint: const ['email', 'profile']);
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const SignInMisconfigured('Google returned no ID token');
      }
      await _auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);
    } on GoogleSignInException catch (e) {
      _googleInit = null;
      throw switch (e.code) {
        GoogleSignInExceptionCode.canceled ||
        GoogleSignInExceptionCode.interrupted ||
        GoogleSignInExceptionCode.uiUnavailable =>
          SignInCancelled(e),
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          SignInMisconfigured(e),
        _ => _looksOffline(e.description) ? NetworkFailure(e) : UnknownFailure(e),
      };
    } on AuthException catch (e) {
      throw _looksOffline(e.message) ? NetworkFailure(e) : UnknownFailure(e);
    } on AppFailure {
      rethrow;
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  static bool _looksOffline(String? message) {
    final m = (message ?? '').toLowerCase();
    return m.contains('network') || m.contains('socket') || m.contains('host lookup') || m.contains('offline');
  }

  @override
  Future<void> signOut() async {
    try {
      await _google.signOut();
    } catch (_) {
      // Google may not be initialized (e.g. restored session); ignore.
    }
    await _auth.signOut(scope: SignOutScope.local);
  }
}
