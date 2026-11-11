import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Small tinted pill with the category name (11 / 600).
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({super.key, required this.label, required this.colorHex, this.large = false});

  final String label;
  final String colorHex;

  /// 12 / 600 with more padding (category preview).
  final bool large;

  @override
  Widget build(BuildContext context) {
    final tone = CategoryPalette.resolve(colorHex, context.colors.brightness);
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.toggle),
      padding: large
          ? const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 4)
          : const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: tone.bg, borderRadius: AppRadii.pillAll),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.text.badge.copyWith(color: tone.fg, fontSize: large ? 12 : 11),
      ),
    );
  }
}

/// Category icon on a tinted circle (44 in rows, 46 in the category list,
/// 72 in the category preview).
class CategoryIconCircle extends StatelessWidget {
  const CategoryIconCircle({
    super.key,
    required this.iconKey,
    required this.colorHex,
    this.size = AppSizes.rowIcon,
  });

  final String iconKey;
  final String colorHex;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tone = CategoryPalette.resolve(colorHex, context.colors.brightness);
    final iconSize = size >= 64 ? 32.0 : size * 20 / 44;
    return AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.toggle),
      width: size,
      height: size,
      decoration: BoxDecoration(color: tone.bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: AppIcon(
        AppIcons.forKey(iconKey),
        size: iconSize,
        color: tone.fg,
        strokeWidth: size >= 64 ? 1.7 : 1.8,
      ),
    );
  }
}
