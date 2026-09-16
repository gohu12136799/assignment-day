/// Một câu Logic: một ảnh đề và đúng 6 ảnh đáp án, theo thứ tự file.
class LogicQuestion {
  const LogicQuestion({required this.promptAsset, required this.answerAssets});

  final String promptAsset;
  final List<String> answerAssets;
}

const _logicAnswerCount = 6;

LogicQuestion _logicQuestion(int number) {
  final folder = 'assets/images/question_logic/Q$number';
  return LogicQuestion(
    promptAsset: '$folder/Q$number.png',
    answerAssets: [
      for (var i = 1; i <= _logicAnswerCount; i++) '$folder/answer/$i.png',
    ],
  );
}

/// Q1 rồi Q2 rồi Q3. Không xáo câu, không xáo ảnh.
final logicQuestions = <LogicQuestion>[
  _logicQuestion(1),
  _logicQuestion(2),
  _logicQuestion(3),
];
