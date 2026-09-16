---
name: logic-question-generator
description: >-
  Run Brain Rush Logic as an image puzzle from question_logic assets. Use when
  editing PlayTopic.logic, logic question images, six answer images, the Logic
  game screen, or a logic round. Follow requirements.md in this folder.
---

# Logic question generator

Read [requirements.md](requirements.md) before changing a Logic round. That file is the requirement. This skill only says where the code goes.

## Where

- `PlayTopic.logic` opens `LogicGameScreen` from Topic Select. No intermediate screen. Do not send it through the 4-card quiz in `GameScreen`.
- Questions are the image files in section 16, in order Q1 then Q2 then Q3. Do not read the Logic entries in `sampleQuestions`.
- Six answers per question, radio plus image, one card under the question card. Blue means selected, not correct.
- Put the 10-second limit next to `questionSeconds` in `lib/game/game_constants.dart` when the round is implemented. Do not hardcode 10 in the screen.
- A tap saves the choice and advances immediately. A timeout with no tap also advances and counts as unanswered. Question 3 ends at the current result screen.
- This requirement does not define the score. Pass answered count, total, and each question's choice. Do not invent a points formula.
- Mixed and random still use `sampleQuestions`. Math and English use their own skills.
