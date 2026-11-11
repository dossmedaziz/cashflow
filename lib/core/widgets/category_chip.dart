import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'pressable.dart';

/// Home filter chip (40 high). Active = solid indigo.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.iconKey,
    this.colorHex,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Null for the "All" chip.
  final String? iconKey;
  final String? colorHex;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final duration = AppMotion.of(context, AppMotion.toggle);
    final tone = colorHex == null ? null : CategoryPalette.resolve(colorHex!, c.brightness);
    final fg = selected ? c.onPrimary : c.chipFg;
    return Pressable(
      onTap: onTap,
      selected: selected,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.ease,
        height: AppSizes.chip,
        padding: EdgeInsetsDirectional.symmetric(horizontal: iconKey == null ? 16 : 14),
        decoration: BoxDecoration(color: selected ? c.primary : c.chipBg, borderRadius: AppRadii.pillAll),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconKey != null) ...[
              AppIcon(
                AppIcons.forKey(iconKey!),
                size: 16,
                strokeWidth: 1.9,
                color: selected ? c.onPrimary : tone?.fg ?? c.text,
              ),
              const SizedBox(width: 7),
            ],
            AnimatedDefaultTextStyle(
              duration: duration,
              style: context.text.body.copyWith(fontSize: 14, color: fg, height: 1.2),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Category picker pill in the expense sheet (44 high, 3-column grid).
/// Selected = category tint + 1.5 px border in the category color.
class CategoryPickerPill extends StatelessWidget {
  const CategoryPickerPill({
    super.key,
    required this.label,
    required this.iconKey,
    required this.colorHex,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconKey;
  final String colorHex;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tone = CategoryPalette.resolve(colorHex, c.brightness);
    final duration = AppMotion.of(context, AppMotion.toggle);
    return Pressable(
      onTap: onTap,
      selected: selected,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.ease,
        height: AppSizes.pickerPill,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? tone.selectedBg : c.field,
          borderRadius: AppRadii.pillAll,
          border: Border.all(color: selected ? tone.fg : Colors.transparent, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(AppIcons.forKey(iconKey), size: 17, strokeWidth: 1.9, color: tone.fg),
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: duration,
                style: context.text.body.copyWith(
                  fontSize: 13,
                  height: 1.2,
                  color: selected ? tone.fg : c.chipFg,
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
