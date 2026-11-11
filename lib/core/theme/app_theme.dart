import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData dark({required bool arabic}) => _build(AppColors.dark, arabic: arabic);

  static ThemeData light({required bool arabic}) => _build(AppColors.light, arabic: arabic);

  static ThemeData _build(AppColors c, {required bool arabic}) {
    final isDark = c.brightness == Brightness.dark;
    final text = AppTextStyles.build(text: c.text, muted: c.muted, arabic: arabic);
    final scheme = ColorScheme(
      brightness: c.brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.lilac,
      onSecondary: c.bg,
      error: c.rose,
      onError: c.onPrimary,
      surface: c.card,
      onSurface: c.text,
      surfaceContainerHighest: c.field,
      outline: c.stroke,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      fontFamily: AppTextStyles.fontFamily,
      fontFamilyFallback: AppTextStyles.fontFallback,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: [c, text],
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: c.text,
        displayColor: c.text,
        fontFamily: AppTextStyles.fontFamily,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        elevation: 0,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      dividerTheme: DividerThemeData(color: c.stroke, thickness: 1, space: 1),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.primary,
        selectionColor: c.primary.withValues(alpha: 0.3),
        selectionHandleColor: c.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: c.primary),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.toastBg,
        contentTextStyle: text.bodyMedium.copyWith(color: c.toastFg, fontSize: 14),
        actionTextColor: AppColors.dark.lilac,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.heroAll),
        titleTextStyle: text.sheetTitle,
        contentTextStyle: text.bodyMedium.copyWith(color: c.muted, height: 1.6),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.card,
        modalBackgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: c.scrim,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.sheetTop),
        elevation: 0,
        modalElevation: 0,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.card,
        surfaceTintColor: Colors.transparent,
        headerBackgroundColor: c.hero,
        headerForegroundColor: c.text,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.heroAll),
        todayBorder: BorderSide(color: c.primary),
        dayStyle: text.bodyMedium,
        yearStyle: text.bodyMedium,
        confirmButtonStyle: TextButton.styleFrom(foregroundColor: c.lilac),
        cancelButtonStyle: TextButton.styleFrom(foregroundColor: c.muted),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.lilac,
          textStyle: text.buttonSmall,
        ),
      ),
    );
  }
}

extension AppThemeX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
