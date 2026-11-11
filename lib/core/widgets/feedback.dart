import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../icons/brand_art.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import '../utils/failures.dart';

/// One illustration, one title, one line.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmptyReceiptArt(card: c.card, muted: c.muted, primary: c.primary),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.text.sheetTitle.copyWith(fontSize: 21),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium.copyWith(color: c.muted, fontWeight: FontWeight.w400, height: 1.7),
          ),
        ],
      ),
    );
  }
}

/// Error with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l10n = context.l10n;
    final offline = AppFailure.from(error) is NetworkFailure;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: c.roseBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: AppIcon(offline ? AppIcons.wifiOff : AppIcons.refresh, size: 24, color: c.rose),
          ),
          const SizedBox(height: 14),
          Text(
            offline ? l10n.signInNetworkError : l10n.errorLoading,
            textAlign: TextAlign.center,
            style: context.text.body,
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: SizedBox.square(dimension: 28, child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      );
}

/// Undo toast: dark surface, r18, lilac action, 5 s.
///
/// Takes the [messenger] (not a context) so it still works after the row
/// that triggered it has been removed from the tree.
void showUndoToast(
  ScaffoldMessengerState messenger, {
  required String message,
  required String actionLabel,
  required VoidCallback onUndo,
  double bottom = 116,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
        duration: AppMotion.toast,
        persist: false,
        margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, bottom),
        padding: const EdgeInsetsDirectional.fromSTEB(16, 6, 8, 6),
        action: SnackBarAction(label: actionLabel, onPressed: onUndo),
      ),
    );
}

/// Plain error toast.
void showErrorToast(BuildContext context, String message, {double bottom = 24}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        margin: EdgeInsetsDirectional.fromSTEB(20, 0, 20, bottom),
      ),
    );
}

/// Message for any failure.
String describeFailure(BuildContext context, Object error) {
  final l10n = context.l10n;
  return AppFailure.from(error) is NetworkFailure ? l10n.signInNetworkError : l10n.errorGeneric;
}

/// Fades + slides a widget in once when first built (list inserts).
class AppearIn extends StatefulWidget {
  const AppearIn({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<AppearIn> createState() => _AppearInState();
}

class _AppearInState extends State<AppearIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AppMotion.sheet);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_c.status == AnimationStatus.dismissed) {
      if (AppMotion.reduced(context)) {
        _c.value = 1;
      } else {
        Future<void>.delayed(widget.delay, () {
          if (mounted) _c.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _c, curve: AppMotion.ease);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
        child: widget.child,
      ),
    );
  }
}

/// AnimatedSize that becomes a plain child under "Reduce motion"
/// (AnimatedSize with a zero duration re-dirties itself during layout).
class MotionSize extends StatelessWidget {
  const MotionSize({super.key, required this.child, this.duration = AppMotion.reflow});

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduced(context)) return child;
    return AnimatedSize(
      duration: duration,
      curve: AppMotion.ease,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}
