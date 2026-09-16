import 'package:assignment_day/game/math_question_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates 10 validated math questions', () {
    for (var i = 0; i < 20; i++) {
      final questions = MathQuestionGenerator().generate();
      expect(questions, hasLength(10));
      expect(questions.map((q) => q.prompt).toSet(), hasLength(10));
      for (final question in questions) {
        expect(question.options, hasLength(10));
        expect(question.options.toSet(), hasLength(10));
      }
    }
  });
}
