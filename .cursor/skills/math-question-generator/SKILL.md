---
name: math-question-generator
description: >-
  Generate Brain Rush quick-math questions in Dart at round start. Use when
  editing math prompts, options, PlayTopic.math, question generation, or
  a math session. Follow requirements.md in this folder.
---

# Math question generator

Read [requirements.md](requirements.md) before generating questions or changing a math round. That file is the requirement. This skill only says where the code goes.

## Where

- Generate when `GameSession` is constructed for `PlayTopic.math`. Not inside `build`. No network and no LLM.
- Reuse `Question`. Do not add a second question model.
- Do not read the four math entries in `lib/data/questions.dart` for this topic.
- Mixed and random still use `sampleQuestions`. English passages use the english-question-generator skill. Logic images use the logic-question-generator skill.
- Put the round length next to `questionSeconds` in `lib/game/game_constants.dart`. The requirement says 10 questions and 3 seconds. Do not hardcode either number in the screen.
- Circles, gradients, and scatter are the math-answer-layout skill. This skill does not place widgets.

## Which sections

- Generating a question: requirements sections 1–9 and 15.
- Running a math round: requirements sections 10–14. A tap or a 3-second timeout advances. Question 10 ends at the result screen. Record correct, wrong, and timeout on the session. Do not paint correct or wrong on the question. The exam UI skill still applies.
