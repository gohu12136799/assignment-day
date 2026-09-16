// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Brain Rush';

  @override
  String get splashSubtitle => 'Thử thách trí tuệ\nBứt phá giới hạn!';

  @override
  String get loading => 'Đang tải...';

  @override
  String get playerName => 'Người chơi';

  @override
  String get levelLabel => 'Level 1';

  @override
  String get startPlay => 'Bắt đầu chơi';

  @override
  String get chooseTopic => 'Chọn chủ đề';

  @override
  String get leaderboard => 'Bảng xếp hạng';

  @override
  String get achievements => 'Thành tích';

  @override
  String get comingSoon => 'Tính năng sẽ làm ở bước sau';

  @override
  String get topicMath => 'Toán học';

  @override
  String get topicMathDesc => 'Rèn luyện tư duy';

  @override
  String get topicLogic => 'Logic';

  @override
  String get topicLogicDesc => 'Thử thách tư duy';

  @override
  String get topicEnglish => 'Tiếng Anh';

  @override
  String get topicEnglishDesc => 'Tìm lỗi sai';

  @override
  String get topicMixed => 'Hỗn hợp';

  @override
  String get topicMixedDesc => 'Kết hợp nhiều dạng câu hỏi';

  @override
  String get topicRandom => 'Ngẫu nhiên';

  @override
  String get topicRandomDesc => 'Mỗi lần là 1 bất ngờ';

  @override
  String get badgeQuickMath => 'Tính nhanh';

  @override
  String get badgeLogic => 'Logic';

  @override
  String get badgeEnglish => 'Tiếng Anh';

  @override
  String get badgeMixed => 'Hỗn hợp';

  @override
  String get badgeRandom => 'Ngẫu nhiên';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get resume => 'Tiếp tục';

  @override
  String get pausedHint => 'Đã tạm dừng — nhấn ▶ để tiếp tục';

  @override
  String get timeUp => 'Hết giờ!';

  @override
  String get examComplete => 'Hoàn thành!';

  @override
  String scoreLabel(int score) {
    return 'Điểm: $score';
  }

  @override
  String answeredLabel(int answered, int total) {
    return 'Đã trả lời: $answered / $total câu';
  }

  @override
  String get playAgain => 'Chơi lại';

  @override
  String get goHome => 'Về trang chủ';

  @override
  String get resultScore => 'Điểm số';

  @override
  String get resultTime => 'Thời gian';

  @override
  String get resultRank => 'Xếp hạng';

  @override
  String get englishComplete => 'Hoàn thành tiếng Anh';

  @override
  String errorsFound(int found, int total) {
    return 'Tìm được $found / $total lỗi';
  }

  @override
  String get scoreHeading => 'Điểm';

  @override
  String get correctAnswer => 'Đáp án đúng';

  @override
  String get yourAnswer => 'Lựa chọn của bạn';

  @override
  String logicChoice(int question, int choice) {
    return 'Câu $question: đáp án $choice';
  }

  @override
  String logicUnanswered(int question) {
    return 'Câu $question: không trả lời';
  }

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get settings => 'Cài đặt';

  @override
  String get sound => 'Âm thanh';

  @override
  String get backgroundMusic => 'Nhạc nền';

  @override
  String get notifications => 'Thông báo';

  @override
  String get appearance => 'Chủ đề giao diện';

  @override
  String get lightTheme => 'Sáng';

  @override
  String get guide => 'Hướng dẫn';

  @override
  String get rateApp => 'Đánh giá ứng dụng';

  @override
  String get contact => 'Liên hệ';

  @override
  String get logOut => 'Đăng xuất';
}
