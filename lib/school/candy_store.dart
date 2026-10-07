import 'package:shared_preferences/shared_preferences.dart';

import '../models/play_topic.dart';
import 'student_outfits.dart';

/// Kẹo điểm danh và kẹo điểm cao. Đủ 10 kẹo thì đổi một bộ đồ.
class CandyStore {
  static const checkInReward = 1;
  static const praiseReward = 2;

  static const _countKey = 'school.candies';
  static const _outfitKey = 'school.outfit';
  static const _ownedKey = 'school.outfits';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  Future<int> count() async => (await _prefs).getInt(_countKey) ?? 0;

  Future<Set<String>> ownedIds() async {
    final saved = (await _prefs).getStringList(_ownedKey) ?? <String>[];
    return {...saved, StudentOutfitId.uniform.name};
  }

  Future<StudentOutfit> equipped() async {
    final id = (await _prefs).getString(_outfitKey);
    final outfit = outfitById(id);
    if (!(await ownedIds()).contains(outfit.id.name)) {
      return studentOutfits.first;
    }
    return outfit;
  }

  /// Một lần mỗi ngày. Trả về số kẹo vừa cộng, hoặc 0 nếu hôm nay đã tặng.
  Future<int> awardDailyCheckIn(DateTime day) async {
    final prefs = await _prefs;
    final key = 'school.candyDay.${_date(day)}';
    if (prefs.getBool(key) == true) return 0;
    await prefs.setBool(key, true);
    await prefs.setInt(
      _countKey,
      (prefs.getInt(_countKey) ?? 0) + checkInReward,
    );
    return checkInReward;
  }

  /// Một lần mỗi lớp mỗi ngày. Trên 9 điểm thì tặng 2 kẹo.
  Future<int> awardHighScore(PlayTopic topic, DateTime day) async {
    final prefs = await _prefs;
    final key = 'school.candyScore.${_date(day)}.${topic.name}';
    if (prefs.getBool(key) == true) return 0;
    await prefs.setBool(key, true);
    await prefs.setInt(
      _countKey,
      (prefs.getInt(_countKey) ?? 0) + praiseReward,
    );
    return praiseReward;
  }

  /// Đồ đã có thì chỉ mặc. Đồ mới thì trừ kẹo rồi mặc.
  Future<bool> exchange(StudentOutfit outfit) async {
    final prefs = await _prefs;
    final owned = (prefs.getStringList(_ownedKey) ?? <String>[]).toSet()
      ..add(StudentOutfitId.uniform.name);
    if (owned.contains(outfit.id.name) || outfit.cost <= 0) {
      await prefs.setString(_outfitKey, outfit.id.name);
      return true;
    }
    final count = prefs.getInt(_countKey) ?? 0;
    if (count < outfit.cost) return false;
    owned.add(outfit.id.name);
    await prefs.setInt(_countKey, count - outfit.cost);
    await prefs.setStringList(_ownedKey, owned.toList());
    await prefs.setString(_outfitKey, outfit.id.name);
    return true;
  }

  static String _date(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
}
