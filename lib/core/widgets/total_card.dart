import 'package:flutter/material.dart';

import '../icons/app_icons.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

enum TotalTrend { less, more, same }

/// Hero card: month label + chip, big total, comparison pill.
/// Flat indigo tint (r24) — no borders, no glows.
class TotalCard extends StatelessWidget {
  const TotalCard({
    super.key,
    required this.label,
    required this.monthChip,
    required this.total,
    required this.currencySymbol,
    this.comparison,
    this.trend = TotalTrend.less,
    this.emptyHint,
  });

  final String label;
  final String monthChip;
  final String total;
  final String currencySymbol;

  /// "12% less than October". Null hides the pill.
  final String? comparison;
  final TotalTrend trend;

  /// Shown instead of the pill when nothing was logged yet.
  final String? emptyHint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final (Color fg, Color bg, String icon) = switch (trend) {
      TotalTrend.less => (c.mint, c.mintBg, AppIcons.less),
      TotalTrend.more => (c.peach, c.peachBg, AppIcons.more),
      TotalTrend.same => (c.muted, c.heroChip, AppIcons.check),
    };
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 22, 22, 20),
      decoration: BoxDecoration(color: c.hero, borderRadius: AppRadii.heroAll),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: t.bodyMedium.copyWith(color: c.muted, height: 1.3)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: c.heroChip, borderRadius: AppRadii.pillAll),
                child: Text(monthChip, style: t.caption.copyWith(fontWeight: FontWeight.w600, height: 1.2)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Semantics(
            label: '$total $currencySymbol',
            excludeSemantics: true,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 8,
              children: [
                AnimatedSwitcher(
                  duration: AppMotion.of(context, AppMotion.toggle),
                  transitionBuilder: (child, a) => FadeTransition(opacity: a, child: child),
                  child: Text(
                    total,
                    key: ValueKey(total),
                    textDirection: TextDirection.ltr,
                    style: t.heroTotal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 4),
                  child: Text(
                    currencySymbol,
                    style: t.body.copyWith(fontSize: 17, color: c.muted, height: 1.2),
                  ),
                ),
              ],
            ),
          ),
          if (comparison != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: bg, borderRadius: AppRadii.pillAll),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon(icon, size: 15, strokeWidth: 2.2, color: fg),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      comparison!,
                      style: t.subtitle.copyWith(color: fg, fontWeight: FontWeight.w600, height: 1.25),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (emptyHint != null) ...[
            const SizedBox(height: 16),
            Text(emptyHint!, style: t.subtitle.copyWith(fontWeight: FontWeight.w400)),
          ],
        ],
      ),
    );
  }
}
