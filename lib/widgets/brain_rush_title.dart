import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Logo Brain Rush: 2 dòng cong kiểu cầu vồng + viền sticker xanh đậm.
/// BRAIN trắng · RUSH vàng gradient.
class BrainRushTitle extends StatelessWidget {
  const BrainRushTitle({
    super.key,
    this.fontSize = 48,
    this.arcDegrees = 36,
    this.height = 140,
  });

  final double fontSize;
  final double arcDegrees;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _CurvedStickerPainter(
          fontSize: fontSize,
          arcDegrees: arcDegrees,
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
        ),
      ),
    );
  }
}

class _CurvedStickerPainter extends CustomPainter {
  _CurvedStickerPainter({
    required this.fontSize,
    required this.arcDegrees,
    this.fontFamily,
  });

  final double fontSize;
  final double arcDegrees;
  final String? fontFamily;

  static const _outline = Color(0xFF062A66);
  static const _brain = <String>['B', 'R', 'A', 'I', 'N'];
  static const _rush = <String>['R', 'U', 'S', 'H'];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final sweep = arcDegrees * math.pi / 180;

    // Dòng 1: BRAIN (trắng) — cung trên
    _paintWord(
      canvas: canvas,
      size: size,
      chars: _brain,
      fillColor: Colors.white,
      useYellowGradient: false,
      sweep: sweep,
      // Tâm thấp hơn → chữ cong lên
      centerYFactor: 0.42,
      horizontalShift: -fontSize * 0.08,
    );

    // Dòng 2: RUSH (vàng) — cung dưới, lệch phải, chồng nhẹ
    _paintWord(
      canvas: canvas,
      size: size,
      chars: _rush,
      fillColor: const Color(0xFFFFC107),
      useYellowGradient: true,
      sweep: sweep * 0.92,
      centerYFactor: 0.78,
      horizontalShift: fontSize * 0.14,
    );
  }

  void _paintWord({
    required Canvas canvas,
    required Size size,
    required List<String> chars,
    required Color fillColor,
    required bool useYellowGradient,
    required double sweep,
    required double centerYFactor,
    required double horizontalShift,
  }) {
    final gap = fontSize * 0.15;
    final widths = chars.map(_measure).toList();
    final totalWidth =
        widths.fold<double>(0, (a, b) => a + b) + gap * (chars.length - 1);

    final halfSweep = sweep / 2;
    final radiusFromWidth = (size.width * 0.42) / math.sin(halfSweep);
    final radiusFromChord = totalWidth / (2 * math.sin(halfSweep));
    final radius = math.min(radiusFromWidth, radiusFromChord);

    // Đỉnh cung nằm trong khung.
    final apexY = size.height * centerYFactor - fontSize * 0.15;
    final center = Offset(size.width / 2 + horizontalShift, apexY + radius);

    var angle = -math.pi / 2 - halfSweep;

    for (var i = 0; i < chars.length; i++) {
      final char = chars[i];
      final w = widths[i];
      final charAngle = (w + gap) / radius;
      final mid = angle + charAngle / 2;

      final pos = Offset(
        center.dx + radius * math.cos(mid),
        center.dy + radius * math.sin(mid),
      );

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(mid + math.pi / 2);

      final origin = Offset(-w / 2, -fontSize / 2);

      // Bóng sticker (dịch xuống một chút)
      for (final dy in [3.0, 5.0]) {
        _drawChar(
          canvas,
          char,
          origin.translate(0, dy),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = fontSize * 0.32
            ..strokeJoin = StrokeJoin.round
            ..color = _outline,
        );
      }

      // Viền chính
      _drawChar(
        canvas,
        char,
        origin,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = fontSize * 0.2
          ..strokeJoin = StrokeJoin.round
          ..color = _outline,
      );

      // Ruột
      if (useYellowGradient) {
        // Vẽ trắng rồi không — dùng fill vàng (gradient từng chữ khó; dùng vàng sáng).
        _drawChar(
          canvas,
          char,
          origin,
          Paint()
            ..style = PaintingStyle.fill
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Color(0xFFFFF59D),
                Color(0xFFFFC107),
                Color(0xFFFF9800),
              ],
            ).createShader(Rect.fromLTWH(origin.dx, origin.dy, w, fontSize)),
        );
      } else {
        _drawChar(
          canvas,
          char,
          origin,
          Paint()
            ..style = PaintingStyle.fill
            ..color = fillColor,
        );
      }

      canvas.restore();
      angle += charAngle;
    }
  }

  double _measure(String char) {
    final tp = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: fontFamily,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp.width;
  }

  void _drawChar(Canvas canvas, String char, Offset origin, Paint paint) {
    final tp = TextPainter(
      text: TextSpan(
        text: char,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: fontFamily,
          foreground: paint,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, origin);
  }

  @override
  bool shouldRepaint(covariant _CurvedStickerPainter oldDelegate) {
    return oldDelegate.fontSize != fontSize ||
        oldDelegate.arcDegrees != arcDegrees ||
        oldDelegate.fontFamily != fontFamily;
  }
}
