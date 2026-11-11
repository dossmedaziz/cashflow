import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../icons/app_icons.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'category_badge.dart';

/// One expense row (68 px): icon · title + badge/time · amount at the end.
class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.title,
    required this.categoryName,
    required this.iconKey,
    required this.colorHex,
    required this.time,
    required this.amount,
    required this.currencySymbol,
    this.onTap,
  });

  final String title;
  final String categoryName;
  final String iconKey;
  final String colorHex;
  final String time;
  final String amount;
  final String currencySymbol;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Semantics(
      button: onTap != null,
      label: '$title, $categoryName, $time, $amount $currencySymbol',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.rowHorizontal,
            vertical: AppSpacing.rowVertical,
          ),
          child: Row(
            children: [
              CategoryIconCircle(iconKey: iconKey, colorHex: colorHex),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.body.copyWith(height: 1.3)),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(child: CategoryBadge(label: categoryName, colorHex: colorHex)),
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: t.caption.copyWith(fontFeatures: AppTextStyles.tabular, height: 1.2),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(amount, textDirection: TextDirection.ltr, style: t.rowAmount.copyWith(color: c.text)),
                  const SizedBox(height: 2),
                  Text(currencySymbol, style: t.badge.copyWith(color: c.muted, fontWeight: FontWeight.w400)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Swipe toward the start to reveal Delete (96 px); a full swipe deletes.
/// Mirrors automatically in RTL.
class SwipeToDelete extends StatefulWidget {
  const SwipeToDelete({
    super.key,
    required this.child,
    required this.onDelete,
    required this.deleteLabel,
    required this.background,
  });

  final Widget child;

  /// Called after the row has slid out and collapsed.
  final VoidCallback onDelete;
  final String deleteLabel;

  /// Row surface color (the row must be opaque while sliding).
  final Color background;

  @override
  State<SwipeToDelete> createState() => _SwipeToDeleteState();
}

class _SwipeToDeleteState extends State<SwipeToDelete> with TickerProviderStateMixin {
  static const _revealWidth = 96.0;

  late final AnimationController _slide = AnimationController.unbounded(vsync: this);
  late final AnimationController _collapse = AnimationController(vsync: this);
  double _width = 1;
  bool _deleting = false;

  @override
  void dispose() {
    _slide.dispose();
    _collapse.dispose();
    super.dispose();
  }

  bool get _rtl => Directionality.of(context) == TextDirection.rtl;

  Duration _d(Duration d) => AppMotion.of(context, d);

  void _onDragUpdate(DragUpdateDetails d) {
    if (_deleting) return;
    final delta = _rtl ? d.primaryDelta! : -d.primaryDelta!;
    _slide.value = (_slide.value + delta).clamp(0.0, _width);
  }

  void _onDragEnd(DragEndDetails d) {
    if (_deleting) return;
    final v = d.primaryVelocity ?? 0;
    final towardStart = _rtl ? v : -v;
    if (_slide.value > _width * 0.5 || (towardStart > 900 && _slide.value > _revealWidth * 0.5)) {
      unawaited(_delete());
    } else if (_slide.value > 48 || towardStart > 300) {
      unawaited(_animateTo(_revealWidth));
    } else {
      unawaited(_animateTo(0));
    }
  }

  Future<void> _animateTo(double target) =>
      _slide.animateTo(target, duration: _d(AppMotion.reflow), curve: AppMotion.ease);

  Future<void> _delete() async {
    if (_deleting) return;
    _deleting = true;
    unawaited(HapticFeedback.mediumImpact());
    await _animateTo(_width);
    await _collapse.animateTo(1, duration: _d(AppMotion.reflow), curve: AppMotion.ease);
    if (mounted) widget.onDelete();
  }

  void _close() {
    if (_slide.value > 0 && !_deleting) unawaited(_animateTo(0));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = constraints.maxWidth;
        return SizeTransition(
          sizeFactor: ReverseAnimation(_collapse),
          alignment: Alignment.topCenter,
          child: Semantics(
            customSemanticsActions: {
              CustomSemanticsAction(label: widget.deleteLabel): _delete,
            },
            child: GestureDetector(
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              child: AnimatedBuilder(
                animation: _slide,
                builder: (context, child) {
                  final reveal = _slide.value;
                  return Stack(
                    children: [
                      if (reveal > 0)
                        PositionedDirectional(
                          top: 0,
                          bottom: 0,
                          end: 0,
                          width: reveal < _revealWidth ? _revealWidth : reveal,
                          child: GestureDetector(
                            onTap: _delete,
                            child: ColoredBox(
                              color: c.swipeDelete,
                              child: Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: SizedBox(
                                  width: _revealWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const AppIcon(AppIcons.delete, size: 20, strokeWidth: 1.9, color: Colors.white),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.deleteLabel,
                                        style: context.text.caption.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      Transform.translate(
                        offset: Offset(_rtl ? reveal : -reveal, 0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: widget.background,
                            boxShadow: reveal > 0
                                ? const [BoxShadow(color: Color(0x59000000), blurRadius: 24)]
                                : null,
                          ),
                          child: reveal > 0
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _close,
                                  child: AbsorbPointer(child: child),
                                )
                              : child,
                        ),
                      ),
                    ],
                  );
                },
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
