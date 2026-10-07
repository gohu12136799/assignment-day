import 'package:shared_preferences/shared_preferences.dart';

import '../models/play_topic.dart';

/// Lớp và tên con mẹ đã đăng ký. Lưu trên máy, chỉ một lớp.
class EnrollmentStore {
  static const _classKey = 'school.enrolledClass';
  static const _nameKey = 'school.studentName';

  Future<PlayTopic?> load() async {
    final name = (await SharedPreferences.getInstance()).getString(_classKey);
    for (final topic in PlayTopic.values) {
      if (topic.name == name) return topic;
    }
    return null;
  }

  Future<String?> studentName() async {
    final name = (await SharedPreferences.getInstance())
        .getString(_nameKey)
        ?.trim();
    if (name == null || name.isEmpty) return null;
    return name;
  }

  /// Đủ lớp và tên thì mới coi là đã đăng ký.
  Future<bool> isComplete() async {
    final topic = await load();
    final name = await studentName();
    return topic != null && name != null;
  }

  Future<void> saveStudentName(String studentName) async {
    await (await SharedPreferences.getInstance()).setString(
      _nameKey,
      studentName.trim(),
    );
  }

  Future<void> enroll(PlayTopic topic, String studentName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_classKey, topic.name);
    await prefs.setString(_nameKey, studentName.trim());
  }
}
