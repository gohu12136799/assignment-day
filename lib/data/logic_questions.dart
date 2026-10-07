/// Một câu Logic: một ảnh đề và đúng 6 ảnh đáp án, theo thứ tự file.
class LogicQuestion {
  const LogicQuestion({
    required this.promptAsset,
    required this.answerAssets,
    required this.correctIndex,
  });

  final String promptAsset;
  final List<String> answerAssets;

  /// Chỉ số ảnh đáp án đúng, 0–5 (ảnh `answer/1.png` là 0).
  final int correctIndex;
}

const _logicAnswerCount = 6;

LogicQuestion _logicQuestion(int number, {required int correctIndex}) {
  final folder = 'assets/images/question_logic/Q$number';
  return LogicQuestion(
    promptAsset: '$folder/Q$number.png',
    answerAssets: [
      for (var i = 1; i <= _logicAnswerCount; i++) '$folder/answer/$i.png',
    ],
    correctIndex: correctIndex,
  );
}

/// Q1 rồi Q2 rồi Q3. Không xáo câu, không xáo ảnh.
// TODO: correctIndex là đáp án tạm, chưa khớp với ảnh. Sửa theo đáp án thật.
final logicQuestions = <LogicQuestion>[
  _logicQuestion(1, correctIndex: 0),
  _logicQuestion(2, correctIndex: 0),
  _logicQuestion(3, correctIndex: 0),
];
