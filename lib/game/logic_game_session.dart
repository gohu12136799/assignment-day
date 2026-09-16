import '../data/logic_questions.dart';
import 'game_constants.dart';
import 'game_session.dart';

/// Kết quả một lượt Logic. Chưa có công thức điểm.
class LogicRoundResult {
  const LogicRoundResult({
    required this.answered,
    required this.total,
    required this.choices,
  });

  final int answered;
  final int total;

  /// Chỉ số ảnh đáp án, 0–5. Null là không trả lời.
  final List<int?> choices;
}

/// Q1 → Q2 → Q3. Chọn thì sang câu ngay. Hết 10 giây cũng sang.
class LogicGameSession {
  LogicGameSession({List<LogicQuestion>? questions})
    : questions = List<LogicQuestion>.from(questions ?? logicQuestions) {
    if (this.questions.isEmpty) {
      throw StateError('No Logic questions');
    }
    for (final question in this.questions) {
      if (question.answerAssets.length != 6) {
        throw StateError('Logic question needs 6 answers');
      }
    }
    secondsLeft = GameConstants.logicQuestionSeconds;
  }

  final List<LogicQuestion> questions;
  final List<int?> _answers = [];
  final List<bool> _timeouts = [];

  int index = 0;
  int secondsLeft = GameConstants.logicQuestionSeconds;
  bool paused = false;
  RoundEnd? roundEnd;

  LogicQuestion get current => questions[index];
  bool get isFinished => roundEnd != null;
  int? get selectedIndex => index < _answers.length ? _answers[index] : null;

  int get answeredCount => _answers.whereType<int>().length;

  double get progress => (index + 1) / questions.length;

  /// Ghi lựa chọn rồi sang câu ngay. Không báo đúng sai.
  bool select(int optionIndex) {
    if (paused || isFinished) return false;
    if (optionIndex < 0 || optionIndex >= current.answerAssets.length) {
      return false;
    }
    _ensureSlot(index);
    _answers[index] = optionIndex;
    _timeouts[index] = false;
    return _advance();
  }

  void togglePause() {
    if (isFinished) return;
    paused = !paused;
  }

  /// Hết giờ mà chưa chọn thì ghi không trả lời rồi sang câu.
  bool tick() {
    if (paused || isFinished) return false;
    if (secondsLeft > 1) {
      secondsLeft -= 1;
      return false;
    }
    _ensureSlot(index);
    if (_answers[index] == null) _timeouts[index] = true;
    secondsLeft = 0;
    return _advance();
  }

  /// Chỉ gọi sau khi lượt kết thúc.
  List<int?> choices() {
    if (roundEnd == null) {
      throw StateError('choices() only after the round ends');
    }
    return [
      for (var i = 0; i < questions.length; i++)
        i < _answers.length ? _answers[i] : null,
    ];
  }

  bool _advance() {
    if (index >= questions.length - 1) {
      roundEnd = RoundEnd.cleared;
      return true;
    }
    index += 1;
    secondsLeft = GameConstants.logicQuestionSeconds;
    return false;
  }

  void _ensureSlot(int i) {
    while (_answers.length <= i) {
      _answers.add(null);
    }
    while (_timeouts.length <= i) {
      _timeouts.add(false);
    }
  }
}
