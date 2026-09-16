import 'package:assignment_day/data/english_questions.dart';
import 'package:assignment_day/models/english_passage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each English passage has exactly 20 tappable errors', () {
    expect(englishPassages, isNotEmpty);
    for (final passage in englishPassages) {
      expect(passage.errors, hasLength(EnglishPassageSet.errorCount));
      expect(_rebuild(passage), passage.correctText.split(' '));

      var previousEnd = 0;
      final covered = <int>{};
      for (final error in passage.errors) {
        expect(error.start, greaterThanOrEqualTo(previousEnd));
        expect(error.end, greaterThan(error.start));
        final words = passage.incorrectText.split(' ');
        expect(
          words.sublist(error.start, error.end).join(' '),
          error.incorrect,
        );
        for (var i = error.start; i < error.end; i++) {
          covered.add(i);
        }
        previousEnd = error.end;
      }
      expect(
        covered,
        hasLength(
          passage.errors.fold<int>(
            0,
            (sum, error) => sum + error.end - error.start,
          ),
        ),
      );
    }
  });
}

List<String> _rebuild(EnglishPassageSet passage) {
  final words = passage.incorrectText.split(' ');
  final rebuilt = <String>[];
  var index = 0;
  for (final error in passage.errors) {
    rebuilt.addAll(words.sublist(index, error.start));
    if (error.correct.isNotEmpty) {
      rebuilt.addAll(error.correct.split(' '));
    }
    index = error.end;
  }
  rebuilt.addAll(words.sublist(index));
  return rebuilt;
}
