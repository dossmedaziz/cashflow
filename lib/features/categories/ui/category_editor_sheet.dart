import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/category_badge.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/pressable.dart';
import '../../expenses/providers/expenses_providers.dart';
import '../data/category.dart';
import '../providers/categories_providers.dart';

/// Opens the add (category == null) or edit sheet.
Future<void> showCategoryEditor(BuildContext context, {Category? category}) =>
    showAppBottomSheet<void>(context: context, builder: (_) => CategoryEditorSheet(category: category));

class CategoryEditorSheet extends ConsumerStatefulWidget {
  const CategoryEditorSheet({super.key, this.category});

  final Category? category;

  @override
  ConsumerState<CategoryEditorSheet> createState() => _CategoryEditorSheetState();
}

class _CategoryEditorSheetState extends ConsumerState<CategoryEditorSheet> {
  late final TextEditingController _name = TextEditingController();
  final _focus = FocusNode();
  late String _color = widget.category?.colorHex ?? CategoryPalette.pickerColors[3];
  late String _icon = widget.category?.iconKey ?? AppIcons.pickerKeys.first;
  bool _saving = false;
  bool _showErrors = false;
  bool _initialized = false;

  bool get _isEdit => widget.category != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _name.text = widget.category?.displayName(context.l10n) ?? '';
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Picker shows the 12 design icons, plus the category's own icon first
  /// when it's not one of them (e.g. a default category).
  List<String> get _iconChoices =>
      AppIcons.pickerKeys.contains(_icon) || !_isEdit ? AppIcons.pickerKeys : [_icon, ...AppIcons.pickerKeys];

  String _colorName(AppLocalizations l10n, String hex) => switch (CategoryPalette.pickerColors.indexOf(hex)) {
        0 => l10n.colorOrange,
        1 => l10n.colorYellow,
        2 => l10n.colorGreen,
        3 => l10n.colorTeal,
        4 => l10n.colorBlue,
        5 => l10n.colorViolet,
        6 => l10n.colorPink,
        7 => l10n.colorRed,
        _ => hex,
      };

  String _iconName(AppLocalizations l10n, String key) => switch (key) {
        'dumbbell' => l10n.iconDumbbell,
        'coffee' => l10n.iconCoffee,
        'book' => l10n.iconBook,
        'gift' => l10n.iconGift,
        'home' => l10n.iconHome,
        'plane' => l10n.iconPlane,
        'music' => l10n.iconMusic,
        'phone' => l10n.iconPhone,
        'grad' => l10n.iconGrad,
        'heart' => l10n.iconHeart,
        'bag' => l10n.iconBag,
        'star' => l10n.iconStar,
        _ => DefaultCategory.keys.contains(key) ? DefaultCategory.localizedName(l10n, key) : key,
      };

  Future<void> _save() async {
    final l10n = context.l10n;
    final raw = _name.text.trim();
    if (raw.isEmpty || raw.length > 40) {
      setState(() => _showErrors = true);
      return;
    }
    // Keep a default category's name localized if the user didn't change it.
    final category = widget.category;
    final keepLocalized = category != null &&
        category.defaultKey != null &&
        category.name == null &&
        raw == DefaultCategory.localizedName(l10n, category.defaultKey!);
    final input = CategoryInput(name: keepLocalized ? null : raw, colorHex: _color, iconKey: _icon);

    setState(() => _saving = true);
    final actions = ref.read(categoryActionsProvider);
    try {
      if (category == null) {
        await actions.create(input);
      } else {
        await actions.update(category.id, input);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorToast(context, describeFailure(context, e));
    }
  }

  Future<void> _delete() async {
    final category = widget.category!;
    final l10n = context.l10n;
    final count = ref.read(categoryStatsProvider)[category.id]?.count ?? 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteCategoryTitle(category.displayName(l10n))),
        content: Text(l10n.deleteCategoryBody(count)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(foregroundColor: ctx.colors.muted),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: ctx.colors.rose),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _saving = true);
    try {
      // Clear a filter pointing at the deleted category.
      if (ref.read(categoryFilterProvider) == category.id) {
        ref.read(categoryFilterProvider.notifier).select(null);
      }
      await ref.read(categoryActionsProvider).delete(category.id);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorToast(context, describeFailure(context, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final tone = CategoryPalette.resolve(_color, c.brightness);
    final nameError = _showErrors && _name.text.trim().isEmpty;
    final canDelete = _isEdit && !widget.category!.isOther;

    return AppBottomSheet(
      title: _isEdit ? l10n.editCategory : l10n.newCategory,
      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 28),
      trailing: canDelete
          ? CircleIconButton(
              icon: AppIcons.delete,
              style: CircleButtonStyle.danger,
              iconSize: 19,
              strokeWidth: 1.9,
              semanticLabel: l10n.deleteCategory,
              onPressed: _saving ? null : _delete,
            )
          : null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            // Live preview.
            Center(child: CategoryIconCircle(iconKey: _icon, colorHex: _color, size: 72)),
            const SizedBox(height: 10),
            Center(
              child: ValueListenableBuilder(
                valueListenable: _name,
                builder: (context, value, _) => CategoryBadge(
                  label: value.text.trim().isEmpty ? l10n.newCategory : value.text.trim(),
                  colorHex: _color,
                  large: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(l10n.categoryName, style: t.label),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: _focus,
              builder: (context, _) => AnimatedContainer(
                duration: AppMotion.of(context, AppMotion.toggle),
                height: AppSizes.input,
                decoration: BoxDecoration(
                  color: c.field,
                  borderRadius: AppRadii.fieldAll,
                  border: Border.all(
                    width: 1.5,
                    color: nameError ? c.rose : (_focus.hasFocus ? c.primary : Colors.transparent),
                  ),
                ),
                alignment: AlignmentDirectional.centerStart,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                child: TextField(
                  controller: _name,
                  focusNode: _focus,
                  maxLength: 40,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _save(),
                  style: t.bodyMedium.copyWith(fontSize: 16, color: c.text),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    counterText: '',
                    hintText: l10n.categoryNameHint,
                    hintStyle: t.bodyMedium.copyWith(fontSize: 16, color: c.muted),
                  ),
                ),
              ),
            ),
            if (nameError) ...[
              const SizedBox(height: 6),
              Text(l10n.errorNameRequired, style: t.caption.copyWith(color: c.rose)),
            ],
            const SizedBox(height: 16),
            Text(l10n.color, style: t.label),
            const SizedBox(height: 8),
            Semantics(
              label: l10n.color,
              container: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final hex in CategoryPalette.pickerColors)
                    _ColorDot(
                      hex: hex,
                      selected: hex == _color,
                      label: _colorName(l10n, hex),
                      ring: c.card,
                      onTap: () => setState(() => _color = hex),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Text(l10n.icon, style: t.label),
            const SizedBox(height: 8),
            GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 6,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.05,
              children: [
                for (final key in _iconChoices)
                  Pressable(
                    onTap: () => setState(() => _icon = key),
                    selected: key == _icon,
                    semanticLabel: _iconName(l10n, key),
                    child: AnimatedContainer(
                      duration: AppMotion.of(context, AppMotion.toggle),
                      decoration: BoxDecoration(
                        color: key == _icon ? tone.selectedBg : c.field,
                        borderRadius: AppRadii.fieldAll,
                        border: Border.all(color: key == _icon ? tone.fg : Colors.transparent, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: AppIcon(
                        AppIcons.forKey(key),
                        size: 21,
                        color: key == _icon
                            ? tone.fg
                            : (c.brightness == Brightness.dark ? const Color(0xFFC4C4CC) : c.textSecondary),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(label: l10n.saveCategory, loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.hex,
    required this.selected,
    required this.label,
    required this.ring,
    required this.onTap,
  });

  final String hex;
  final bool selected;
  final String label;
  final Color ring;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = CategoryPalette.parse(hex);
    return Pressable(
      onTap: onTap,
      selected: selected,
      semanticLabel: label,
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.toggle),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: selected
              ? [BoxShadow(color: color, spreadRadius: 5), BoxShadow(color: ring, spreadRadius: 3)]
              : null,
        ),
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: selected ? 1 : 0,
          duration: AppMotion.of(context, AppMotion.toggle),
          child: const AppIcon(AppIcons.check, size: 16, strokeWidth: 3, color: Color(0xFF262629)),
        ),
      ),
    );
  }
}
