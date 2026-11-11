import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/env.dart';
import '../../../core/icons/app_icons.dart';
import '../../../core/icons/brand_art.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/utils/money.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/feedback.dart';
import '../../../core/widgets/pressable.dart';
import '../../../core/widgets/segmented_control.dart';
import '../../auth/providers/auth_providers.dart';
import '../../categories/providers/categories_providers.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final t = context.text;
    final l10n = context.l10n;
    final lang = context.lang;
    final user = ref.watch(currentUserProvider);
    final language = ref.watch(languageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currency = ref.watch(currencyProvider);
    final categoryCount = ref.watch(categoriesProvider).value?.length;
    final signingOut = ref.watch(signInControllerProvider).isLoading;

    Widget sectionLabel(String text) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 4, 8),
          child: Semantics(header: true, child: Text(text, style: t.label)),
        );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: CircleIconButton(
                        icon: AppIcons.back,
                        mirror: IconMirror.inLtr,
                        semanticLabel: l10n.back,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Semantics(header: true, child: Text(l10n.settingsTitle, style: t.title)),
                    const SizedBox(height: 16),
                    // Profile
                    Semantics(
                      label: l10n.account,
                      container: true,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: c.card, borderRadius: AppRadii.heroAll),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(color: c.avatarBg, shape: BoxShape.circle),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: c.stroke,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: c.card, width: 2),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  user?.initial ?? '',
                                  style: t.heading.copyWith(fontSize: 20, height: 1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (user?.name != null)
                                    Text(
                                      user!.name!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.sheetTitle.copyWith(height: 1.3),
                                    ),
                                  if (user?.email != null) ...[
                                    const SizedBox(height: 3),
                                    // Email addresses never mirror.
                                    Text(
                                      user!.email!,
                                      textDirection: TextDirection.ltr,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.subtitle.copyWith(fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                  const SizedBox(height: 7),
                                  Container(
                                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(color: c.stroke, borderRadius: AppRadii.pillAll),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const GoogleLogo(size: 12),
                                        const SizedBox(width: 6),
                                        Text(
                                          l10n.connectedWithGoogle,
                                          style: t.badge.copyWith(color: c.textSecondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    sectionLabel(l10n.languageLabel),
                    SegmentedControl<AppLanguage>(
                      semanticLabel: l10n.languageLabel,
                      selected: language,
                      onChanged: (l) => ref.read(languageProvider.notifier).set(l),
                      options: [
                        for (final l in AppLanguage.values)
                          SegmentOption(value: l, label: l.nativeName, locale: l.locale),
                      ],
                    ),
                    const SizedBox(height: 18),
                    sectionLabel(l10n.appearance),
                    SegmentedControl<ThemeMode>(
                      semanticLabel: l10n.appearance,
                      selected: themeMode,
                      onChanged: (m) => ref.read(themeModeProvider.notifier).set(m),
                      options: [
                        SegmentOption(value: ThemeMode.dark, label: l10n.themeDark, icon: AppIcons.moon),
                        SegmentOption(value: ThemeMode.light, label: l10n.themeLight, icon: AppIcons.sun),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: AppRadii.listCardAll,
                      child: ColoredBox(
                        color: c.card,
                        child: Column(
                          children: [
                            _SettingsRow(
                              icon: AppIcons.coin,
                              colorHex: '#6EE7B7',
                              title: l10n.currency,
                              value: '${_currencyName(l10n, currency)} · ${currency.symbolFor(lang)}',
                              onTap: () => _pickCurrency(context, ref),
                            ),
                            Divider(height: 1, color: c.stroke),
                            _SettingsRow(
                              icon: AppIcons.other,
                              colorHex: '#C4B5FD',
                              title: l10n.categoriesTitle,
                              value: categoryCount?.toString() ?? '',
                              onTap: () => context.push(Routes.categories),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      label: l10n.logout,
                      icon: AppIcons.logout,
                      variant: AppButtonVariant.danger,
                      radius: 18,
                      loading: signingOut,
                      onPressed: () async {
                        try {
                          await ref.read(signInControllerProvider.notifier).signOut();
                        } catch (e) {
                          if (context.mounted) showErrorToast(context, describeFailure(context, e));
                        }
                      },
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Cashflow ${Env.appVersion}'),
                          TextSpan(text: ' · ${l10n.footerTagline}'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: t.caption.copyWith(color: c.faint, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _pickCurrency(BuildContext context, WidgetRef ref) => showAppBottomSheet<void>(
        context: context,
        builder: (sheetContext) => Consumer(
          builder: (context, ref, _) {
            final c = context.colors;
            final t = context.text;
            final l10n = context.l10n;
            final lang = context.lang;
            final selected = ref.watch(currencyProvider);
            return AppBottomSheet(
              title: l10n.chooseCurrency,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: AppRadii.listCardAll,
                      child: ColoredBox(
                        color: c.field,
                        child: Column(
                          children: [
                            for (final cur in Currency.all) ...[
                              if (cur != Currency.all.first) Divider(height: 1, color: c.stroke),
                              Pressable(
                                scale: 0.98,
                                selected: cur == selected,
                                semanticLabel: _currencyName(l10n, cur),
                                onTap: () async {
                                  await ref.read(currencyProvider.notifier).set(cur);
                                  if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(_currencyName(l10n, cur), style: t.body)),
                                      Text(
                                        '${cur.symbolFor(lang)} · ${MoneyFormat.format(1234500, cur, lang)}',
                                        style: t.subtitle,
                                      ),
                                      const SizedBox(width: 12),
                                      AnimatedOpacity(
                                        opacity: cur == selected ? 1 : 0,
                                        duration: AppMotion.of(context, AppMotion.toggle),
                                        child: AppIcon(AppIcons.check, size: 18, strokeWidth: 2.4, color: c.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.currencyNote,
                      textAlign: TextAlign.center,
                      style: t.caption.copyWith(fontWeight: FontWeight.w400, height: 1.6),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}

String _currencyName(AppLocalizations l10n, Currency c) => switch (c.code) {
      'TND' => l10n.currencyTND,
      'EUR' => l10n.currencyEUR,
      'USD' => l10n.currencyUSD,
      'MAD' => l10n.currencyMAD,
      'DZD' => l10n.currencyDZD,
      'LYD' => l10n.currencyLYD,
      _ => c.code,
    };

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.colorHex,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String icon;
  final String colorHex;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Pressable(
      scale: 0.98,
      onTap: onTap,
      semanticLabel: '$title, $value',
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _TintCircle(icon: icon, colorHex: colorHex),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: t.body)),
            Flexible(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.bodyMedium.copyWith(color: c.muted, fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(width: 8),
            AppIcon(AppIcons.forward, size: 18, strokeWidth: 2, color: c.faint, mirror: IconMirror.inLtr),
          ],
        ),
      ),
    );
  }
}

class _TintCircle extends StatelessWidget {
  const _TintCircle({required this.icon, required this.colorHex});

  final String icon;
  final String colorHex;

  @override
  Widget build(BuildContext context) {
    final tone = CategoryPalette.resolve(colorHex, context.colors.brightness);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: tone.bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: AppIcon(icon, size: 20, color: tone.fg),
    );
  }
}
