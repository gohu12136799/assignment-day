import 'package:shared_preferences/shared_preferences.dart';

import '../models/play_topic.dart';

/// Điểm danh của người chơi ở một lớp trong một ngày.
class ClassDayRecord {
  const ClassDayRecord({required this.checkedInAt, this.grade});

  final DateTime checkedInAt;

  /// Null là chưa làm bài. Bắt đầu làm bài thì ghi tạm 0.
  final double? grade;

  bool get tested => grade != null;
}

/// Lưu trên máy. Mỗi lớp mỗi ngày một bản ghi.
class AttendanceStore {
  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static String _key(PlayTopic topic, DateTime day) {
    final date =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return 'school.$date.${topic.name}';
  }

  Future<ClassDayRecord?> load(PlayTopic topic, DateTime day) async {
    final raw = (await _prefs).getString(_key(topic, day));
    if (raw == null) return null;
    final parts = raw.split('|');
    final millis = int.tryParse(parts.first);
    if (millis == null) return null;
    return ClassDayRecord(
      checkedInAt: DateTime.fromMillisecondsSinceEpoch(millis),
      grade: parts.length > 1 ? double.tryParse(parts[1]) : null,
    );
  }

  Future<ClassDayRecord> checkIn(PlayTopic topic, DateTime now) async {
    final existing = await load(topic, now);
    if (existing != null) return existing;
    final record = ClassDayRecord(checkedInAt: now);
    await _write(topic, now, record);
    return record;
  }

  Future<ClassDayRecord> saveGrade(
    PlayTopic topic,
    DateTime day,
    double grade,
  ) async {
    final existing = await load(topic, day);
    final record = ClassDayRecord(
      checkedInAt: existing?.checkedInAt ?? day,
      grade: grade,
    );
    await _write(topic, day, record);
    return record;
  }

  Future<void> _write(
    PlayTopic topic,
    DateTime day,
    ClassDayRecord record,
  ) async {
    final grade = record.grade;
    final value = grade == null
        ? '${record.checkedInAt.millisecondsSinceEpoch}'
        : '${record.checkedInAt.millisecondsSinceEpoch}|$grade';
    await (await _prefs).setString(_key(topic, day), value);
  }
}
