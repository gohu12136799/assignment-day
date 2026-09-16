import 'package:assignment_day/data/english_questions.dart';
import 'package:assignment_day/game/english_game_session.dart';
import 'package:assignment_day/game/game_constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('grades only complete error spans after time ends', () {
    final session = EnglishGameSession(bank: [englishQuynhPassage]);
    final multiWord = englishQuynhPassage.errors.firstWhere(
      (error) => error.end - error.start > 1,
    );

    session.toggle(multiWord.start);
    expect(() => session.foundCount(), throwsStateError);

    for (var i = 0; i < GameConstants.englishRoundSeconds; i++) {
      session.tick();
    }

    expect(session.isFinished, isTrue);
    expect(session.foundCount(), 0);
    expect(session.scorePercent(), 0);
    expect(session.selected, {multiWord.start});

    final again = EnglishGameSession(bank: [englishQuynhPassage]);
    for (final error in englishQuynhPassage.errors) {
      for (var i = error.start; i < error.end; i++) {
        again.toggle(i);
      }
    }
    again.toggle(0);
    again.toggle(0);
    for (var i = 0; i < GameConstants.englishRoundSeconds; i++) {
      again.tick();
    }
    expect(again.foundCount(), GameConstants.englishErrorCount);
    expect(again.scorePercent(), 100);
    expect(again.selected.contains(0), isFalse);
  });

  test('pause freezes the clock and locks taps', () {
    final session = EnglishGameSession(bank: [englishFamilyPassage]);
    session.togglePause();
    expect(session.tick(), isFalse);
    expect(session.secondsLeft, GameConstants.englishRoundSeconds);
    session.toggle(3);
    expect(session.selected, isEmpty);

    session.togglePause();
    session.toggle(3);
    expect(session.selected, {3});
    session.toggle(3);
    expect(session.selected, isEmpty);
  });

  test('time ending locks further selection', () {
    final session = EnglishGameSession(bank: [englishHobbyPassage]);
    for (var i = 0; i < GameConstants.englishRoundSeconds - 1; i++) {
      expect(session.tick(), isFalse);
    }
    expect(session.secondsLeft, 1);
    expect(session.tick(), isTrue);
    expect(session.secondsLeft, 0);
    session.toggle(4);
    expect(session.selected, isEmpty);
  });
}
