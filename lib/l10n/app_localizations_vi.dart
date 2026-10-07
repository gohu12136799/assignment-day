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

  @override
  String get logIn => 'Đăng nhập';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get authWelcomeTitle => 'Chào mừng đến Brain Rush';

  @override
  String get authWelcomeSubtitle =>
      'Đăng nhập để lưu tiến trình, hoặc chơi khách.';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get continueWithFacebook => 'Tiếp tục với Facebook';

  @override
  String get continueWithEmail => 'Tiếp tục với email';

  @override
  String get continueWithPhone => 'Tiếp tục với số điện thoại';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Số điện thoại';

  @override
  String get phoneHint => '+84… hoặc 09…';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get confirmPasswordLabel => 'Xác nhận mật khẩu';

  @override
  String get sendCode => 'Gửi mã';

  @override
  String get enterCode => 'Nhập mã';

  @override
  String get verifyCode => 'Xác minh';

  @override
  String get resendCode => 'Gửi lại mã';

  @override
  String resendCodeIn(int seconds) {
    return 'Gửi lại sau $seconds giây';
  }

  @override
  String otpSentTo(String destination) {
    return 'Đã gửi mã tới $destination';
  }

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get invalidPhone => 'Nhập SĐT kèm mã quốc gia';

  @override
  String get invalidPassword => 'Tối thiểu 8 ký tự, có chữ và số';

  @override
  String get passwordMismatch => 'Mật khẩu không khớp';

  @override
  String get invalidOtp => 'Nhập mã 6 chữ số';

  @override
  String get authErrorWrongCredentials => 'Email hoặc mật khẩu không đúng';

  @override
  String get authErrorInvalidOtp => 'Mã sai hoặc đã hết hạn';

  @override
  String get authErrorNetwork => 'Lỗi mạng. Thử lại.';

  @override
  String get authErrorCancelled => 'Đã hủy đăng nhập';

  @override
  String get authErrorFacebook =>
      'Đăng nhập Facebook thất bại. Kiểm tra cấu hình.';

  @override
  String get authErrorNotConfigured =>
      'Chưa cấu hình Firebase. Xem auth SETUP.';

  @override
  String get authErrorUnknown => 'Có lỗi xảy ra. Thử lại.';

  @override
  String get authErrorProviderDisabled =>
      'Cách đăng nhập này chưa được bật trên Firebase.';

  @override
  String get authErrorEmailInUse => 'Email này đã có tài khoản. Hãy đăng nhập.';

  @override
  String get authErrorTooManyRequests =>
      'Thử quá nhiều lần. Đợi một lúc rồi thử lại.';

  @override
  String get authErrorPopupBlocked =>
      'Trình duyệt chặn cửa sổ đăng nhập. Hãy cho phép popup.';

  @override
  String get authErrorDatabase =>
      'Không lưu được mã xác thực. Kiểm tra Firestore.';

  @override
  String get authEmailSignInTitle => 'Đăng nhập bằng email';

  @override
  String get authEmailSignUpTitle => 'Tạo tài khoản';

  @override
  String get authPhoneTitle => 'Đăng nhập bằng SĐT';

  @override
  String get authOtpTitle => 'Nhập mã xác thực';

  @override
  String get noAccountSignUp => 'Chưa có tài khoản? Đăng ký';

  @override
  String get haveAccountSignIn => 'Đã có tài khoản? Đăng nhập';

  @override
  String get playAsGuest => 'Tiếp tục chơi khách';

  @override
  String debugOtpHint(String code) {
    return 'Mã debug: $code';
  }
}
