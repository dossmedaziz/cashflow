import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/icons/brand_art.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/failures.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/pressable.dart';
import '../../settings/providers/settings_providers.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final signIn = ref.watch(signInControllerProvider);

    ref.listen(signInControllerProvider, (prev, next) {
      final error = next.error;
      if (error == null || prev?.error == error) return;
      final message = switch (error) {
        SignInCancelled() => l10n.signInCancelled,
        SignInMisconfigured() => l10n.signInConfigError,
        NetworkFailure() => l10n.signInNetworkError,
        _ => l10n.signInFailed,
      };
      showErrorToast(context, message, bottom: 140);
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 28),
          child: Column(
            children: [
              const _LanguageSwitch(),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _FloatingLogo(),
                        const SizedBox(height: 16),
                        Text(
                          l10n.appName,
                          textDirection: TextDirection.ltr,
                          style: t.title.copyWith(fontSize: 40, height: 1.1, letterSpacing: -1.2),
                        ),
                        const SizedBox(height: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            l10n.loginTagline,
                            textAlign: TextAlign.center,
                            style: t.bodyMedium.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: c.brightness == Brightness.dark ? const Color(0xFFA1A1AA) : c.muted,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppButton.google(
                label: l10n.continueWithGoogle,
                loading: signIn.isLoading,
                onPressed: () => ref.read(signInControllerProvider.notifier).signIn(),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '${l10n.termsPrefix} '),
                    TextSpan(text: l10n.termsLink, style: TextStyle(color: c.lilac)),
                    TextSpan(text: ' ${l10n.termsAnd} '),
                    TextSpan(text: l10n.privacyLink, style: TextStyle(color: c.lilac)),
                  ],
                ),
                textAlign: TextAlign.center,
                style: t.caption.copyWith(fontWeight: FontWeight.w400, height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ع / FR / EN — never mirrored.
class _LanguageSwitch extends ConsumerWidget {
  const _LanguageSwitch();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final current = ref.watch(languageProvider);
    final duration = AppMotion.of(context, AppMotion.toggle);
    return Semantics(
      label: context.l10n.languageLabel,
      container: true,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: c.card, borderRadius: AppRadii.pillAll),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final l in AppLanguage.values) ...[
                if (l != AppLanguage.values.first) const SizedBox(width: 4),
                Pressable(
                  onTap: () => ref.read(languageProvider.notifier).set(l),
                  selected: l == current,
                  semanticLabel: l.nativeName,
                  child: AnimatedContainer(
                    duration: duration,
                    height: 36,
                    constraints: const BoxConstraints(minWidth: 52),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: l == current ? c.primary : Colors.transparent,
                      borderRadius: AppRadii.pillAll,
                    ),
                    child: Text(
                      l.shortLabel,
                      style: context.text.body.copyWith(
                        fontSize: 14,
                        height: 1.2,
                        color: l == current ? c.onPrimary : const Color(0xFFA1A1AA),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo tile with four category bubbles gently floating around it.
class _FloatingLogo extends StatefulWidget {
  const _FloatingLogo();

  @override
  State<_FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<_FloatingLogo> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(seconds: 6));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = context.colors.brightness;
    Widget bubble({
      required double size,
      required double iconSize,
      required String icon,
      required String hex,
      required double phase,
      double? top,
      double? bottom,
      double? left,
      double? right,
    }) {
      final tone = CategoryPalette.resolve(hex, b);
      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -8 * (0.5 - 0.5 * math.cos(2 * math.pi * (_c.value + phase)))),
            child: child,
          ),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: tone.bg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: AppIcon(icon, size: iconSize, color: tone.fg),
          ),
        ),
      );
    }

    return SizedBox(
      width: 260,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          bubble(size: 40, iconSize: 20, icon: AppIcons.food, hex: '#FDBA74', phase: 0, top: 10, right: 18),
          bubble(size: 44, iconSize: 20, icon: AppIcons.transport, hex: '#93C5FD', phase: 1 / 3, bottom: 14, left: 8),
          bubble(size: 34, iconSize: 16, icon: AppIcons.shopping, hex: '#F9A8D4', phase: 2 / 3, top: 34, left: 22),
          bubble(size: 32, iconSize: 16, icon: AppIcons.heart, hex: '#6EE7B7', phase: 0.5, bottom: 30, right: 4),
          const CashflowLogo(),
        ],
      ),
    );
  }
}
