/// Luật Trường học Hoa Sen: giờ học, sĩ số, ngưỡng khen / khẽ tay.
abstract final class SchoolRules {
  /// Mở cửa 24h (giờ máy). Muốn giới hạn lại thì đổi, ví dụ 7 và 17.
  static const openHour = 0;
  static const closeHour = 24;

  /// Tối đa 5 học sinh mỗi lớp, tính cả người chơi.
  static const maxStudents = 5;

  /// Dưới 5 điểm bị khẽ tay. Trên 9 điểm được khen.
  static const punishBelow = 5.0;
  static const praiseAbove = 9.0;

  static bool isOpen(DateTime now) =>
      now.hour >= openHour && now.hour < closeHour;

  static String hourLabel(int hour) => '${hour.toString().padLeft(2, '0')}:00';
}

enum TeacherVerdict { punish, encourage, praise }

TeacherVerdict verdictFor(double grade) {
  if (grade < SchoolRules.punishBelow) return TeacherVerdict.punish;
  if (grade > SchoolRules.praiseAbove) return TeacherVerdict.praise;
  return TeacherVerdict.encourage;
}

/// Thang 10, làm tròn 1 chữ số thập phân.
double tenPointGrade(int correct, int total) {
  if (total <= 0) return 0;
  return (correct * 100 / total).round() / 10;
}
