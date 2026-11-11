import 'package:cashflow/core/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoneyFormat.format', () {
    test('Arabic and English use comma grouping and a dot, 3 decimals for TND', () {
      expect(MoneyFormat.format(1284500, Currency.tnd, 'ar'), '1,284.500');
      expect(MoneyFormat.format(1284500, Currency.tnd, 'en'), '1,284.500');
    });

    test('French uses a narrow no-break space and a comma', () {
      expect(MoneyFormat.format(1284500, Currency.tnd, 'fr'), '1 284,500');
    });

    test('always Western digits, even in Arabic', () {
      final s = MoneyFormat.format(9876543210, Currency.tnd, 'ar');
      expect(RegExp(r'^[0-9,.]+$').hasMatch(s), isTrue, reason: s);
    });

    test('small amounts and zero', () {
      expect(MoneyFormat.format(0, Currency.tnd, 'en'), '0.000');
      expect(MoneyFormat.format(5, Currency.tnd, 'en'), '0.005');
      expect(MoneyFormat.format(8500, Currency.tnd, 'en'), '8.500');
    });

    test('2-decimal currencies truncate the stored thousandths', () {
      expect(MoneyFormat.format(24500, Currency.eur, 'en'), '24.50');
      expect(MoneyFormat.format(1000000, Currency.usd, 'fr'), '1 000,00');
    });

    test('no floating-point drift on large values', () {
      expect(MoneyFormat.format(999999999999, Currency.tnd, 'en'), '999,999,999.999');
    });

    test('negative amounts keep their sign', () {
      expect(MoneyFormat.format(-12000, Currency.tnd, 'en'), '-12.000');
    });

    test('withSymbol follows the locale', () {
      expect(MoneyFormat.withSymbol(319600, Currency.tnd, 'ar'), '319.600 د.ت');
      expect(MoneyFormat.withSymbol(319600, Currency.tnd, 'en'), '319.600 TND');
      expect(MoneyFormat.withSymbol(319600, Currency.tnd, 'fr'), '319,600 TND');
    });
  });

  group('MoneyFormat.parseInput / toInput', () {
    test('parses keypad strings into thousandths', () {
      expect(MoneyFormat.parseInput(''), 0);
      expect(MoneyFormat.parseInput('0'), 0);
      expect(MoneyFormat.parseInput('24.5'), 24500);
      expect(MoneyFormat.parseInput('24.'), 24000);
      expect(MoneyFormat.parseInput('.5'), 500);
      expect(MoneyFormat.parseInput('0.001'), 1);
      expect(MoneyFormat.parseInput('96.400'), 96400);
    });

    test('round-trips for editing', () {
      expect(MoneyFormat.toInput(24500, Currency.tnd), '24.5');
      expect(MoneyFormat.toInput(12000, Currency.tnd), '12');
      expect(MoneyFormat.toInput(96400, Currency.tnd), '96.4');
      expect(MoneyFormat.toInput(1, Currency.tnd), '0.001');
      expect(MoneyFormat.parseInput(MoneyFormat.toInput(123456, Currency.tnd)), 123456);
    });
  });

  group('AmountInput.apply', () {
    String type(String keys, [Currency c = Currency.tnd]) {
      var s = '0';
      for (final k in keys.split(' ')) {
        s = AmountInput.apply(s, k, c);
      }
      return s;
    }

    test('replaces the leading zero', () => expect(type('2 4'), '24'));

    test('only one decimal point', () => expect(type('2 . . 5'), '2.5'));

    test('limits decimals to the currency', () {
      expect(type('1 . 2 3 4 5'), '1.234');
      expect(type('1 . 2 3 4', Currency.eur), '1.23');
    });

    test('backspace down to zero', () => expect(type('1 2 back back back'), '0'));

    test('caps the whole part', () => expect(type('1 2 3 4 5 6 7 8 9 1 2').length, AmountInput.maxWholeDigits));

    test('display uses the locale separators', () {
      expect(AmountInput.display('1234.5', 'en'), '1,234.5');
      expect(AmountInput.display('1234.5', 'fr'), '1 234,5');
      expect(AmountInput.display('24.', 'fr'), '24,');
    });
  });

  test('Currency.byCode falls back to TND', () {
    expect(Currency.byCode('EUR'), Currency.eur);
    expect(Currency.byCode('XXX'), Currency.tnd);
    expect(Currency.byCode(null), Currency.tnd);
  });
}
