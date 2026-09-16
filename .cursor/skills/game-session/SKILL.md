---
name: game-session
description: >-
  Change Brain Rush round rules, timer, score, pause, and game navigation
  without adding a state-management package. Use when editing GameScreen,
  ResultScreen, scoring, timer, PlayTopic filtering, or extracting game state.
---

# Game Session

Do not add Riverpod, Bloc, Provider, GetX, or GoRouter. This app uses `setState` on screens and one `ChangeNotifier` for locale (`LocaleController`). Match that.

## Where rules live today

All round rules are private methods on `_GameScreenState` in `lib/screens/game_screen.dart`:

- Per-question limit: `GameConstants.questionSeconds` in `lib/game/game_constants.dart` (currently 3). Do not put another copy in the screen.
- Score: `GameConstants.pointsPerCorrect` (currently 100), added only in `GameSession.grade()` after the last question times out.
- Math questions come from `MathQuestionGenerator`, count `GameConstants.mathQuestionCount`. English find-the-error is `EnglishGameSession` in `lib/screens/english_game_screen.dart`: one passage, `GameConstants.englishRoundSeconds` (30), grade only at 0. Do not send `PlayTopic.english` through the 3-second MCQ path. Logic image puzzles are `LogicGameSession` in `lib/screens/logic_game_screen.dart`: Q1–Q3, `GameConstants.logicQuestionSeconds` (10), no points formula. Mixed and random still use `sampleQuestions`.
- Empty filter: fall back to the full bank
- Pause: timer tick returns early; taps ignored
- A tap calls `GameSession.select`, saves the choice, and advances immediately
- Timeout with no tap also advances and resets the clock to `questionSeconds`
- Finish: last question answered or timed out, then `grade()`, then `pushReplacement` to `ResultScreen`
- `answered` is the count of saved selections, not the current index
- `mixed` and `random` both return every question

`ResultScreen` does not know why the round ended. Play again goes to `HomeScreen` with `pushAndRemoveUntil`.

## When to extract

If a change touches timer, score, index, lock, or topic filter, move those fields out of the widget into a `GameSession` next to the screen (for example `lib/game/game_session.dart`). Leave layout in `GameScreen`.

Use a plain Dart class, or a `ChangeNotifier` like `LocaleController` if the widget should listen. Do not introduce a second pattern in the same change.

The widget may:

- construct the session in `initState`
- call `select`, `grade`, `togglePause`, `tick`
- cancel the `Timer` in `dispose`
- navigate when the session reports finished

The widget may not:

- filter `sampleQuestions` itself
- decide score
- encode finish reason only as a boolean that Result cannot read

## Session contract

Keep shuffle and the empty-bank fallback unless the user asked to change them. Do not keep the 60-second round clock or live scoring. The exam saves answers, then grades once at the end.

Each question gets 3 seconds. A tap saves that option and moves to the next question immediately. Do not wait out the remaining seconds, reveal the answer, or grade. If the player does not tap, the timeout also advances. On the last question, either the tap or the timeout ends the exam. Then call `grade()`.

```dart
enum RoundEnd { cleared }

class GameSession {
  // reads GameConstants.questionSeconds; do not declare a second copy
  // topic, questions, index, answersByIndex, secondsLeft, paused,
  // selectedIndex, roundEnd
  bool select(int optionIndex) {} // save, advance now; no score, no correctIndex leak
  void tick() {} // at 0, advance or end; no-op if paused or already ended
  int grade() {} // call only after roundEnd is set; +100 per correct, no penalty
  void togglePause() {}
}
```

Required behavior on any game-logic edit:

- Reset `secondsLeft` to 3 when a question becomes current, including the first. Pause freezes the remaining seconds. Resume continues that countdown. Do not restart it at 3.
- A valid tap saves the index and advances in that same call. Reset `secondsLeft` to `GameConstants.questionSeconds` on the new question. Do not stay on the answered question to show feedback.
- Do not increment score inside `select`. Do not read `correctIndex` from the widget.
- An unanswered question stays unanswered and scores 0. Do not auto-pick an option on timeout.
- Call `grade()` only when the last question is answered or times out and `roundEnd` is `cleared`. Pass that score to `ResultScreen`. There is no separate round-level time-up while every question already has a 3-second limit.
- Ignore taps while paused or after the exam has ended.
- Do not tick the timer while paused or finished.
- Cancel the timer in `dispose` and before navigating away.
- Keep the empty-bank fallback so a topic with zero questions does not crash.
- Shuffle at round start, not on every rebuild.

`mixed` and `random` are the same code path today. Do not add another topic to that shared `case` without a behavior difference. If you touch `_buildQuestions`, either give `random` a distinct selection rule or stop presenting it as a different mode. Do not silently change math, logic, or English filters.

## Navigation

Keep `Navigator` + `MaterialPageRoute`.

- Splash → home: `pushReplacement`
- Home → topics, topics → game: `push`
- Game → result: `pushReplacement` so Back does not reopen a finished round
- Result → home: `pushAndRemoveUntil` unless the user asked for same-topic replay

Do not start the timer before the first frame's questions exist. Do not leave a `Timer.periodic` running after `RoundEnd` is set.

## Out of scope

- Persistence, leaderboard, achievements, sound, and analytics are not in the session. Do not add packages for them inside a scoring fix.
- Locale stays on `LocaleController`. Do not fold language into `GameSession`.
- Question content and models follow the question-data skill.
