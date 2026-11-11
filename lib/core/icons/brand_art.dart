import 'package:flutter/widgets.dart';

import 'svg_path.dart';

/// Google "G" logo — never mirrored.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 22});

  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _GooglePainter());
}

class _GooglePainter extends CustomPainter {
  static final _parts = <(Color, Path)>[
    (
      const Color(0xFFEA4335),
      parseSvgPath(
        'M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z',
      ),
    ),
    (
      const Color(0xFF4285F4),
      parseSvgPath(
        'M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z',
      ),
    ),
    (
      const Color(0xFFFBBC05),
      parseSvgPath(
        'M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z',
      ),
    ),
    (
      const Color(0xFF34A853),
      parseSvgPath(
        'M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z',
      ),
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 48);
    for (final (color, path) in _parts) {
      canvas.drawPath(path, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Cashflow logo mark: two waves on an indigo tile (r32).
class CashflowLogo extends StatelessWidget {
  const CashflowLogo({super.key, this.size = 104, this.color = const Color(0xFF4263EB)});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cashflow',
      image: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * 32 / 104)),
        alignment: Alignment.center,
        child: CustomPaint(size: Size.square(size * 58 / 104), painter: _WavesPainter()),
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  static final _a = parseSvgPath('M8 22c7 0 9-9 17-9s10 9 17 9 7-4 8-6');
  static final _b = parseSvgPath('M8 38c7 0 9-9 17-9s10 9 17 9 7-4 8-6');

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 58);
    Paint p(double opacity) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFFFFF).withValues(alpha: opacity);
    canvas.drawPath(_a, p(1));
    canvas.drawPath(_b, p(0.6));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Empty-state illustration: a receipt with a "+" badge and two sparkles.
class EmptyReceiptArt extends StatelessWidget {
  const EmptyReceiptArt({
    super.key,
    required this.card,
    required this.muted,
    this.primary = const Color(0xFF4263EB),
    this.width = 176,
  });

  final Color card;
  final Color muted;
  final Color primary;
  final double width;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * 140 / 168),
      painter: _ReceiptPainter(card: card, muted: muted, primary: primary),
    );
  }
}

class _ReceiptPainter extends CustomPainter {
  _ReceiptPainter({required this.card, required this.muted, required this.primary});

  final Color card;
  final Color muted;
  final Color primary;

  static final _receipt = parseSvgPath('M58 28h52v84l-8.6-6-8.7 6-8.7-6-8.7 6-8.7-6-8.6 6V28Z');
  static final _lines = parseSvgPath('M70 50h28M70 64h28M70 78h16');
  static final _plus = parseSvgPath('M116 92.5v15M108.5 100h15');
  static final _sparkA = parseSvgPath('M36 40l2 5 5 2-5 2-2 5-2-5-5-2 5-2z');
  static final _sparkB = parseSvgPath('M134 30l1.5 3.5 3.5 1.5-3.5 1.5-1.5 3.5-1.5-3.5-3.5-1.5 3.5-1.5z');

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 168);
    canvas.drawCircle(const Offset(84, 72), 60, Paint()..color = primary.withValues(alpha: 0.13));
    canvas.drawPath(_receipt, Paint()..color = card);
    canvas.drawPath(
      _receipt,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round
        ..color = primary,
    );
    canvas.drawPath(
      _lines,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..color = muted.withValues(alpha: 0.55),
    );
    canvas.drawCircle(const Offset(116, 100), 17, Paint()..color = primary);
    canvas.drawPath(
      _plus,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFFFFFFF),
    );
    canvas.drawPath(_sparkA, Paint()..color = const Color(0xFF6EE7B7));
    canvas.drawPath(_sparkB, Paint()..color = const Color(0xFFC4B5FD));
  }

  @override
  bool shouldRepaint(_ReceiptPainter old) => old.card != card || old.muted != muted || old.primary != primary;
}
