import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../icons/app_icons.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Phone-order keypad (1-2-3 on top) — never mirrored, in every language.
/// Emits '0'–'9', '.', or 'back'.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onKey,
    required this.decimalLabel,
    required this.decimalSemantics,
    required this.backspaceSemantics,
    this.showDecimal = true,
  });

  final ValueChanged<String> onKey;

  /// "." or "," (French).
  final String decimalLabel;
  final String decimalSemantics;
  final String backspaceSemantics;
  final bool showDecimal;

  static const _keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', 'back'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 8.0;
          final keyWidth = (constraints.maxWidth - gap * 2) / 3;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final k in _keys)
                SizedBox(
                  width: keyWidth,
                  height: AppSizes.key,
                  child: k == '.' && !showDecimal
                      ? const SizedBox.shrink()
                      : _Key(
                          value: k,
                          label: k == '.' ? decimalLabel : k,
                          semantics: switch (k) {
                            'back' => backspaceSemantics,
                            '.' => decimalSemantics,
                            _ => k,
                          },
                          onTap: () => onKey(k),
                          onLongPress: k == 'back' ? () => onKey('clear') : null,
                        ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Key extends StatefulWidget {
  const _Key({
    required this.value,
    required this.label,
    required this.semantics,
    required this.onTap,
    this.onLongPress,
  });

  final String value;
  final String label;
  final String semantics;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  State<_Key> createState() => _KeyState();
}

class _KeyState extends State<_Key> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final press = AppMotion.of(context, AppMotion.press);
    return Semantics(
      button: true,
      label: widget.semantics,
      excludeSemantics: true,
      child: GestureDetector(
        key: ValueKey('key-${widget.value}'),
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _down ? AppMotion.pressedScale : 1,
          duration: press,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: _down ? c.fieldPressed : c.field,
              borderRadius: AppRadii.fieldAll,
            ),
            alignment: Alignment.center,
            child: widget.value == 'back'
                ? AppIcon(AppIcons.backspace, size: 24, color: c.text)
                : Text(
                    widget.label,
                    style: context.text.body.copyWith(fontSize: 22, height: 1, fontFamily: 'Inter'),
                  ),
          ),
        ),
      ),
    );
  }
}
