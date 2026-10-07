import 'package:shared_preferences/shared_preferences.dart';

/// Xóa lớp, tên, thầy cô, điểm danh. Học sinh trở thành mới.
Future<void> resetSchoolProgress() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys().where((key) => key.startsWith('school.'));
  for (final key in keys.toList()) {
    await prefs.remove(key);
  }
}
