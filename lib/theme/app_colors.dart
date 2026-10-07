import 'dart:math';

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
  static const answerBlue = Color(0xFF1976D2);
  static const answerGreen = Color(0xFF43A047);
  static const answerYellow = Color(0xFFFDD835);
  static const answerPurple = Color(0xFF8E24AA);
  static const answerColors = <Color>[
    answerBlue,
    answerGreen,
    answerYellow,
    answerPurple,
  ];
  static const bgLight = Color.fromARGB(255, 245, 249, 249);

  /// Nền kem của ảnh cô giáo chính diện, để ảnh liền với màn.
  static const schoolCream = Color(0xFFFCF1D5);

  /// Bảng xanh viết phấn, khung gỗ.
  static const chalkboard = Color(0xFF1E7A46);
  static const chalkFrame = Color(0xFF8D5A2B);

  /// Tường lớp mầm non khi làm bài. Nhạt để thẻ trắng và chữ đen còn nổi.
  static const classroomBlue = Color(0xFF9FD6FF);
  static const classroomYellow = Color(0xFFFFF09A);
  static const classroomPink = Color(0xFFFFC2DD);
  static const classroomWalls = <Color>[
    classroomBlue,
    classroomYellow,
    classroomPink,
  ];

  /// Một màu tường, chọn lúc mở bài. Không gọi trong build kẻo nền nhảy.
  static Color randomClassroomWall([Random? random]) {
    final roll = random ?? Random();
    return classroomWalls[roll.nextInt(classroomWalls.length)];
  }

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

  /// 10 gradient đáp án Toán. Ghép từ màu đã có, không thêm hex mới.
  static const mathAnswerGradients = <List<Color>>[
    redIconGradient,
    yellowGradient,
    greenGradient,
    blueGradient,
    purpleGradient,
    yellowIconGradient,
    blueIconGradient,
    purpleIconGradient,
    greenIconGradient,
    [bgBlueDeep, bgBlueLight],
  ];

  /// Vàng sáng cần chữ đậm. Còn lại chữ trắng.
  static const mathAnswerDarkText = <bool>[
    false,
    true,
    false,
    false,
    false,
    true,
    false,
    false,
    false,
    false,
  ];
}
