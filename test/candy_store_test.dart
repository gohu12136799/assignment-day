import 'package:assignment_day/models/play_topic.dart';
import 'package:assignment_day/school/candy_store.dart';
import 'package:assignment_day/school/school_reset.dart';
import 'package:assignment_day/school/student_outfits.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final day = DateTime(2026, 10, 8);

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('daily check-in gives 1 candy once, a high score gives 2', () async {
    final store = CandyStore();

    expect(await store.awardDailyCheckIn(day), 1);
    expect(await store.awardDailyCheckIn(day), 0);
    expect(await store.awardDailyCheckIn(day.add(const Duration(days: 1))), 1);

    expect(await store.awardHighScore(PlayTopic.math, day), 2);
    expect(await store.awardHighScore(PlayTopic.math, day), 0);
    expect(await store.awardHighScore(PlayTopic.english, day), 2);
    expect(await store.count(), 6);
  });

  test('10 candies exchange one of the two outfits', () async {
    final store = CandyStore();
    final sunflower = outfitById(StudentOutfitId.sunflower.name);
    final sailor = outfitById(StudentOutfitId.sailor.name);

    expect(studentOutfits.where((outfit) => outfit.cost > 0), hasLength(2));
    expect(await store.exchange(sunflower), isFalse);

    for (var i = 0; i < 10; i++) {
      await store.awardDailyCheckIn(day.add(Duration(days: i)));
    }
    expect(await store.count(), 10);
    expect(await store.exchange(sunflower), isTrue);
    expect(await store.count(), 0);
    expect((await store.equipped()).id, StudentOutfitId.sunflower);

    expect(await store.exchange(sailor), isFalse);
    expect(await store.exchange(studentOutfits.first), isTrue);
    expect((await store.equipped()).id, StudentOutfitId.uniform);

    await resetSchoolProgress();
    expect(await store.count(), 0);
    expect((await store.equipped()).id, StudentOutfitId.uniform);
  });
}
