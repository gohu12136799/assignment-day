import 'package:flutter/material.dart';

/// Màu dùng chung toàn app.
/// Học: gom hex vào 1 chỗ → đổi theme dễ, tránh copy Color(0xFF...) khắp nơi.
abstract final class AppColors {
  // --- Brand / nền ---
  static const bgBlue = Color(0xFF0B3D91);
  static const bgBlueLight = Color(0xFF0D6EFE);
  static const bgBlueDeep = Color(0xFF072E6E);
  static const yellow = Color(0xFFFFC107);
  static const cardBg = Color(0xFF0A2F70);
  static const borderGray = Color(0xFFBEBEBE);
  static const bgLight = Color.fromARGB(255, 245, 249, 249);

  // --- Gradient toả từ giữa: đậm tâm → nhạt ra ngoài ---
  static const yellowGradient = <Color>[Color(0xFFFF9800), Color(0xFFFFEB3B)];

  static const greenGradient = <Color>[Color(0xFF1B5E20), Color(0xFF66BB6A)];

  static const blueGradient = <Color>[Color(0xFF0D47A1), Color(0xFF42A5F5)];

  static const purpleGradient = <Color>[Color(0xFF4A148C), Color(0xFFBA68C8)];

  // --- Gradient icon (Topic select) ---
  static const redIconGradient = <Color>[Color(0xFFE53935), Color(0xFFFF8A80)];

  static const yellowIconGradient = <Color>[
    Color(0xFFF9A825),
    Color(0xFFFFEE58),
  ];

  static const blueIconGradient = <Color>[Color(0xFF1565C0), Color(0xFF64B5F6)];

  static const purpleIconGradient = <Color>[
    Color(0xFF6A1B9A),
    Color(0xFFCE93D8),
  ];

  static const greenIconGradient = <Color>[
    Color(0xFF2E7D32),
    Color(0xFF81C784),
  ];
}
