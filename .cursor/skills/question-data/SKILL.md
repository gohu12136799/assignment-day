---
name: question-data
description: >-
  Add or change Brain Rush questions, topics, and question types using the
  existing models. Use when editing Question, PlayTopic, sampleQuestions,
  topic filtering, prompts, options, or localized question content.
---

# Question Data

Read `lib/models/question.dart`, `lib/models/play_topic.dart`, and `lib/data/questions.dart` before editing content. There is no repository, API, or JSON bank.

## Current model

```dart
enum QuestionType { math, logic, english }

class Question {
  const Question({
    required this.type,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}
```

`Question.typeLabel` returns hardcoded Vietnamese (`Toán`, `Logic`, `Tiếng Anh`) and is unused. Do not add more hardcoded labels. Topic names on screen come from arb keys (`topicMath`, `badgeQuickMath`, and the matching logic/English/mixed/random keys).

`PlayTopic` is `math`, `logic`, `english`, `mixed`, `random`. It is not the same enum as `QuestionType`. A play topic may include several question types. Do not merge the enums unless every call site is updated in the same change.

The bank is `const sampleQuestions` in `lib/data/questions.dart`: 4 math, 2 logic, 2 English. Prompts and options are Vietnamese even when the app locale is English.

## Adding a question

- Add a `const Question` to `sampleQuestions`.
- `correctIndex` must be inside `options`.
- Keep at least 2 options. Logic, English, mixed, and random still render at most 4 A–D cards (`options.length.clamp(0, 4)`). More than 4 options will not show there.
- `PlayTopic.math` does not use those four bank entries. Generate its questions with the math-question-generator skill. Each generated question needs exactly 10 options. Layout rules are in the math-answer-layout skill. Do not pad those 10 options inside the widget.
- `PlayTopic.english` find-the-error passages are not these two MCQs. Author them with the english-question-generator skill. Do not add a passage to `sampleQuestions`.
- `PlayTopic.logic` image puzzles are not these two MCQs. Use the logic-question-generator skill. Do not add puzzle images to `sampleQuestions`.
- Do not put question strings in widgets or arb chrome files.
- Do not shuffle the const list. The session shuffles a copy at round start.

## Topic filters

| PlayTopic | Current filter |
|---|---|
| math, logic, english | `question.type` matches |
| mixed, random | all questions, same code path |

Keep math, logic, and English as type filters. Do not special-case them in the widget. See the game-session skill before changing mixed vs random.

If a filter can return empty, keep the full-bank fallback in the session, not a new empty-screen crash.

## Localization

UI chrome belongs in `lib/l10n/app_en.arb` and `app_vi.arb`. Generated `app_localizations*.dart` is not edited by hand.

Question content is not localized yet. Until a per-locale bank exists:

- Do not write English prompts into the Vietnamese bank and call it done.
- If the user asks for localized questions, add a locale-keyed source (for example a function `questionsFor(Locale)`) and keep `Question` free of `BuildContext`.
- Default locale is `vi` (`LocaleController`). English UI with Vietnamese prompts is the current behavior; do not half-translate one question.

## New question types

The game screen only renders multiple choice: prompt, options, one `correctIndex`. True/false can fit that model. Typed answers, ordering, or matching cannot.

To add a non-MCQ type:

1. Extend `Question` so existing const questions still compile.
2. Update `GameScreen` rendering in the same change.
3. Do not leave a new `QuestionType` value that the game paints as four colored rows of the wrong shape.

No ids exist. Add an id only when persistence or analytics needs a stable key. Do not add a repository interface over a const list.
