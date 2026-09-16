/// Một lỗi đã định trước trong văn bản sai.
///
/// [start] inclusive, [end] exclusive, là chỉ số từ của [EnglishPassageSet.incorrectText].
class EnglishError {
  const EnglishError({
    required this.start,
    required this.end,
    required this.incorrect,
    required this.correct,
  });

  final int start;
  final int end;

  /// Đúng các từ sai, nối bằng một dấu cách.
  final String incorrect;

  /// Cụm thay thế trong văn bản đúng. Rỗng nếu lỗi là từ thừa.
  final String correct;
}

/// Một đoạn tìm lỗi: văn bản sai, văn bản đúng, và đúng 20 lỗi.
class EnglishPassageSet {
  const EnglishPassageSet({
    required this.incorrectText,
    required this.correctText,
    required this.errors,
  });

  final String incorrectText;
  final String correctText;
  final List<EnglishError> errors;

  static const errorCount = 20;
}
