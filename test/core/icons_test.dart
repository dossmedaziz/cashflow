import 'package:cashflow/core/icons/app_icons.dart';
import 'package:cashflow/core/icons/svg_path.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every category icon path parses and stays inside the 24-px grid', () {
    for (final entry in AppIcons.categoryIcons.entries) {
      final bounds = parseSvgPath(entry.value).getBounds();
      expect(bounds.isEmpty, isFalse, reason: entry.key);
      expect(bounds.left >= -0.5 && bounds.top >= -0.5, isTrue, reason: '${entry.key} $bounds');
      expect(bounds.right <= 24.5 && bounds.bottom <= 24.5, isTrue, reason: '${entry.key} $bounds');
    }
  });

  test('parses relative arcs, smooth curves and implicit line-tos', () {
    final p = parseSvgPath('M3 13l18-8-6 16-3-7-9-1Z');
    expect(p.getBounds().width, closeTo(18, 0.01));
    final heart = parseSvgPath(AppIcons.heart).getBounds();
    expect(heart.width, greaterThan(14));
  });
}
