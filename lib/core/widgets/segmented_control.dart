import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'pressable.dart';

class SegmentOption<T> {
  const SegmentOption({required this.value, required this.label, this.icon, this.locale});

  final T value;
  final String label;
  final String? icon;

  /// Renders the label in its own language (e.g. "Français").
  final Locale? locale;
}

/// Card-colored track (r18, 4 px padding) with 44-px segments; the selected
/// one is solid indigo.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.semanticLabel,
  });

  final List<SegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final duration = AppMotion.of(context, AppMotion.toggle);
    return Semantics(
      label: semanticLabel,
      container: true,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: c.card, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Pressable(
                  onTap: () => onChanged(options[i].value),
                  selected: options[i].value == selected,
                  semanticLabel: options[i].label,
                  child: AnimatedContainer(
                    duration: duration,
                    curve: AppMotion.ease,
                    height: 44,
                    decoration: BoxDecoration(
                      color: options[i].value == selected ? c.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (options[i].icon != null) ...[
                          AppIcon(
                            options[i].icon!,
                            size: 17,
                            color: options[i].value == selected ? c.onPrimary : c.muted,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: AnimatedDefaultTextStyle(
                            duration: duration,
                            style: context.text.body.copyWith(
                              fontSize: 14,
                              height: 1.2,
                              color: options[i].value == selected ? c.onPrimary : c.muted,
                            ),
                            child: Text(
                              options[i].label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              locale: options[i].locale,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
