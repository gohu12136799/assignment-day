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
  String get studentGrade => 'Lớp 5';

  @override
  String get levelLabel => 'Level 1';

  @override
  String get startPlay => 'Bắt đầu chơi';

  @override
  String get enterClass => 'Vào lớp';

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
  String get leaveClass => 'Rời lớp';

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

  @override
  String get schoolName => 'Trường học Hoa Sen';

  @override
  String get schoolNameTop => 'TRƯỜNG HỌC';

  @override
  String get schoolNameBottom => 'HOA SEN';

  @override
  String get schoolTagline => 'Nơi ươm mầm non';

  @override
  String get freePractice => 'Luyện tập tự do';

  @override
  String get classMath => 'Lớp Toán';

  @override
  String get classLogic => 'Lớp Logic';

  @override
  String get classEnglish => 'Lớp Tiếng Anh';

  @override
  String teacherName(String name) {
    return 'Cô $name';
  }

  @override
  String get homeroomTeacher => 'Giáo viên chủ nhiệm';

  @override
  String schoolHours(String open, String close) {
    return 'Giờ học $open – $close';
  }

  @override
  String get schoolOpenNow => 'Đang trong giờ học, vào lớp điểm danh nhé!';

  @override
  String schoolClosedNow(String open, String close) {
    return 'Ngoài giờ học. Lớp chỉ mở từ $open đến $close.';
  }

  @override
  String classSize(int count, int max) {
    return 'Sĩ số $count/$max';
  }

  @override
  String studentYou(String name) {
    return '$name (bạn)';
  }

  @override
  String presentAt(String time) {
    return 'Có mặt $time';
  }

  @override
  String get notArrived => 'Chưa đến';

  @override
  String get notCheckedIn => 'Chưa điểm danh';

  @override
  String get checkedInNoTest => 'Đã điểm danh, chưa làm bài';

  @override
  String get checkIn => 'Điểm danh';

  @override
  String get startTest => 'Làm bài kiểm tra';

  @override
  String get classRules =>
      'Vào lớp cô sẽ cho 1 bài kiểm tra. Dưới 5 điểm bị cô khẽ tay, trên 9 điểm được cô khen. Thoát giữa chừng tính 0 điểm.';

  @override
  String todayGrade(String grade) {
    return 'Hôm nay: $grade điểm';
  }

  @override
  String get testDoneToday =>
      'Hôm nay bạn đã làm bài lớp này. Mai quay lại nhé!';

  @override
  String get seeTeacherComment => 'Xem lời cô';

  @override
  String get schoolClosedAction => 'Ngoài giờ học';

  @override
  String gradeOutOfTen(String grade) {
    return '$grade/10';
  }

  @override
  String get verdictPraiseTitle => 'Giỏi quá! Cô khen con!';

  @override
  String get verdictPraiseBody =>
      'Điểm trên 9, con được cô tuyên dương trước lớp.';

  @override
  String get verdictPunishTitle => 'Ối! Bị cô khẽ tay rồi!';

  @override
  String get verdictPunishBody => 'Cô phạt em 5 roi.';

  @override
  String scoreResult(String name, String grade) {
    return 'Bạn $name được $grade điểm';
  }

  @override
  String get goToPunish => 'Đi tới mục phạt';

  @override
  String get verdictEncourageTitle => 'Khá lắm, cố thêm chút nữa!';

  @override
  String get verdictEncourageBody => 'Cô tin lần sau con sẽ được trên 9 điểm.';

  @override
  String get backToClass => 'Về lớp';

  @override
  String get enrollGreeting => 'Chào mẹ, mẹ muốn đăng ký lớp nào cho con?';

  @override
  String get enrollChooseClass => 'Chọn lớp cho con';

  @override
  String get enrollAskName => 'Con tên là gì ạ?';

  @override
  String get enrollNameTitle => 'Tên của con';

  @override
  String get enrollWriteName => 'Ghi tên';

  @override
  String get enrollNameHint => 'Nhập tên con';

  @override
  String get enrollNameConfirm => 'Đăng ký';

  @override
  String get enrollNameEmpty => 'Mẹ cho cô biết tên con nhé.';

  @override
  String enrollWelcome(String name, String className) {
    return 'Cô đưa $name vào $className nhé!';
  }

  @override
  String get myClass => 'Lớp của con';

  @override
  String get classNotEnrolled => 'Chưa đăng ký';

  @override
  String get classLockedHint => 'Con chưa đăng ký lớp này.';

  @override
  String get classRulesMale =>
      'Vào lớp thầy sẽ cho 1 bài kiểm tra. Dưới 5 điểm bị thầy khẽ tay, trên 9 điểm được thầy khen. Thoát giữa chừng tính 0 điểm.';

  @override
  String get teacherHung => 'Thầy Hùng';

  @override
  String get teacherNga => 'Cô Nga';

  @override
  String get teacherHoa => 'Cô Hoa';

  @override
  String get classAskName => 'Em tên là gì?';

  @override
  String get classAnswer => 'Trả lời';

  @override
  String classWelcomeMale(String name) {
    return 'Các bạn chào đón $name nhé. Thầy dẫn em vào ghế.';
  }

  @override
  String classWelcomeFemale(String name) {
    return 'Các bạn chào đón $name nhé. Cô dẫn em vào ghế.';
  }

  @override
  String get classStartTest => 'Bắt đầu kiểm tra 15 phút nhé.';

  @override
  String get classStartButton => 'Làm bài';

  @override
  String get verdictPraiseTitleMale => 'Giỏi quá! Thầy khen em!';

  @override
  String get verdictPraiseBodyMale =>
      'Điểm trên 9, em được thầy tuyên dương trước lớp.';

  @override
  String get verdictPunishTitleMale => 'Ối! Bị thầy khẽ tay rồi!';

  @override
  String get verdictPunishBodyMale => 'Thầy phạt em 5 roi.';

  @override
  String get verdictEncourageTitleMale => 'Khá lắm, cố thêm chút nữa!';

  @override
  String get verdictEncourageBodyMale =>
      'Thầy tin lần sau em sẽ được trên 9 điểm.';

  @override
  String get candyCheckInGift => 'Đi học đều, em được tặng 1 cái kẹo!';

  @override
  String get candyPraiseGift => 'Trên 9 điểm, em được tặng 2 cái kẹo!';

  @override
  String candyCount(int count) {
    return 'Em đang có $count cái kẹo.';
  }

  @override
  String get candyAccept => 'Nhận kẹo';

  @override
  String get exchangeOutfit => 'Đổi bộ đồ';

  @override
  String get outfitUniform => 'Đồng phục';

  @override
  String get outfitSunflower => 'Áo hoa hướng dương';

  @override
  String get outfitSailor => 'Áo thủy thủ';

  @override
  String get outfitPrice => '10 kẹo';

  @override
  String get outfitWear => 'Mặc bộ này';

  @override
  String get outfitWearing => 'Đang mặc';

  @override
  String outfitShort(int count) {
    return 'Còn thiếu $count kẹo.';
  }

  @override
  String get reactionTitle => 'Em phản ứng thế nào?';

  @override
  String get reactionScared => 'Sợ hãi';

  @override
  String get reactionHappy => 'Vui vẻ';

  @override
  String get reactionCalm => 'Lì lợm';

  @override
  String get reactionTeaseMale => 'Chọc thầy';

  @override
  String get reactionTeaseFemale => 'Chọc cô';

  @override
  String get reactionTeaseHintMale => 'Em muốn nói gì với thầy?';

  @override
  String get reactionTeaseHintFemale => 'Em muốn nói gì với cô?';

  @override
  String get reactionSendMale => 'Nói với thầy';

  @override
  String get reactionSendFemale => 'Nói với cô';

  @override
  String get reactionEmpty => 'Em nhập một câu đã nhé.';

  @override
  String get reactionReplyScaredMale =>
      'Thầy chỉ khẽ tay nhẹ thôi. Lần sau học thuộc là không sao.';

  @override
  String get reactionReplyScaredFemale =>
      'Cô chỉ khẽ tay nhẹ thôi. Lần sau học thuộc là không sao.';

  @override
  String get reactionReplyHappyMale =>
      'Em vui thế à? Về ôn bài cho thầy cười theo nhé.';

  @override
  String get reactionReplyHappyFemale =>
      'Em vui thế à? Về ôn bài cho cô cười theo nhé.';

  @override
  String get reactionReplyCalmMale =>
      'Em bình tĩnh ghê. Nhớ xem lại chỗ bị sai nhé.';

  @override
  String get reactionReplyCalmFemale =>
      'Em bình tĩnh ghê. Nhớ xem lại chỗ bị sai nhé.';

  @override
  String reactionReplyTeaseMale(String line) {
    return 'Thầy nghe em nói: \"$line\". Làm trên 9 điểm rồi hãy chọc tiếp nhé.';
  }

  @override
  String reactionReplyTeaseFemale(String line) {
    return 'Cô nghe em nói: \"$line\". Làm trên 9 điểm rồi hãy chọc tiếp nhé.';
  }
}
