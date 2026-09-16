import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Hàng menu dùng chung:
/// - Home: truyền [gradient] + [foreground] (nền gradient, 1 dòng chữ)
/// - Topic: truyền [description] + [iconGradient] (card trắng, icon tô gradient)
class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.description,
    this.gradient,
    this.iconGradient,
    this.foreground = Colors.black,
    this.height,
  });

  final IconData icon;
  final String label;
  final String? description;
  final VoidCallback onTap;

  /// Nền gradient (Home). null = card trắng có viền (Topic).
  final List<Color>? gradient;

  /// Icon tô gradient (Topic). null = icon màu [foreground].
  final List<Color>? iconGradient;

  final Color foreground;

  /// Chiều cao cố định của hàng. null = theo nội dung.
  final double? height;

  bool get _isCardStyle => gradient == null;

  double get _iconSize => _isCardStyle ? 36 * 1.5 : 28 * 1.7;

  @override
  Widget build(BuildContext context) {
    final chevronColor = _isCardStyle
        ? Colors.black54
        : foreground.withValues(alpha: 0.7);

    final radius = BorderRadius.circular(20);

    // Shadow để ngoài Material để không bị clip + màu có alpha cho mềm.
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(2, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Ink(
            height: height,
            decoration: BoxDecoration(
              color: _isCardStyle ? Colors.white : null,
              borderRadius: radius,
              border: _isCardStyle
                  ? Border.all(color: AppColors.borderGray, width: 1)
                  : null,
              gradient: gradient == null
                  ? null
                  : LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: gradient!,
                    ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _isCardStyle ? 14 : 16,
                vertical: height == null ? (_isCardStyle ? 14 : 16) : 0,
              ),
              child: Row(
                children: [
                  _buildIcon(),
                  const SizedBox(width: 14),
                  Expanded(child: _buildTexts()),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: chevronColor,
                    size: _isCardStyle ? 28 : 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final iconWidget = Icon(
      icon,
      size: _iconSize,
      color: iconGradient == null ? foreground : Colors.white,
    );

    if (iconGradient == null) return iconWidget;

    // Học: ShaderMask tô gradient lên icon (icon gốc màu trắng).
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: iconGradient!,
        ).createShader(bounds);
      },
      child: iconWidget,
    );
  }

  Widget _buildTexts() {
    final title = Text(
      label,
      style: TextStyle(
        color: _isCardStyle ? Colors.black : foreground,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );

    if (description == null) return title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        const SizedBox(height: 2),
        Text(
          description!,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }
}
