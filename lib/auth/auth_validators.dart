/// Client-side form rules. Match requirements §6.
abstract final class AuthValidators {
  static final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final phoneE164Regex = RegExp(r'^\+[1-9]\d{7,14}$');
  static final otpRegex = RegExp(r'^\d{6}$');
  static final passwordLetter = RegExp(r'[A-Za-z]');
  static final passwordDigit = RegExp(r'\d');

  static String? email(String? value, {required String invalidMessage}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty || !emailRegex.hasMatch(text)) return invalidMessage;
    return null;
  }

  static String? phoneE164(String? value, {required String invalidMessage}) {
    final text = value?.trim() ?? '';
    if (!phoneE164Regex.hasMatch(text)) return invalidMessage;
    return null;
  }

  /// Chấp nhận `09…` hoặc `+84…`. Trả về E.164 hoặc null nếu không hợp lệ.
  static String? normalizeVietnamPhone(String raw) {
    var text = raw.trim().replaceAll(' ', '');
    if (text.startsWith('0') && text.length >= 9) {
      text = '+84${text.substring(1)}';
    }
    if (phoneE164Regex.hasMatch(text)) return text;
    return null;
  }

  static String? password(
    String? value, {
    required String invalidMessage,
  }) {
    final text = value ?? '';
    if (text.length < 8) return invalidMessage;
    if (!passwordLetter.hasMatch(text) || !passwordDigit.hasMatch(text)) {
      return invalidMessage;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password, {
    required String mismatchMessage,
  }) {
    if (value != password) return mismatchMessage;
    return null;
  }

  static String? otp(String? value, {required String invalidMessage}) {
    final text = value?.trim() ?? '';
    if (!otpRegex.hasMatch(text)) return invalidMessage;
    return null;
  }
}
