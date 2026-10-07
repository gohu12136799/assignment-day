import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Logo Brain Rush: 2 dòng cong kiểu cầu vồng + viền sticker xanh đậm.
/// BRAIN trắng · RUSH vàng gradient.
class BrainRushTitle extends StatelessWidget {
  const BrainRushTitle({
    super.key,
    this.topLine = 'BRAIN',
    this.bottomLine = 'RUSH',
    this.fontSize = 48,
    this.bottomFontSize,
    this.arcDegrees = 36,
    this.height = 140,
  });

  /// Dòng trên, ví dụ BRAIN. Giữ nguyên mặc định để splash không đổi.
  final String topLine;

  /// Dòng dưới, ví dụ RUSH.
  final String bottomLine;
  final double fontSize;
  final double? bottomFontSize;
  final double arcDegrees;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _CurvedStickerPainter(
          topLine: topLine,
          bottomLine: bottomLine,
          fontSize: fontSize,
          bottomFontSize: bottomFontSize ?? fontSize,
          arcDegrees: arcDegrees,
          fontFamily: DefaultTextStyle.of(context).style.fontFamily,
        ),
      ),
    );
  }
}

class _CurvedStickerPainter extends CustomPainter {
  _CurvedStickerPainter({
    required this.topLine,
    required this.bottomLine,
    required this.fontSize,
    required this.bottomFontSize,
    required this.arcDegrees,
    this.fontFamily,
  });

  final String topLine;
  final String bottomLine;
  final double fontSize;
  final double bottomFontSize;
  final double arcDegrees;
  final String? fontFamily;

  static const _outline = Color(0xFF062A66);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final sweep = arcDegrees * math.pi / 180;

    // Dòng 1: BRAIN (trắng) — cung trên
    _paintWord(
      canvas: canvas,
      size: size,
      text: topLine,
      fontSize: fontSize,
      fillColor: Colors.white,
      useYellowGradient: false,
      sweep: sweep,
      // Tâm thấp hơn → chữ cong lên
      centerYFactor: 0.42,
      horizontalShift: -fontSize * 0.08,
    );

    // Dòng 2: vàng — cung dưới, lệch phải, chồng nhẹ
    _paintWord(
      canvas: canvas,
      size: size,
      text: bottomLine,
      fontSize: bottomFontSize,
      fillColor: const Color(0xFFFFC107),
      useYellowGradient: true,
      sweep: sweep * 0.92,
      centerYFactor: 0.78,
      horizontalShift: bottomFontSize * 0.14,
    );
  }

  void _paintWord({
    required Canvas canvas,
    required Size size,
    required String text,
    required double fontSize,
    required Color fillColor,
    required bool useYellowGradient,
    required double sweep,
    required double centerYFactor,
    required double horizontalShift,
  }) {
    final chars = text.characters.toList();
    if (chars.isEmpty) return;
    final gap = fontSize * 0.15;
    final widths = [
      for (final char in chars)
        _isGap(char) ? fontSize * 0.35 : _measure(char, fontSize),
    ];
    final totalWidth =
        widths.fold<double>(0, (a, b) => a + b) + gap * (chars.length - 1);

    final halfSweep = sweep / 2;
    final radiusFromWidth = (size.width * 0.42) / math.sin(halfSweep);
    final radiusFromChord = totalWidth / (2 * math.sin(halfSweep));
    final radius = math.min(radiusFromWidth, radiusFromChord);

    var letterSize = fontSize;
    var letterWidths = widths;
    var letterGap = gap;
    final arcLength = radius * sweep;
    if (totalWidth > arcLength * 0.98 && arcLength > 0) {
      final scale = arcLength * 0.98 / totalWidth;
      letterSize *= scale;
      letterGap *= scale;
      letterWidths = [for (final width in widths) width * scale];
    }

    // Đỉnh cung nằm trong khung.
    final apexY = size.height * centerYFactor - letterSize * 0.15;
    final center = Offset(size.width / 2 + horizontalShift, apexY + radius);

    var angle = -math.pi / 2 - halfSweep;

    for (var i = 0; i < chars.length; i++) {
      final char = chars[i];
      final w = letterWidths[i];
      final charAngle = (w + letterGap) / radius;
      final mid = angle + charAngle / 2;

      final pos = Offset(
        center.dx + radius * math.cos(mid),
        center.dy + radius * math.sin(mid),
      );

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(mid + math.pi / 2);

      final origin = Offset(-w / 2, -letterSize / 2);

      if (!_isGap(char)) {
        // Bóng sticker (dịch xuống một chút)
        for (final dy in [3.0, 5.0]) {
          _drawChar(
            canvas,
            char,
            origin.translate(0, dy),
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = letterSize * 0.32
              ..strokeJoin = StrokeJoin.round
              ..color = _outline,
            letterSize,
          );
        }

        // Viền chính
        _drawChar(
          canvas,
          char,
          origin,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = letterSize * 0.2
            ..strokeJoin = StrokeJoin.round
            ..color = _outline,
          letterSize,
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
              ..shader =
                  LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color(0xFFFFF59D),
                      Color(0xFFFFC107),
                      Color(0xFFFF9800),
                    ],
                  ).createShader(
                    Rect.fromLTWH(origin.dx, origin.dy, w, letterSize),
                  ),
            letterSize,
          );
        } else {
          _drawChar(
            canvas,
            char,
            origin,
            Paint()
              ..style = PaintingStyle.fill
              ..color = fillColor,
            letterSize,
          );
        }
      }

      canvas.restore();
      angle += charAngle;
    }
  }

  bool _isGap(String char) => char.trim().isEmpty;

  double _measure(String char, double fontSize) {
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

  void _drawChar(
    Canvas canvas,
    String char,
    Offset origin,
    Paint paint,
    double fontSize,
  ) {
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
        oldDelegate.bottomFontSize != bottomFontSize ||
        oldDelegate.topLine != topLine ||
        oldDelegate.bottomLine != bottomLine ||
        oldDelegate.arcDegrees != arcDegrees ||
        oldDelegate.fontFamily != fontFamily;
  }
}
