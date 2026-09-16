import '../data/questions.dart';
import '../models/play_topic.dart';
import '../models/question.dart';
import 'game_constants.dart';
import 'math_question_generator.dart';

enum RoundEnd { cleared }

/// Một lượt làm bài. Chọn đáp án thì sang câu ngay.
/// Không chọn thì hết [GameConstants.questionSeconds] cũng sang câu.
/// Chưa chấm điểm cho đến khi câu cuối xong.
class GameSession {
  GameSession({
    required PlayTopic topic,
    List<Question>? bank,
    MathQuestionGenerator? mathGenerator,
  }) {
    if (topic == PlayTopic.math) {
      _questions = (mathGenerator ?? MathQuestionGenerator()).generate();
    } else if (topic == PlayTopic.english) {
      throw StateError('English is a find-the-error round, not a quiz');
    } else if (topic == PlayTopic.logic) {
      throw StateError('Logic is an image puzzle, not a quiz');
    } else {
      final source = List<Question>.from(bank ?? sampleQuestions);
      _questions = _filter(topic, source)..shuffle();
      if (_questions.isEmpty) {
        _questions = List<Question>.from(source)..shuffle();
      }
    }
    secondsLeft = GameConstants.questionSeconds;
  }

  final List<int?> _answers = [];
  final List<bool> _timeouts = [];
  late final List<Question> _questions;

  int index = 0;
  int secondsLeft = GameConstants.questionSeconds;
  bool paused = false;
  RoundEnd? roundEnd;

  List<Question> get questions => _questions;
  Question get current => _questions[index];
  bool get isFinished => roundEnd != null;

  int? get selectedIndex => index < _answers.length ? _answers[index] : null;

  int get answeredCount => _answers.whereType<int>().length;

  int get correctCount => _countWhere((i) => _isCorrect(i));

  int get wrongCount =>
      _countWhere((i) => _selected(i) != null && !_isCorrect(i));

  int get timeoutCount =>
      _countWhere((i) => i < _timeouts.length && _timeouts[i]);

  double get progress =>
      _questions.isEmpty ? 0 : (index + 1) / _questions.length;

  /// Ghi lựa chọn rồi sang câu ngay. Không cộng điểm.
  /// Trả về true khi câu cuối vừa được chọn và bài đã kết thúc.
  bool select(int optionIndex) {
    if (paused || isFinished) return false;
    if (optionIndex < 0 || optionIndex >= current.options.length) return false;
    _ensureSlot(index);
    _answers[index] = optionIndex;
    _timeouts[index] = false;
    return _advance();
  }

  void togglePause() {
    if (isFinished) return;
    paused = !paused;
  }

  /// Giảm đồng hồ câu hiện tại.
  /// Trả về true khi câu cuối vừa hết giờ và bài đã kết thúc.
  bool tick() {
    if (paused || isFinished || _questions.isEmpty) return false;
    if (secondsLeft > 1) {
      secondsLeft -= 1;
      return false;
    }
    _ensureSlot(index);
    if (_answers[index] == null) _timeouts[index] = true;
    return _advance();
  }

  bool _advance() {
    if (index >= _questions.length - 1) {
      roundEnd = RoundEnd.cleared;
      return true;
    }
    index += 1;
    secondsLeft = GameConstants.questionSeconds;
    return false;
  }

  /// Chỉ gọi sau khi [roundEnd] đã có. Câu không chọn tính 0 điểm.
  int grade() {
    if (roundEnd == null) {
      throw StateError('grade() only after the exam ends');
    }
    var score = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (i >= _answers.length) continue;
      final selected = _answers[i];
      if (selected != null && selected == _questions[i].correctIndex) {
        score += GameConstants.pointsPerCorrect;
      }
    }
    return score;
  }

  void _ensureSlot(int i) {
    while (_answers.length <= i) {
      _answers.add(null);
    }
    while (_timeouts.length <= i) {
      _timeouts.add(false);
    }
  }

  int? _selected(int i) => i < _answers.length ? _answers[i] : null;

  bool _isCorrect(int i) {
    final selected = _selected(i);
    if (selected == null || i >= _questions.length) return false;
    if (i < _timeouts.length && _timeouts[i]) return false;
    return selected == _questions[i].correctIndex;
  }

  int _countWhere(bool Function(int index) test) {
    var count = 0;
    for (var i = 0; i < _questions.length; i++) {
      if (test(i)) count += 1;
    }
    return count;
  }

  static List<Question> _filter(PlayTopic topic, List<Question> all) {
    switch (topic) {
      case PlayTopic.math:
        throw StateError('Math questions are generated, not filtered');
      case PlayTopic.logic:
        throw StateError('Logic puzzles are not filtered');
      case PlayTopic.english:
        throw StateError('English passages are not filtered');
      case PlayTopic.mixed:
      case PlayTopic.random:
        return all;
    }
  }
}
