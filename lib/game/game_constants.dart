/// Luật thời gian và điểm của một lượt chơi.
/// Sửa ở đây, không hardcode trong màn hình.
abstract final class GameConstants {
  /// Mỗi câu được bấy nhiêu giây. Hết giờ tự sang câu tiếp theo.
  static const questionSeconds = 10;

  /// Số câu mỗi lượt Toán. Không hardcode trong màn hình.
  static const mathQuestionCount = 10;

  /// Một lượt Tiếng Anh tìm lỗi. Hết giờ mới chấm.
  static const englishRoundSeconds = 45;

  /// Mẫu số điểm Tiếng Anh. Mỗi lỗi đúng là 5%.
  static const englishErrorCount = 20;

  /// Mỗi câu Logic. Hết giờ sang câu, không chờ nếu đã chọn.
  static const logicQuestionSeconds = 10;

  /// Điểm mỗi câu đúng. Chỉ cộng khi nộp bài, không cộng ngay lúc chọn.
  static const pointsPerCorrect = 100;
}
