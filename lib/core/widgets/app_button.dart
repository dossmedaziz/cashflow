import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../icons/brand_art.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'pressable.dart';

enum AppButtonVariant {
  /// Indigo, 56 — main action.
  primary,

  /// Neutral, 48.
  secondary,

  /// Rose tint, 48–52 — destructive.
  danger,

  /// White, 58 — Continue with Google.
  google,
}

/// Flat pill button. No gradients, no shadows; press = scale .96.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.height,
    this.radius,
    this.expand = true,
  });

  const AppButton.google({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  })  : variant = AppButtonVariant.google,
        icon = null,
        height = 58,
        radius = null,
        expand = true;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final String? icon;
  final bool loading;
  final double? height;
  final double? radius;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final enabled = onPressed != null && !loading;
    final (Color bg, Color fg, TextStyle style, double h) = switch (variant) {
      AppButtonVariant.primary => (c.primary, c.onPrimary, t.button, AppSizes.primaryButton),
      AppButtonVariant.secondary => (c.stroke, c.text, t.buttonSmall, AppSizes.secondaryButton),
      AppButtonVariant.danger => (c.roseBg, c.rose, t.buttonSmall.copyWith(fontWeight: FontWeight.w700), 52),
      AppButtonVariant.google => (
          const Color(0xFFFFFFFF),
          const Color(0xFF1F1F1F),
          t.buttonSmall.copyWith(fontSize: 16),
          58.0,
        ),
    };
    final isDisabledLook = onPressed == null && !loading;
    final effectiveBg = isDisabledLook && variant == AppButtonVariant.primary ? c.disabledBg : bg;
    final effectiveFg = isDisabledLook && variant == AppButtonVariant.primary ? c.disabledFg : fg;

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: effectiveFg),
          )
        else ...[
          if (variant == AppButtonVariant.google) ...[const GoogleLogo(size: 22), const SizedBox(width: 12)],
          if (icon != null) ...[
            AppIcon(icon!, size: 20, color: effectiveFg, strokeWidth: 2.2, mirror: _mirrorFor(icon!)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(color: effectiveFg),
            ),
          ),
        ],
      ],
    );

    return Pressable(
      onTap: enabled ? onPressed : null,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.toggle),
        height: height ?? h,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(radius ?? AppRadii.pill),
          boxShadow: variant == AppButtonVariant.google
              ? const [BoxShadow(color: Color(0x59000000), blurRadius: 30, offset: Offset(0, 10))]
              : null,
        ),
        child: ExcludeSemantics(child: content),
      ),
    );
  }

  static IconMirror _mirrorFor(String icon) => icon == AppIcons.logout ? IconMirror.inRtl : IconMirror.none;
}

enum CircleButtonStyle {
  /// Card surface — header buttons (back, categories).
  card,

  /// Field surface — sheet close.
  field,

  /// Rose tint — delete.
  danger,

  /// Indigo — add.
  primary,
}

/// 44-px round icon button (minimum touch target).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.style = CircleButtonStyle.card,
    this.mirror = IconMirror.none,
    this.iconSize = 20,
    this.strokeWidth = 2,
    this.size = AppSizes.iconButton,
  });

  final String icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final CircleButtonStyle style;
  final IconMirror mirror;
  final double iconSize;
  final double strokeWidth;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (Color bg, Color fg) = switch (style) {
      CircleButtonStyle.card => (c.card, c.text),
      CircleButtonStyle.field => (c.field, c.textSecondary),
      CircleButtonStyle.danger => (c.roseBg, c.rose),
      CircleButtonStyle.primary => (c.primary, c.onPrimary),
    };
    return Pressable(
      onTap: onPressed,
      semanticLabel: semanticLabel,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: AppIcon(icon, size: iconSize, color: fg, strokeWidth: strokeWidth, mirror: mirror),
      ),
    );
  }
}
