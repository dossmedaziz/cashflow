import 'package:flutter/widgets.dart';

import 'svg_path.dart';

/// How an icon behaves when the layout direction changes.
enum IconMirror {
  /// Digits, objects, the keypad… never mirror.
  none,

  /// Path is drawn in its RTL form; flip it for LTR (back, forward).
  inLtr,

  /// Path is drawn in its LTR form; flip it for RTL (log out).
  inRtl,
}

/// Icon path data from the design: 24 px grid, 1.8 px stroke, round caps
/// and joins, no fills.
abstract final class AppIcons {
  // Default category icons.
  static const food = 'M3 11h18a9 9 0 0 1-18 0ZM8 7.5c0-1.5 1-2 1-3.5M12 7.5c0-1.5 1-2 1-3.5M16 7.5c0-1.5 1-2 1-3.5';
  static const transport = 'M7 3h10a3 3 0 0 1 3 3v12H4V6a3 3 0 0 1 3-3ZM4 11h16M7 18v3M17 18v3M8 14.5h.01M16 14.5h.01';
  static const shopping = 'M5 8h14l-1.2 12H6.2L5 8ZM9 8V6.5a3 3 0 0 1 6 0V8';
  static const bills = 'M6 3h12v18l-3-2-3 2-3-2-3 2V3ZM9 8h6M9 12h6M9 16h3';
  static const health =
      'M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0 1 12 7a4.3 4.3 0 0 1 7.5 2.8C19.5 15.4 12 20 12 20ZM8 12h2l1-2 2 4 1-2h2';
  static const other = 'M4 4h6v6H4zM14 4h6v6h-6zM4 14h6v6H4zM14 14h6v6h-6z';

  // Picker icons.
  static const dumbbell = 'M6 7v10M3 9v6M18 7v10M21 9v6M6 12h12';
  static const coffee = 'M5 9h11v5a5 5 0 0 1-5 5H10a5 5 0 0 1-5-5V9ZM16 10h2a2 2 0 0 1 0 4h-2M8 3v3M12 3v3';
  static const book = 'M4 5a2 2 0 0 1 2-2h13v16H6a2 2 0 0 0-2 2V5ZM4 19a2 2 0 0 1 2-2h13';
  static const gift = 'M4 10h16v4H4zM6 14h12v7H6zM12 10v11M12 10c-2-4-6-4-6-1s6 1 6 1Zm0 0c2-4 6-4 6-1s-6 1-6 1Z';
  static const home = 'M4 11l8-7 8 7v9H4v-9ZM10 20v-5h4v5';
  static const plane = 'M3 13l18-8-6 16-3-7-9-1Z';
  static const music = 'M9 18V5l11-2v13M9 18a3 3 0 1 1-6 0a3 3 0 1 1 6 0ZM20 16a3 3 0 1 1-6 0a3 3 0 1 1 6 0Z';
  static const phone = 'M8 3h8a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1H8a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1ZM11 18h2';
  static const grad = 'M2 9l10-5 10 5-10 5L2 9ZM6 11v5c3 2 9 2 12 0v-5';
  static const heart = 'M12 20s-7.5-4.6-7.5-10.2A4.3 4.3 0 0 1 12 7a4.3 4.3 0 0 1 7.5 2.8C19.5 15.4 12 20 12 20Z';
  static const bag = shopping;
  static const star = 'M12 3l2.6 5.6 6.1.7-4.5 4.2 1.2 6L12 16.6 6.6 19.5l1.2-6L3.3 9.3l6.1-.7L12 3Z';

  // UI icons.
  static const add = 'M12 5v14M5 12h14';
  static const close = 'M6 6l12 12M18 6L6 18';
  static const back = 'M9 6l6 6-6 6'; // RTL form
  static const forward = 'M15 6l-6 6 6 6'; // RTL form
  static const delete = 'M4 7h16M10 11v6M14 11v6M6 7l1 13h10l1-13M9 7V4h6v3';
  static const note = 'M4 20h4L19 9l-4-4L4 16v4ZM13.5 6.5l4 4';
  static const date = 'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4';
  static const backspace = 'M9 5h11v14H9l-6-7 6-7ZM12 9l6 6M18 9l-6 6';
  static const logout = 'M15 4h4v16h-4M10 8l-4 4 4 4M6 12h10'; // LTR form
  static const less = 'M12 5v14M6 13l6 6 6-6';
  static const more = 'M12 19V5M6 11l6-6 6 6';
  static const check = 'M5 12l5 5 9-10';
  static const grip = 'M9 6h.01M15 6h.01M9 12h.01M15 12h.01M9 18h.01M15 18h.01';
  static const moon = 'M20 14.5A8 8 0 0 1 9.5 4 8 8 0 1 0 20 14.5Z';
  static const sun =
      'M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8ZM12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4';
  static const coin =
      'M12 3a9 9 0 1 0 0 18a9 9 0 1 0 0-18ZM9 9.5c0-1.4 1.3-2.2 3-2.2s3 .8 3 2.2-1.3 2-3 2.5-3 1.1-3 2.5 1.3 2.2 3 2.2 3-.8 3-2.2M12 5.8v1.5M12 16.7v1.5';
  static const refresh = 'M20 12a8 8 0 1 1-2.3-5.6M20 4v4h-4';
  static const wifiOff = 'M3 3l18 18M8.5 16.5a5 5 0 0 1 7 0M5 13a10 10 0 0 1 5.2-2.8M19 13a10 10 0 0 0-2.6-1.8M12 20h.01';

  /// Category icon catalog: icon key → path. Keys are stored in the database.
  static const categoryIcons = <String, String>{
    'food': food,
    'transport': transport,
    'shopping': shopping,
    'bills': bills,
    'health': health,
    'other': other,
    'dumbbell': dumbbell,
    'coffee': coffee,
    'book': book,
    'gift': gift,
    'home': home,
    'plane': plane,
    'music': music,
    'phone': phone,
    'grad': grad,
    'heart': heart,
    'bag': bag,
    'star': star,
  };

  /// The 12 icons offered by the category icon picker, in design order.
  static const pickerKeys = <String>[
    'dumbbell', 'coffee', 'book', 'gift', 'home', 'plane', //
    'music', 'phone', 'grad', 'heart', 'bag', 'star',
  ];

  static String forKey(String key) => categoryIcons[key] ?? other;
}

final Map<String, Path> _pathCache = {};

Path _cachedPath(String data) => _pathCache.putIfAbsent(data, () => parseSvgPath(data));

/// Renders an [AppIcons] path as a stroked line icon.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.data, {
    super.key,
    this.size = 20,
    this.color,
    this.strokeWidth = 1.8,
    this.mirror = IconMirror.none,
    this.semanticLabel,
  });

  final String data;
  final double size;
  final Color? color;

  /// Stroke width in the 24-px design grid; scaled with [size].
  final double strokeWidth;
  final IconMirror mirror;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFFFFFFFF);
    final dir = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final flip = switch (mirror) {
      IconMirror.none => false,
      IconMirror.inLtr => dir == TextDirection.ltr,
      IconMirror.inRtl => dir == TextDirection.rtl,
    };
    Widget icon = CustomPaint(
      size: Size.square(size),
      painter: _StrokePainter(_cachedPath(data), color, strokeWidth),
    );
    if (flip) {
      icon = Transform.flip(flipX: true, child: icon);
    }
    return Semantics(
      label: semanticLabel,
      excludeSemantics: semanticLabel == null,
      child: SizedBox.square(dimension: size, child: icon),
    );
  }
}

class _StrokePainter extends CustomPainter {
  _StrokePainter(this.path, this.color, this.strokeWidth);

  final Path path;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 24;
    canvas.scale(scale);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_StrokePainter old) =>
      old.path != path || old.color != color || old.strokeWidth != strokeWidth;
}
