import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Backend-agnostic failure the UI knows how to describe.
abstract class AppFailure implements Exception {
  const AppFailure([this.cause]);

  final Object? cause;

  /// Maps any backend/network exception to an [AppFailure].
  static AppFailure from(Object error) {
    if (error is AppFailure) return error;
    if (error is SocketException ||
        error is TimeoutException ||
        error is HttpException ||
        error is AuthRetryableFetchException ||
        error.runtimeType.toString() == 'ClientException' ||
        (error is PostgrestException && error.code == null && error.message.contains('SocketException'))) {
      return NetworkFailure(error);
    }
    return UnknownFailure(error);
  }

  @override
  String toString() => '$runtimeType($cause)';
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure([super.cause]);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure([super.cause]);
}

/// The user closed the Google account picker.
final class SignInCancelled extends AppFailure {
  const SignInCancelled([super.cause]);
}

/// Missing or wrong OAuth client configuration.
final class SignInMisconfigured extends AppFailure {
  const SignInMisconfigured([super.cause]);
}
