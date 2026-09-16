import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 10 đáp án Toán, hình tròn, mỗi cái một gradient, rải ngẫu nhiên.
/// Vị trí chọn một lần khi câu được tạo, không xáo lại khi timer rebuild.
class MathAnswerScatter extends StatefulWidget {
  const MathAnswerScatter({
    super.key,
    required this.options,
    required this.enabled,
    required this.onSelect,
  });

  final List<String> options;
  final bool enabled;
  final ValueChanged<int> onSelect;

  @override
  State<MathAnswerScatter> createState() => _MathAnswerScatterState();
}

class _MathAnswerScatterState extends State<MathAnswerScatter> {
  static const _diameter = 64.0;

  final _random = Random();
  List<Offset>? _centers;
  Size? _area;

  List<Offset> _centersFor(Size area) {
    if (_centers != null && _area == area) return _centers!;
    _area = area;
    _centers = _place(area);
    return _centers!;
  }

  List<Offset> _place(Size area) {
    const radius = _diameter / 2;
    if (area.width <= _diameter || area.height <= _diameter) {
      return _spread(area, radius);
    }

    var gap = 8.0;
    for (var round = 0; round < 6; round++) {
      final placed = <Offset>[];
      final minDist = _diameter + gap;
      for (var i = 0; i < widget.options.length; i++) {
        Offset? spot;
        for (var attempt = 0; attempt < 60; attempt++) {
          final point = Offset(
            radius + _random.nextDouble() * (area.width - _diameter),
            radius + _random.nextDouble() * (area.height - _diameter),
          );
          final blocked = placed.any(
            (other) => (other - point).distance < minDist,
          );
          if (!blocked) {
            spot = point;
            break;
          }
        }
        if (spot == null) break;
        placed.add(spot);
      }
      if (placed.length == widget.options.length) return placed;
      gap -= 4;
    }

    return _spread(area, radius);
  }

  /// Không chồng tâm. Không xếp thành một hàng hay một cột thẳng.
  List<Offset> _spread(Size area, double radius) {
    final count = widget.options.length;
    final center = Offset(area.width / 2, area.height / 2);
    final reachX = max(0.0, area.width / 2 - radius);
    final reachY = max(0.0, area.height / 2 - radius);
    return [
      for (var i = 0; i < count; i++)
        Offset(
          (center.dx +
                  cos((i / count) * pi * 2) *
                      reachX *
                      (i.isEven ? 0.55 : 0.95))
              .clamp(radius, max(radius, area.width - radius)),
          (center.dy +
                  sin((i / count) * pi * 2) *
                      reachY *
                      (i.isEven ? 0.95 : 0.55))
              .clamp(radius, max(radius, area.height - radius)),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final area = Size(constraints.maxWidth, constraints.maxHeight);
        final centers = _centersFor(area);
        return Stack(
          children: [
            for (var i = 0; i < widget.options.length; i++)
              Positioned(
                left: centers[i].dx - _diameter / 2,
                top: centers[i].dy - _diameter / 2,
                child: _AnswerCircle(
                  label: widget.options[i],
                  gradient: AppColors.mathAnswerGradients[
                      i % AppColors.mathAnswerGradients.length],
                  darkText: AppColors.mathAnswerDarkText[
                      i % AppColors.mathAnswerDarkText.length],
                  enabled: widget.enabled,
                  onTap: () => widget.onSelect(i),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AnswerCircle extends StatelessWidget {
  const _AnswerCircle({
    required this.label,
    required this.gradient,
    required this.darkText,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final List<Color> gradient;
  final bool darkText;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: Ink(
          width: _MathAnswerScatterState._diameter,
          height: _MathAnswerScatterState._diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkText ? AppColors.bgBlueDeep : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
