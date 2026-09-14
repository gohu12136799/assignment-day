enum QuestionType { math, logic, english }

class Question {
  const Question({
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });

  final QuestionType type;
  final String prompt;
  final List<String> options;
  /// Index đáp án đúng trong [options] (0, 1, 2, hoặc 3).
  final int correctIndex;

  String get typeLabel => switch (type) {
        QuestionType.math => 'Toán',
        QuestionType.logic => 'Logic',
        QuestionType.english => 'Tiếng Anh',
      };
}
