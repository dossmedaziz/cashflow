import 'package:flutter/material.dart';

/// Color tokens extracted from the Cashflow design (style guide + screens).
///
/// The design is flat: one background, flat cards, no gradients or glows.
/// Color lives in the elements — indigo for action, mint for good news,
/// a soft pastel per category.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    required this.bg,
    required this.card,
    required this.field,
    required this.fieldPressed,
    required this.stroke,
    required this.text,
    required this.textSecondary,
    required this.muted,
    required this.faint,
    required this.hero,
    required this.heroChip,
    required this.avatarBg,
    required this.avatarFg,
    required this.chipBg,
    required this.chipFg,
    required this.fab,
    required this.fabFg,
    required this.primary,
    required this.onPrimary,
    required this.mint,
    required this.mintBg,
    required this.peach,
    required this.peachBg,
    required this.rose,
    required this.roseBg,
    required this.swipeDelete,
    required this.lilac,
    required this.lilacBg,
    required this.dateIcon,
    required this.handle,
    required this.dashed,
    required this.toastBg,
    required this.toastFg,
    required this.disabledBg,
    required this.disabledFg,
    required this.amountEmpty,
  });

  final Brightness brightness;

  /// Screen background.
  final Color bg;

  /// Cards, sheets, list containers.
  final Color card;

  /// Inputs, keypad keys, secondary icon buttons.
  final Color field;

  /// Pressed keypad key.
  final Color fieldPressed;

  /// Dividers between rows.
  final Color stroke;
  final Color text;

  /// Slightly dimmer than [text] — neutral icons, chip labels.
  final Color textSecondary;
  final Color muted;

  /// Very low-emphasis glyphs (drag handle, chevrons, footer).
  final Color faint;

  /// Month total card.
  final Color hero;
  final Color heroChip;
  final Color avatarBg;
  final Color avatarFg;
  final Color chipBg;
  final Color chipFg;

  /// Neutral "add" pill on Home.
  final Color fab;
  final Color fabFg;
  final Color primary;
  final Color onPrimary;

  /// Spending less than last month.
  final Color mint;
  final Color mintBg;

  /// Spending more than last month.
  final Color peach;
  final Color peachBg;

  /// Destructive actions.
  final Color rose;
  final Color roseBg;

  /// Revealed swipe-to-delete panel.
  final Color swipeDelete;

  /// Links, undo, directional icons.
  final Color lilac;
  final Color lilacBg;
  final Color dateIcon;

  /// Bottom-sheet grab handle.
  final Color handle;
  final Color dashed;
  final Color toastBg;
  final Color toastFg;
  final Color disabledBg;
  final Color disabledFg;

  /// Amount display when the value is still 0.
  final Color amountEmpty;

  /// Bottom-sheet scrim: black 55%.
  Color get scrim => const Color(0x8C000000);

  static const dark = AppColors(
    brightness: Brightness.dark,
    bg: Color(0xFF1C1C1E),
    card: Color(0xFF262629),
    field: Color(0xFF2E2E32),
    fieldPressed: Color(0xFF38383D),
    stroke: Color(0xFF333337),
    text: Color(0xFFF2F2F4),
    textSecondary: Color(0xFFD4D4D8),
    muted: Color(0xFF8E8E93),
    faint: Color(0xFF5E5E66),
    hero: Color(0xFF262A40),
    heroChip: Color(0x12FFFFFF),
    avatarBg: Color(0xFF2E3350),
    avatarFg: Color(0xFFAFC0FF),
    chipBg: Color(0xFF262629),
    chipFg: Color(0xFFD1D1D6),
    fab: Color(0xFF2E2E32),
    fabFg: Color(0xFFFFFFFF),
    primary: Color(0xFF4263EB),
    onPrimary: Color(0xFFFFFFFF),
    mint: Color(0xFF6EE7B7),
    mintBg: Color(0x1F6EE7B7),
    peach: Color(0xFFFDBA74),
    peachBg: Color(0x1FFDBA74),
    rose: Color(0xFFFB7185),
    roseBg: Color(0x24FB7185),
    swipeDelete: Color(0xFFE5484D),
    lilac: Color(0xFFC4B5FD),
    lilacBg: Color(0x24C4B5FD),
    dateIcon: Color(0xFFA78BFA),
    handle: Color(0xFF3A3A42),
    dashed: Color(0xFF3A3A44),
    toastBg: Color(0xFF26262C),
    toastFg: Color(0xFFF4F4F6),
    disabledBg: Color(0xFF2E2E32),
    disabledFg: Color(0xFF5E5E66),
    amountEmpty: Color(0xFF5A5A63),
  );

  static const light = AppColors(
    brightness: Brightness.light,
    bg: Color(0xFFF2F2F4),
    card: Color(0xFFFFFFFF),
    field: Color(0xFFE9E9EE),
    fieldPressed: Color(0xFFDCDCE2),
    stroke: Color(0xFFEBEBEF),
    text: Color(0xFF111114),
    textSecondary: Color(0xFF3F3F46),
    muted: Color(0xFF62626B),
    faint: Color(0xFFA1A1AA),
    hero: Color(0xFFE6EAFF),
    heroChip: Color(0x0F111114),
    avatarBg: Color(0xFFE3E7FF),
    avatarFg: Color(0xFF3046C5),
    chipBg: Color(0xFFFFFFFF),
    chipFg: Color(0xFF3F3F46),
    fab: Color(0xFF111114),
    fabFg: Color(0xFFFFFFFF),
    primary: Color(0xFF4263EB),
    onPrimary: Color(0xFFFFFFFF),
    mint: Color(0xFF047857),
    mintBg: Color(0xFFD1FAE5),
    peach: Color(0xFFC2410C),
    peachBg: Color(0xFFFFEDD5),
    rose: Color(0xFFE11D48),
    roseBg: Color(0xFFFFE4E6),
    swipeDelete: Color(0xFFE5484D),
    lilac: Color(0xFF6D28D9),
    lilacBg: Color(0xFFEDE9FE),
    dateIcon: Color(0xFF7C3AED),
    handle: Color(0xFFD4D4DA),
    dashed: Color(0xFFC9C9D1),
    toastBg: Color(0xFF26262C),
    toastFg: Color(0xFFF4F4F6),
    disabledBg: Color(0xFFE9E9EE),
    disabledFg: Color(0xFFA1A1AA),
    amountEmpty: Color(0xFFB4B4BC),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      bg: l(bg, other.bg),
      card: l(card, other.card),
      field: l(field, other.field),
      fieldPressed: l(fieldPressed, other.fieldPressed),
      stroke: l(stroke, other.stroke),
      text: l(text, other.text),
      textSecondary: l(textSecondary, other.textSecondary),
      muted: l(muted, other.muted),
      faint: l(faint, other.faint),
      hero: l(hero, other.hero),
      heroChip: l(heroChip, other.heroChip),
      avatarBg: l(avatarBg, other.avatarBg),
      avatarFg: l(avatarFg, other.avatarFg),
      chipBg: l(chipBg, other.chipBg),
      chipFg: l(chipFg, other.chipFg),
      fab: l(fab, other.fab),
      fabFg: l(fabFg, other.fabFg),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      mint: l(mint, other.mint),
      mintBg: l(mintBg, other.mintBg),
      peach: l(peach, other.peach),
      peachBg: l(peachBg, other.peachBg),
      rose: l(rose, other.rose),
      roseBg: l(roseBg, other.roseBg),
      swipeDelete: l(swipeDelete, other.swipeDelete),
      lilac: l(lilac, other.lilac),
      lilacBg: l(lilacBg, other.lilacBg),
      dateIcon: l(dateIcon, other.dateIcon),
      handle: l(handle, other.handle),
      dashed: l(dashed, other.dashed),
      toastBg: l(toastBg, other.toastBg),
      toastFg: l(toastFg, other.toastFg),
      disabledBg: l(disabledBg, other.disabledBg),
      disabledFg: l(disabledFg, other.disabledFg),
      amountEmpty: l(amountEmpty, other.amountEmpty),
    );
  }
}

/// A category color resolved for the current theme.
@immutable
class CategoryTone {
  const CategoryTone({required this.fg, required this.bg, required this.selectedBg});

  /// Icon and label color.
  final Color fg;

  /// Tinted fill behind icons and badges.
  final Color bg;

  /// Slightly stronger tint for a selected picker pill.
  final Color selectedBg;
}

/// Category colors: pastel on a 12–16% tint in dark mode, deep text on a pale
/// fill in light mode (all ≥ 4.5:1 per the design).
abstract final class CategoryPalette {
  /// The 8 colors offered by the category color picker, in design order.
  static const pickerColors = <String>[
    '#FDBA74', // orange
    '#FDE68A', // yellow
    '#6EE7B7', // green
    '#67E8F9', // teal
    '#93C5FD', // blue
    '#C4B5FD', // violet
    '#F9A8D4', // pink
    '#FCA5A5', // red
  ];

  /// Light-theme pairs: stored (dark) color → (deep text, pale fill).
  static const _light = <String, (int, int)>{
    '#FDBA74': (0xFFC2410C, 0xFFFFEDD5),
    '#93C5FD': (0xFF1D4ED8, 0xFFDBEAFE),
    '#F9A8D4': (0xFFBE185D, 0xFFFCE7F3),
    '#FDE68A': (0xFFA16207, 0xFFFEF3C7),
    '#6EE7B7': (0xFF047857, 0xFFD1FAE5),
    '#C4C4CC': (0xFF52525B, 0xFFEDEDF0),
    '#67E8F9': (0xFF0E7490, 0xFFCFFAFE),
    '#C4B5FD': (0xFF6D28D9, 0xFFEDE9FE),
    '#FCA5A5': (0xFFB91C1C, 0xFFFEE2E2),
  };

  static Color parse(String hex) {
    final clean = hex.replaceFirst('#', '');
    final value = int.tryParse(clean, radix: 16);
    if (value == null || clean.length != 6) return const Color(0xFFC4C4CC);
    return Color(0xFF000000 | value);
  }

  static String toHex(Color color) {
    final rgb = color.toARGB32() & 0xFFFFFF;
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  static CategoryTone resolve(String hex, Brightness brightness) {
    final base = parse(hex);
    if (brightness == Brightness.dark) {
      return CategoryTone(
        fg: base,
        bg: base.withValues(alpha: 0.14),
        selectedBg: base.withValues(alpha: 0.16),
      );
    }
    final pair = _light[hex.toUpperCase()];
    if (pair != null) {
      return CategoryTone(fg: Color(pair.$1), bg: Color(pair.$2), selectedBg: Color(pair.$2));
    }
    final hsl = HSLColor.fromColor(base);
    final deep = hsl.withLightness((hsl.lightness * 0.45).clamp(0.2, 0.4)).toColor();
    final pale = hsl.withLightness(0.93).toColor();
    return CategoryTone(fg: deep, bg: pale, selectedBg: pale);
  }
}
