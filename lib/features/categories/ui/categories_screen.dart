import 'dart:async';
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/pressable.dart';
import '../../expenses/providers/expenses_providers.dart';
import '../../settings/providers/settings_providers.dart';
import '../data/category.dart';
import '../providers/categories_providers.dart';
import 'category_editor_sheet.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: c.primary,
          backgroundColor: c.card,
          onRefresh: () => ref.read(categoryRepositoryProvider).refresh().catchError((_) {}),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      CircleIconButton(
                        icon: AppIcons.back,
                        mirror: IconMirror.inLtr,
                        semanticLabel: l10n.back,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      CircleIconButton(
                        icon: AppIcons.add,
                        style: CircleButtonStyle.primary,
                        strokeWidth: 2.2,
                        semanticLabel: l10n.addCategory,
                        onPressed: () => showCategoryEditor(context),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(header: true, child: Text(l10n.categoriesTitle, style: t.title)),
                      const SizedBox(height: 6),
                      Text(
                        l10n.categoriesSubtitle(categories.value?.length ?? 0),
                        style: t.bodyMedium.copyWith(color: c.muted, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              ...categories.when(
                loading: () => [const SliverFillRemaining(hasScrollBody: false, child: LoadingState())],
                error: (e, _) => [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: ErrorState(
                        error: e,
                        onRetry: () => ref.read(categoryRepositoryProvider).refresh().catchError((_) {}),
                      ),
                    ),
                  ),
                ],
                data: (list) => [
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 22, 20, 0),
                    sliver: SliverToBoxAdapter(child: _CategoryList(categories: list)),
                  ),
                  SliverPadding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 14, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _DashedAddButton(label: l10n.addNewCategory, onTap: () => showCategoryEditor(context)),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          20,
                          16,
                          20,
                          16 + MediaQuery.paddingOf(context).bottom,
                        ),
                        child: Text(
                          l10n.categoryDeleteNote,
                          textAlign: TextAlign.center,
                          style: t.caption.copyWith(fontWeight: FontWeight.w400, height: 1.7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  const _CategoryList({required this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final stats = ref.watch(categoryStatsProvider);
    final currency = ref.watch(currencyProvider);
    final lang = context.lang;

    return ClipRRect(
      borderRadius: AppRadii.listCardAll,
      child: ColoredBox(
        color: c.card,
        child: ReorderableListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: categories.length,
          proxyDecorator: (child, index, animation) => AnimatedBuilder(
            animation: animation,
            builder: (context, child) => Material(
              color: c.card,
              elevation: 0,
              borderRadius: AppRadii.listCardAll,
              shadowColor: Colors.transparent,
              child: Transform.scale(scale: 1 + 0.02 * animation.value, child: child),
            ),
            child: child,
          ),
          onReorderItem: (oldIndex, newIndex) {
            final ids = categories.map((e) => e.id).toList();
            ids.insert(newIndex, ids.removeAt(oldIndex));
            unawaited(
              ref.read(categoryActionsProvider).reorder(ids).catchError((Object e) {
                if (context.mounted) showErrorToast(context, describeFailure(context, e));
              }),
            );
          },
          itemBuilder: (context, i) {
            final cat = categories[i];
            final s = stats[cat.id];
            final name = cat.displayName(context.l10n);
            return Container(
              key: ValueKey(cat.id),
              decoration: BoxDecoration(
                color: c.card,
                border: i == 0 ? null : Border(top: BorderSide(color: c.stroke)),
              ),
              child: Pressable(
                scale: 0.98,
                onTap: () => showCategoryEditor(context, category: cat),
                semanticLabel: name,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 13, 4, 13),
                  child: Row(
                    children: [
                      CategoryIconCircle(iconKey: cat.iconKey, colorHex: cat.colorHex, size: 46),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.body.copyWith(fontSize: 16, height: 1.3),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              context.l10n.categoryMeta(
                                s?.count ?? 0,
                                MoneyFormat.withSymbol(s?.total ?? 0, currency, lang),
                              ),
                              style: context.text.caption
                                  .copyWith(fontWeight: FontWeight.w400, fontFeatures: AppTextStyles.tabular),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: CategoryPalette.resolve(cat.colorHex, c.brightness).fg,
                          shape: BoxShape.circle,
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: i,
                        child: Semantics(
                          label: context.l10n.reorderCategory(name),
                          child: SizedBox(
                            width: 40,
                            height: 44,
                            child: Center(child: AppIcon(AppIcons.grip, size: 18, strokeWidth: 2.6, color: c.faint)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DashedAddButton extends StatelessWidget {
  const _DashedAddButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      child: CustomPaint(
        painter: _DashedBorderPainter(color: c.dashed, radius: 20),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(AppIcons.add, size: 18, strokeWidth: 2.2, color: c.lilac),
              const SizedBox(width: 8),
              Text(label, style: context.text.body.copyWith(color: c.lilac)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)).deflate(0.75);
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = color;
    for (final PathMetric m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 6), paint);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color || old.radius != radius;
}
