---
name: brain-rush-ui-ux
description: >-
  Keep Brain Rush screens playful, branded, and consistent. Use when creating
  or editing splash, home, topic select, game, result, MenuRow, or any new
  game screen, empty state, feedback, pause, or score UI.
---

# Brain Rush UI/UX

Read the design-system skill before choosing colors or type. This skill decides layout and behavior, not hex values.

## What to preserve

Splash and home are the visual source of truth: dark blue, yellow accent, Nunito Sans, rounded gradient rows, sticker title, mascot, `assets/images/background.png`.

- `MenuRow` has two variants. Home passes `gradient` + `foreground`. Topic select passes `description` + `iconGradient` and gets a white bordered card. Do not add a third row style.
- `BrainRushTitle` is the logo. Do not replace it with a `Text('Brain Rush')`.
- Topic select is a light list on `AppColors.bgLight`. Keep that list readable. Do not force the dark splash background behind long descriptions.
- Leaderboard and achievements already show `l10n.comingSoon` in a SnackBar. Leave them as placeholders unless the user asked to build them. If you touch the snackbar, brand it; do not invent a new message.

## Screen language

| Screen | Look |
|---|---|
| Splash, Home | Dark, branded, gradient actions |
| Topic select | Light list, `MenuRow` card variant |
| Game | Light surface, white question card. Math uses the math-answer-layout skill. English is the find-the-error passage. Logic is the image puzzle in the logic-question-generator skill. Mixed and random keep the 4 colored answer cards |
| Result | Must use brand colors from `ThemeData`, not default teal Material |

Do not make game or topic select copies of the splash. Do not leave Result on the default scaffold style when editing it.

## Exam, not instant feedback

The round is an exam. Tapping an option goes to the next question immediately. If there is no tap, the question still leaves after 3 seconds. Grade only after the last question is answered or times out. Do not turn it into a quiz-show that reveals right or wrong per question.

During the exam:

- Save the selected index, then leave the question. Do not linger to paint correct or incorrect.
- Do not paint correct or incorrect, do not reveal `correctIndex`, and do not show a score, toast, or checkmark.
- Do not add a delay whose purpose is to show the right answer.
- Do not show score on the question card or in the header.

After the exam, on `ResultScreen` only:

- Compute the score from saved answers.
- Show the grade there. Per-question right/wrong, if shown, belongs on the result, not on the question that was just tapped.

Pause blurs and dims the question and answers. The pause button stays above the blur so it can resume. Do not remove the blur. Pause must not reveal answers.

The header countdown is the current question's remaining time, starting at 3. Do not show a 60-second round clock or turn red at `<= 10`. Keep the timer visible. A warning on the last second is enough.

The progress bar is `(index + 1) / length` plus `current/total` text. Keep both. Progress is exam position, not a live grade.

Question badge text changes with topic. The icon is always `Icons.psychology_alt_rounded`. If you change the icon, map it per `PlayTopic` instead of leaving a logic icon on math and English.

## Result and navigation copy

The MCQ exam ends only after the last question's 3 seconds. That result title is `l10n.examComplete`, not `l10n.timeUp`. English ends at 0 on the 30-second clock and uses `l10n.englishComplete`. Do not switch either title back.
- `playAgain` currently `pushAndRemoveUntil` home. Do not send the player back into a dead `GameScreen`. Replay-same-topic is a product change; only do it if the user asked, and then pass the same `PlayTopic`.
- Start playing and Choose topic both open `TopicSelectScreen`. Do not give them different destinations unless the user asked. If you change Start, it must actually start a round.

## Empty, loading, disabled

- Splash loading is a 3-second `AnimationController`, not asset loading. Do not replace it with a spinner unless asked.
- An empty topic filter silently falls back to the full bank in `GameScreen`. If you surface that, say so. Do not crash, and do not show a blank list.
- Home stars are the literal `'0'` and level is `l10n.levelLabel`. Do not add more fake stats. Do not wire stars to the last score unless persistence exists.

## Layout

- Use `SafeArea` and horizontal padding already used on that screen (home 20, topic/game 16, result 24).
- Question prompt is 28px and can wrap. Long prompts need wrap or scale-down, not overflow.
- Do not hardcode a 300px mascot onto a new screen. Splash already owns that asset size.
- Home language control is the settings icon, which opens `SettingsScreen`. Language choice uses arb strings (`language`, `english`, `vietnamese`). Do not put hardcoded `EN` / `VI` back on Home.

## New screens

Match the nearest existing screen, not a generic Material sample. Primary actions use `MenuRow` or a branded filled button from `ThemeData`. Add both locales before showing user-facing copy.
