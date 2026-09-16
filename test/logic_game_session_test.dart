import 'package:assignment_day/data/logic_questions.dart';
import 'package:assignment_day/game/game_constants.dart';
import 'package:assignment_day/game/logic_game_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plays Q1 then Q2 then Q3 with six answers each', () {
    expect(logicQuestions, hasLength(3));
    expect(logicQuestions[0].promptAsset, endsWith('Q1/Q1.png'));
    expect(logicQuestions[1].promptAsset, endsWith('Q2/Q2.png'));
    expect(logicQuestions[2].promptAsset, endsWith('Q3/Q3.png'));
    for (final question in logicQuestions) {
      expect(question.answerAssets, hasLength(6));
    }

    final session = LogicGameSession();
    expect(session.secondsLeft, GameConstants.logicQuestionSeconds);
    expect(session.current.promptAsset, logicQuestions[0].promptAsset);

    expect(session.select(1), isFalse);
    expect(session.index, 1);
    expect(session.secondsLeft, GameConstants.logicQuestionSeconds);
    expect(session.current.promptAsset, logicQuestions[1].promptAsset);

    for (var i = 0; i < GameConstants.logicQuestionSeconds; i++) {
      expect(session.tick(), isFalse);
    }
    expect(session.index, 2);
    expect(session.select(4), isTrue);
    expect(session.choices(), [1, null, 4]);
    expect(session.answeredCount, 2);
    session.select(0);
    expect(session.choices(), [1, null, 4]);
  });

  test('pause freezes the clock and ignores taps', () {
    final session = LogicGameSession();
    session.togglePause();
    expect(session.tick(), isFalse);
    expect(session.secondsLeft, GameConstants.logicQuestionSeconds);
    expect(session.select(0), isFalse);
    expect(session.index, 0);
  });
}
