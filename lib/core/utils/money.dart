import 'package:intl/intl.dart';

/// Amounts are stored as integers in **thousandths** of the currency unit
/// (millimes for TND) — never as doubles. A fixed scale means switching the
/// display currency never silently rescales stored values.
const int kAmountScale = 1000;

/// Upper bound accepted by the database check constraint.
const int kMaxAmount = 999999999999;

/// A supported display currency.
class Currency {
  const Currency({
    required this.code,
    required this.decimals,
    required this.arabicSymbol,
    required this.latinSymbol,
  });

  /// ISO 4217 code, stored in profiles.currency.
  final String code;

  /// Fraction digits shown and accepted by the keypad (≤ 3).
  final int decimals;
  final String arabicSymbol;
  final String latinSymbol;

  /// Symbol follows the locale: د.ت in Arabic, TND in French/English.
  String symbolFor(String languageCode) => languageCode == 'ar' ? arabicSymbol : latinSymbol;

  static const tnd = Currency(code: 'TND', decimals: 3, arabicSymbol: 'د.ت', latinSymbol: 'TND');
  static const eur = Currency(code: 'EUR', decimals: 2, arabicSymbol: '€', latinSymbol: '€');
  static const usd = Currency(code: 'USD', decimals: 2, arabicSymbol: r'$', latinSymbol: r'$');
  static const mad = Currency(code: 'MAD', decimals: 2, arabicSymbol: 'د.م', latinSymbol: 'MAD');
  static const dzd = Currency(code: 'DZD', decimals: 2, arabicSymbol: 'د.ج', latinSymbol: 'DZD');
  static const lyd = Currency(code: 'LYD', decimals: 3, arabicSymbol: 'ل.د', latinSymbol: 'LYD');

  static const all = <Currency>[tnd, eur, usd, mad, dzd, lyd];

  static Currency byCode(String? code) => all.firstWhere((c) => c.code == code, orElse: () => tnd);

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// Formats stored amounts with Western digits in every language.
///
/// * ar / en → `1,284.500`
/// * fr      → `1 284,500` (narrow no-break space)
abstract final class MoneyFormat {
  static String decimalSeparator(String languageCode) => languageCode == 'fr' ? ',' : '.';

  static String groupSeparator(String languageCode) => languageCode == 'fr' ? ' ' : ',';

  /// Formats [amount] (in thousandths) without the currency symbol.
  static String format(int amount, Currency currency, String languageCode) {
    final negative = amount < 0;
    final abs = amount.abs();
    final whole = abs ~/ kAmountScale;
    final fraction = abs % kAmountScale;
    // Integer-only grouping: no floating point anywhere.
    final grouped = NumberFormat('#,##0', 'en').format(whole).replaceAll(',', groupSeparator(languageCode));
    final buffer = StringBuffer(negative ? '-' : '')..write(grouped);
    if (currency.decimals > 0) {
      final digits = fraction.toString().padLeft(3, '0').substring(0, currency.decimals);
      buffer
        ..write(decimalSeparator(languageCode))
        ..write(digits);
    }
    return buffer.toString();
  }

  /// `1,284.500 د.ت` / `1 284,500 TND`.
  static String withSymbol(int amount, Currency currency, String languageCode) =>
      '${format(amount, currency, languageCode)} ${currency.symbolFor(languageCode)}';

  /// Converts raw keypad input (`"24.5"`, Western digits, `.` separator)
  /// into thousandths. Returns 0 for empty input.
  static int parseInput(String input) {
    if (input.isEmpty || input == '.') return 0;
    final parts = input.split('.');
    final whole = int.tryParse(parts[0].isEmpty ? '0' : parts[0]) ?? 0;
    var frac = parts.length > 1 ? parts[1] : '';
    if (frac.length > 3) frac = frac.substring(0, 3);
    final fraction = int.parse(frac.padRight(3, '0'));
    return whole * kAmountScale + fraction;
  }

  /// Converts thousandths back into keypad input, trimming trailing zeros
  /// beyond what the user typed (e.g. 24500 → `"24.5"`, 12000 → `"12"`).
  static String toInput(int amount, Currency currency) {
    final whole = amount ~/ kAmountScale;
    final fraction = amount % kAmountScale;
    if (fraction == 0) return '$whole';
    var digits = fraction.toString().padLeft(3, '0').substring(0, currency.decimals);
    digits = digits.replaceFirst(RegExp(r'0+$'), '');
    return digits.isEmpty ? '$whole' : '$whole.$digits';
  }
}

/// Keypad editing rules shared by the sheet and its tests.
abstract final class AmountInput {
  static const maxWholeDigits = 9;

  /// Applies one keypad key (`0`–`9`, `.`, or `back`) to [current].
  static String apply(String current, String key, Currency currency) {
    if (key == 'back') {
      return current.length <= 1 ? '0' : current.substring(0, current.length - 1);
    }
    if (key == '.') {
      if (currency.decimals == 0 || current.contains('.')) return current;
      return '$current.';
    }
    final dot = current.indexOf('.');
    if (dot >= 0) {
      if (current.length - dot - 1 >= currency.decimals) return current;
      return current + key;
    }
    if (current == '0') return key;
    if (current.length >= maxWholeDigits) return current;
    return current + key;
  }

  /// What the amount display shows (locale decimal separator, grouping).
  static String display(String input, String languageCode) {
    final parts = input.split('.');
    final whole = int.tryParse(parts[0]) ?? 0;
    final grouped = NumberFormat('#,##0', 'en').format(whole).replaceAll(',', MoneyFormat.groupSeparator(languageCode));
    if (parts.length == 1) return grouped;
    return '$grouped${MoneyFormat.decimalSeparator(languageCode)}${parts[1]}';
  }
}
