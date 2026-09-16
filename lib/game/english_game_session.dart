import 'dart:math';

import '../data/english_questions.dart';
import '../models/english_passage.dart';
import 'game_constants.dart';
import 'game_session.dart';

/// Kết quả một lượt Tiếng Anh, chỉ tạo sau khi hết giờ.
class EnglishRoundResult {
  const EnglishRoundResult({
    required this.found,
    required this.total,
    required this.scorePercent,
    required this.passage,
    required this.selected,
  });

  final int found;
  final int total;
  final int scorePercent;
  final EnglishPassageSet passage;
  final Set<int> selected;
}

/// Một lượt Tiếng Anh: tap từ trong 30 giây, hết giờ mới chấm.
/// Chọn màu xanh dương không có nghĩa là đúng.
class EnglishGameSession {
  EnglishGameSession({List<EnglishPassageSet>? bank, Random? random}) {
    final source = List<EnglishPassageSet>.from(bank ?? englishPassages);
    if (source.isEmpty) {
      throw StateError('No English passages');
    }
    source.shuffle(random ?? Random());
    passage = source.first;
    secondsLeft = GameConstants.englishRoundSeconds;
  }

  late final EnglishPassageSet passage;
  final Set<int> selected = {};

  int secondsLeft = GameConstants.englishRoundSeconds;
  bool paused = false;
  RoundEnd? roundEnd;

  bool get isFinished => roundEnd != null;

  List<String> get words => passage.incorrectText.split(' ');

  /// Chọn hoặc bỏ chọn một từ. Không chấm, không kết thúc lượt.
  void toggle(int wordIndex) {
    if (paused || isFinished) return;
    if (wordIndex < 0 || wordIndex >= words.length) return;
    if (!selected.add(wordIndex)) {
      selected.remove(wordIndex);
    }
  }

  void togglePause() {
    if (isFinished) return;
    paused = !paused;
  }

  /// Giảm đồng hồ. Trả về true khi vừa về 0 và lượt đã khóa.
  bool tick() {
    if (paused || isFinished) return false;
    if (secondsLeft > 1) {
      secondsLeft -= 1;
      return false;
    }
    secondsLeft = 0;
    roundEnd = RoundEnd.cleared;
    return true;
  }

  /// Số span người chơi đã chọn đủ mọi từ. Chỉ gọi sau khi hết giờ.
  int foundCount() {
    if (roundEnd == null) {
      throw StateError('foundCount() only after the round ends');
    }
    var found = 0;
    for (final error in passage.errors) {
      var complete = true;
      for (var i = error.start; i < error.end; i++) {
        if (!selected.contains(i)) {
          complete = false;
          break;
        }
      }
      if (complete) found += 1;
    }
    return found;
  }

  /// `found / 20 * 100`. Chọn nhầm không trừ điểm.
  int scorePercent() {
    return foundCount() * 100 ~/ GameConstants.englishErrorCount;
  }
}
