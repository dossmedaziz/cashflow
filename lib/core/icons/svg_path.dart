import 'dart:ui';

/// Minimal SVG path-data parser (M L H V C S A Z, absolute and relative,
/// implicit repeats). Enough for the design's 24-px line icons.
Path parseSvgPath(String data) {
  final tokens = _tokenize(data);
  final path = Path();
  var i = 0;
  var cmd = '';
  var cx = 0.0, cy = 0.0; // current point
  var sx = 0.0, sy = 0.0; // subpath start
  double? lastCtrlX, lastCtrlY; // last cubic control point (for S)

  bool isCmd(String t) => t.length == 1 && 'MmLlHhVvCcSsAaZz'.contains(t);
  double n() => double.parse(tokens[i++]);
  bool flag() {
    final t = tokens[i];
    // Flags may be packed: "0 01" → "0", "0", "1".
    if (t.length > 1 && (t[0] == '0' || t[0] == '1') && !t.contains('.')) {
      tokens[i] = t.substring(1);
      return t[0] == '1';
    }
    i++;
    return t == '1';
  }

  while (i < tokens.length) {
    if (isCmd(tokens[i])) {
      cmd = tokens[i++];
    } else if (cmd.isEmpty) {
      throw FormatException('Path must start with a command', data);
    }
    final rel = cmd.toLowerCase() == cmd;
    switch (cmd.toUpperCase()) {
      case 'M':
        var x = n(), y = n();
        if (rel) {
          x += cx;
          y += cy;
        }
        path.moveTo(x, y);
        cx = sx = x;
        cy = sy = y;
        lastCtrlX = null;
        // Subsequent pairs are implicit line-tos.
        cmd = rel ? 'l' : 'L';
      case 'L':
        var x = n(), y = n();
        if (rel) {
          x += cx;
          y += cy;
        }
        path.lineTo(x, y);
        cx = x;
        cy = y;
        lastCtrlX = null;
      case 'H':
        var x = n();
        if (rel) x += cx;
        path.lineTo(x, cy);
        cx = x;
        lastCtrlX = null;
      case 'V':
        var y = n();
        if (rel) y += cy;
        path.lineTo(cx, y);
        cy = y;
        lastCtrlX = null;
      case 'C':
        var x1 = n(), y1 = n(), x2 = n(), y2 = n(), x = n(), y = n();
        if (rel) {
          x1 += cx;
          y1 += cy;
          x2 += cx;
          y2 += cy;
          x += cx;
          y += cy;
        }
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastCtrlX = x2;
        lastCtrlY = y2;
        cx = x;
        cy = y;
      case 'S':
        var x2 = n(), y2 = n(), x = n(), y = n();
        if (rel) {
          x2 += cx;
          y2 += cy;
          x += cx;
          y += cy;
        }
        final x1 = lastCtrlX == null ? cx : 2 * cx - lastCtrlX;
        final y1 = lastCtrlY == null || lastCtrlX == null ? cy : 2 * cy - lastCtrlY;
        path.cubicTo(x1, y1, x2, y2, x, y);
        lastCtrlX = x2;
        lastCtrlY = y2;
        cx = x;
        cy = y;
      case 'A':
        final rx = n(), ry = n(), rot = n();
        final large = flag(), sweep = flag();
        var x = n(), y = n();
        if (rel) {
          x += cx;
          y += cy;
        }
        path.arcToPoint(
          Offset(x, y),
          radius: Radius.elliptical(rx, ry),
          rotation: rot,
          largeArc: large,
          clockwise: sweep,
        );
        cx = x;
        cy = y;
        lastCtrlX = null;
      case 'Z':
        path.close();
        cx = sx;
        cy = sy;
        lastCtrlX = null;
        cmd = '';
    }
  }
  return path;
}

List<String> _tokenize(String d) {
  final out = <String>[];
  final re = RegExp(r'[MmLlHhVvCcSsAaZz]|-?(?:\d+\.?\d*|\.\d+)(?:[eE][-+]?\d+)?');
  for (final m in re.allMatches(d)) {
    out.add(m.group(0)!);
  }
  return out;
}
