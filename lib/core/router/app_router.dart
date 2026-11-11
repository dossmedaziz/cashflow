import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/categories/ui/categories_screen.dart';
import '../../features/expenses/ui/home_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../theme/app_tokens.dart';

abstract final class Routes {
  static const login = '/login';
  static const home = '/';
  static const categories = '/categories';
  static const settings = '/settings';
}

/// Re-runs redirects whenever the auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(currentUserProvider, (prev, next) {
      if (prev?.id != next?.id) notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefresh(ref);
  ref.onDispose(refresh.dispose);

  final router = GoRouter(
    initialLocation: Routes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final signedIn = ref.read(currentUserProvider) != null;
      final atLogin = state.matchedLocation == Routes.login;
      if (!signedIn) return atLogin ? null : Routes.login;
      if (atLogin) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(path: Routes.login, pageBuilder: (c, s) => _fade(s, const LoginScreen())),
      GoRoute(path: Routes.home, pageBuilder: (c, s) => _fade(s, const HomeScreen())),
      GoRoute(path: Routes.categories, builder: (c, s) => const CategoriesScreen()),
      GoRoute(path: Routes.settings, builder: (c, s) => const SettingsScreen()),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppMotion.reflow,
      transitionsBuilder: (context, animation, _, child) => FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: AppMotion.ease),
        child: child,
      ),
    );
