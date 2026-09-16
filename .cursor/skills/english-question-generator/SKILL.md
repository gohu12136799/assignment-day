---
name: english-question-generator
description: >-
  Author Brain Rush English find-the-error passages with exactly 20 predefined
  errors. Use when editing english_questions.dart, PlayTopic.english, English
  passages, error spans, or an English round. Follow requirements.md in this
  folder.
---

# English question generator

Read [requirements.md](requirements.md) before adding a passage or changing an English round. That file is the requirement. This skill only says where the data goes.

## Where

- Passages live in `lib/data/english_questions.dart`. Each set needs incorrect text, correct text, and exactly 20 error spans.
- Do not put these passages in `sampleQuestions`. Do not model them as `Question` with `options` and `correctIndex`.
- Do not diff the two strings at play time, and do not invent extra errors during the round.
- The 30-second limit and the 20-error score belong next to `questionSeconds` in `lib/game/game_constants.dart` when the round is implemented. The requirement says 30 seconds and 5% per found error.
- Mixed and random still use `sampleQuestions`. Math uses the math-question-generator skill. Logic images use the logic-question-generator skill.

## Which sections

- Authoring a passage: requirements sections 3–6 and 10.
- What the round may read from that data: requirements sections 7–9. Blue means selected, not correct. Grade only when the 30 seconds end.
