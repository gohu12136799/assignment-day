import '../models/play_topic.dart';
import 'school_rules.dart';

/// Một lớp: một cô chủ nhiệm, bạn học giả lập, bài kiểm tra theo [topic].
class SchoolClass {
  const SchoolClass({
    required this.topic,
    required this.teacherName,
    required this.classmates,
  });

  final PlayTopic topic;
  final String teacherName;

  /// Bạn học giả lập. Người chơi là học sinh còn lại.
  final List<String> classmates;
}

const schoolClasses = <SchoolClass>[
  SchoolClass(
    topic: PlayTopic.math,
    teacherName: 'Lan',
    classmates: ['An', 'Bình', 'Chi', 'Dũng'],
  ),
  SchoolClass(
    topic: PlayTopic.logic,
    teacherName: 'Mai',
    classmates: ['Giang', 'Hải', 'Khoa', 'Linh'],
  ),
  SchoolClass(
    topic: PlayTopic.english,
    teacherName: 'Hoa',
    classmates: ['Minh', 'Ngọc', 'Phúc', 'Quân'],
  ),
];

/// Giờ bạn học giả lập điểm danh hôm đó. Null là bạn đó nghỉ.
/// Cố định theo ngày và tên để mở lại app vẫn thấy như cũ.
DateTime? classmateCheckInTime(String name, DateTime day) {
  var hash = day.year * 372 + day.month * 31 + day.day;
  for (final unit in name.codeUnits) {
    hash = (hash * 31 + unit) & 0x7fffffff;
  }
  if (hash % 6 == 0) return null;
  const windowMinutes = (SchoolRules.closeHour - SchoolRules.openHour - 1) * 60;
  final minutes = hash % windowMinutes;
  return DateTime(
    day.year,
    day.month,
    day.day,
    SchoolRules.openHour,
  ).add(Duration(minutes: minutes));
}
