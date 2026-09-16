---
name: math-answer-layout
description: >-
  Lay out Brain Rush math answers as 10 circular gradient chips at random
  positions. Use when editing the math topic, math options, or GameScreen
  answer UI for PlayTopic.math.
---

# Math answer layout

Only `PlayTopic.math` uses this layout. Mixed and random keep the existing 4-card column in `lib/screens/game_screen.dart`. English find-the-error and Logic image puzzles are not this layout and not that column; see the english-question-generator and logic-question-generator skills. Do not restyle those topics in the same change.

Exam rules do not change. A tap still advances immediately, a 3-second timeout still advances if there is no tap, and nothing reveals `correctIndex` during the question. See the game-session skill.

## What to render

`lib/screens/game_screen.dart` today draws at most 4 answers in a `ListView`, labeled A–D. For math, do not reuse that list.

- Show 10 answers, not 4.
- No A/B/C/D letters.
- Each answer is a circle: `BoxShape.circle`, not `BorderRadius.circular(12)` and not a pill.
- Each circle has its own gradient background. Put a list of 10 gradients in `lib/theme/app_colors.dart`. Build them from the hue families already in that file (red, yellow, blue, purple, green). Do not add hex colors in the screen, and do not use `Colors.teal`.
- Use white text on dark gradients and dark text on light ones so the label stays readable.
- The label is the option string, centered, wrapping inside the circle. Do not overflow.

Math questions in `lib/data/questions.dart` currently have 4 options. A math question shown in this layout must have exactly 10 options, and `correctIndex` must point at one of them. Do not pad the widget with duplicates or empty circles. Update the math entries in the bank in the same change. English find-the-error and Logic image puzzles are not option counts; see the english-question-generator and logic-question-generator skills.

## Placement

Scatter the 10 circles in the area under the question card. Not a column, row, wrap, or grid.

- Use a `Stack` (or equivalent) with positions. Do not use `ListView`, `Column`, `Row`, `Wrap`, or `GridView` for these answers.
- Choose positions once when the question becomes current. A timer `setState` must not shuffle them again.
- The next question gets a new scatter.
- Keep every circle inside that area and inside `SafeArea`. Do not cover the timer, progress bar, or question card.
- Do not stack circles on the same point. Keep them far enough apart to tap. A loose scatter is required; a neat row or column is not.

## Do not

- Change the 3-second timer, pause, scoring, or result flow to fit this layout.
- Apply this scatter to non-math topics.
- Show a checkmark or correct/wrong color when a circle is tapped. The tap leaves the question.
