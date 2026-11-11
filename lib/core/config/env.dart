/// Build-time configuration.
///
/// Override any value with `--dart-define=KEY=value` (or
/// `--dart-define-from-file=env.json`). The Supabase URL and publishable key
/// are safe to ship in a client app: Row Level Security protects the data.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xjszjggrbjwugxjpfoqg.supabase.co',
  );

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_tHvDKvcHyLQV9VjMs2rhzw_udBSOiL7',
  );

  /// OAuth 2.0 client ID of type "Web application" from Google Cloud Console.
  /// Supabase verifies the ID token against it. Required on Android and iOS.
  static const googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  /// OAuth 2.0 client ID of type "iOS" from Google Cloud Console.
  static const googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  static const appVersion = '1.0';
}
