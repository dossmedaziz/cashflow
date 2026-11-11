import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/icons/app_icons.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/dates.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/numeric_keypad.dart';
import '../../../core/widgets/pressable.dart';
import '../../categories/providers/categories_providers.dart';
import '../../settings/providers/settings_providers.dart';
import '../data/expense.dart';
import '../providers/expenses_providers.dart';

/// Opens the add (expense == null) or edit sheet.
///
/// Returns the expense when the user chose "Delete" so the caller can delete
/// it with an undo toast; otherwise null.
Future<Expense?> showExpenseSheet(BuildContext context, {Expense? expense, String? initialCategoryId}) =>
    showAppBottomSheet<Expense>(
      context: context,
      builder: (_) => ExpenseSheet(expense: expense, initialCategoryId: initialCategoryId),
    );

class ExpenseSheet extends ConsumerStatefulWidget {
  const ExpenseSheet({super.key, this.expense, this.initialCategoryId});

  final Expense? expense;
  final String? initialCategoryId;

  @override
  ConsumerState<ExpenseSheet> createState() => _ExpenseSheetState();
}

class _ExpenseSheetState extends ConsumerState<ExpenseSheet> {
  late String _amount;
  String? _categoryId;
  late DateTime _date;
  late final TextEditingController _note = TextEditingController(text: widget.expense?.note ?? '');
  bool _saving = false;
  List<ExpenseInputError> _errors = const [];

  bool get _isEdit => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final currency = ref.read(currencyProvider);
    final e = widget.expense;
    _amount = e == null ? '0' : MoneyFormat.toInput(e.amount, currency);
    _categoryId = e?.categoryId ?? widget.initialCategoryId;
    _date = e?.date ?? ref.read(clockProvider)();
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _onKey(String key) {
    final currency = ref.read(currencyProvider);
    setState(() {
      _amount = key == 'clear' ? '0' : AmountInput.apply(_amount, key, currency);
      if (_errors.isNotEmpty) _errors = _currentInput().validate();
    });
  }

  ExpenseInput _currentInput() => ExpenseInput(
        amount: MoneyFormat.parseInput(_amount),
        categoryId: _categoryId ?? '',
        date: _date,
        note: _note.text,
      );

  Future<void> _pickDate() async {
    final now = ref.read(clockProvider)();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isAfter(now) ? now : _date,
      firstDate: DateTime(2000),
      lastDate: now,
      helpText: context.l10n.chooseDate,
    );
    if (picked == null || !mounted) return;
    // Keep the original time of day (or "now" for a new expense).
    final time = _isEdit ? _date : now;
    setState(() => _date = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute, time.second));
  }

  Future<void> _save() async {
    final input = _currentInput();
    final errors = input.validate();
    if (errors.isNotEmpty) {
      setState(() => _errors = errors);
      unawaited(HapticFeedback.heavyImpact());
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(expenseRepositoryProvider);
    try {
      if (_isEdit) {
        await repo.update(widget.expense!.id, input);
      } else {
        await repo.create(input);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorToast(context, describeFailure(context, e));
    }
  }

  void _delete() => Navigator.of(context).pop(widget.expense);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final lang = context.lang;
    final currency = ref.watch(currencyProvider);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final now = ref.watch(clockProvider)();
    final isZero = MoneyFormat.parseInput(_amount) == 0;

    return AppBottomSheet(
      title: _isEdit ? l10n.editExpense : l10n.newExpense,
      trailing: _isEdit
          ? CircleIconButton(
              icon: AppIcons.delete,
              style: CircleButtonStyle.danger,
              iconSize: 19,
              strokeWidth: 1.9,
              semanticLabel: l10n.deleteExpense,
              onPressed: _saving ? null : _delete,
            )
          : null,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text(l10n.amount, textAlign: TextAlign.center, style: t.subtitle),
            const SizedBox(height: 2),
            Semantics(
              liveRegion: true,
              label: '${l10n.amount}: ${AmountInput.display(_amount, lang)} ${currency.symbolFor(lang)}',
              excludeSemantics: true,
              child: SizedBox(
                height: 64,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              AmountInput.display(_amount, lang),
                              key: const ValueKey('amount-display'),
                              style: t.amount.copyWith(
                                color: _errors.contains(ExpenseInputError.amount)
                                    ? c.rose
                                    : (isZero ? c.amountEmpty : c.text),
                              ),
                            ),
                            const SizedBox(width: 3),
                            _Caret(color: c.primary),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        currency.symbolFor(lang),
                        style: t.body.copyWith(fontSize: 18, color: c.muted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(l10n.category, style: t.label),
            const SizedBox(height: 8),
            Semantics(
              label: l10n.category,
              container: true,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: AppSizes.pickerPill,
                ),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  return CategoryPickerPill(
                    key: ValueKey('pick-${cat.id}'),
                    label: cat.displayName(l10n),
                    iconKey: cat.iconKey,
                    colorHex: cat.colorHex,
                    selected: cat.id == _categoryId,
                    onTap: () => setState(() {
                      _categoryId = cat.id;
                      _errors = _errors.where((e) => e != ExpenseInputError.category).toList();
                    }),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: AppSizes.field,
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: c.field, borderRadius: AppRadii.fieldAll),
                    child: Row(
                      children: [
                        AppIcon(AppIcons.note, size: 18, color: c.muted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _note,
                            maxLength: 200,
                            textInputAction: TextInputAction.done,
                            style: t.bodyMedium.copyWith(color: c.text),
                            decoration: InputDecoration(
                              isCollapsed: true,
                              border: InputBorder.none,
                              counterText: '',
                              hintText: l10n.notePlaceholder,
                              hintStyle: t.bodyMedium.copyWith(color: c.muted),
                              semanticCounterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Pressable(
                  onTap: _pickDate,
                  semanticLabel: '${l10n.chooseDate}: ${DateLabels(l10n, lang).short(_date, now)}',
                  child: Container(
                    height: AppSizes.field,
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
                    decoration: BoxDecoration(color: c.field, borderRadius: AppRadii.fieldAll),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(AppIcons.date, size: 18, color: c.dateIcon),
                        const SizedBox(width: 8),
                        Text(
                          DateLabels(l10n, lang).short(_date, now),
                          style: t.body.copyWith(fontSize: 14, color: c.textSecondary, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            NumericKeypad(
              onKey: _onKey,
              decimalLabel: MoneyFormat.decimalSeparator(lang),
              decimalSemantics: l10n.decimalPoint,
              backspaceSemantics: l10n.deleteDigit,
              showDecimal: currency.decimals > 0,
            ),
            MotionSize(
              duration: AppMotion.toggle,
              child: _errors.isEmpty
                  ? const SizedBox(width: double.infinity, height: 16)
                  : Padding(
                      padding: const EdgeInsetsDirectional.only(top: 12, bottom: 4),
                      child: Text(
                        _errors.contains(ExpenseInputError.amount)
                            ? l10n.errorAmountRequired
                            : l10n.errorCategoryRequired,
                        key: const ValueKey('expense-error'),
                        textAlign: TextAlign.center,
                        style: t.subtitle.copyWith(color: c.rose),
                      ),
                    ),
            ),
            AppButton(
              key: const ValueKey('expense-save'),
              label: _isEdit ? l10n.saveChanges : l10n.add,
              icon: _isEdit ? AppIcons.check : AppIcons.add,
              loading: _saving,
              onPressed: _save,
            ),
            if (_isEdit) ...[
              const SizedBox(height: 6),
              TextButton(
                onPressed: _saving ? null : _delete,
                style: TextButton.styleFrom(
                  foregroundColor: c.rose,
                  minimumSize: const Size.fromHeight(44),
                  textStyle: t.buttonSmall,
                ),
                child: Text(l10n.deleteExpense),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Blinking amount caret (1.1 s, step).
class _Caret extends StatefulWidget {
  const _Caret({required this.color});

  final Color color;

  @override
  State<_Caret> createState() => _CaretState();
}

class _CaretState extends State<_Caret> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Opacity(
        opacity: _c.value < 0.5 ? 1 : 0,
        child: Container(
          width: 3,
          height: 44,
          decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(2)),
        ),
      ),
    );
  }
}
