// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Brain Rush';

  @override
  String get splashSubtitle => 'Challenge your mind\nBreak your limits!';

  @override
  String get loading => 'Loading...';

  @override
  String get playerName => 'Player';

  @override
  String get levelLabel => 'Level 1';

  @override
  String get startPlay => 'Start playing';

  @override
  String get chooseTopic => 'Choose topic';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get achievements => 'Achievements';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get topicMath => 'Math';

  @override
  String get topicMathDesc => 'Train your thinking';

  @override
  String get topicLogic => 'Logic';

  @override
  String get topicLogicDesc => 'Challenge your mind';

  @override
  String get topicEnglish => 'English';

  @override
  String get topicEnglishDesc => 'Find the mistakes';

  @override
  String get topicMixed => 'Mixed';

  @override
  String get topicMixedDesc => 'Combine many question types';

  @override
  String get topicRandom => 'Random';

  @override
  String get topicRandomDesc => 'A surprise every time';

  @override
  String get badgeQuickMath => 'Quick math';

  @override
  String get badgeLogic => 'Logic';

  @override
  String get badgeEnglish => 'English';

  @override
  String get badgeMixed => 'Mixed';

  @override
  String get badgeRandom => 'Random';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get pausedHint => 'Paused — tap ▶ to continue';

  @override
  String get timeUp => 'Time\'s up!';

  @override
  String get examComplete => 'Finished!';

  @override
  String scoreLabel(int score) {
    return 'Score: $score';
  }

  @override
  String answeredLabel(int answered, int total) {
    return 'Answered: $answered / $total';
  }

  @override
  String get playAgain => 'Play again';

  @override
  String get goHome => 'Back to home';

  @override
  String get resultScore => 'Score';

  @override
  String get resultTime => 'Time';

  @override
  String get resultRank => 'Rank';

  @override
  String get englishComplete => 'English Complete';

  @override
  String errorsFound(int found, int total) {
    return '$found / $total errors found';
  }

  @override
  String get scoreHeading => 'Score';

  @override
  String get correctAnswer => 'Correct Answer';

  @override
  String get yourAnswer => 'Your Answer';

  @override
  String logicChoice(int question, int choice) {
    return 'Question $question: answer $choice';
  }

  @override
  String logicUnanswered(int question) {
    return 'Question $question: unanswered';
  }

  @override
  String get language => 'Language';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get sound => 'Sound';

  @override
  String get backgroundMusic => 'Background music';

  @override
  String get notifications => 'Notifications';

  @override
  String get appearance => 'Appearance';

  @override
  String get lightTheme => 'Light';

  @override
  String get guide => 'Guide';

  @override
  String get rateApp => 'Rate the app';

  @override
  String get contact => 'Contact';

  @override
  String get logOut => 'Log out';

  @override
  String get logIn => 'Log in';

  @override
  String get signUp => 'Sign up';

  @override
  String get authWelcomeTitle => 'Welcome to Brain Rush';

  @override
  String get authWelcomeSubtitle =>
      'Sign in to save progress, or play as a guest.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get continueWithPhone => 'Continue with phone';

  @override
  String get emailLabel => 'Email';

  @override
  String get phoneLabel => 'Phone number';

  @override
  String get phoneHint => '+84… or 09…';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get sendCode => 'Send code';

  @override
  String get enterCode => 'Enter code';

  @override
  String get verifyCode => 'Verify';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String otpSentTo(String destination) {
    return 'Code sent to $destination';
  }

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get invalidPhone => 'Enter a valid phone with country code';

  @override
  String get invalidPassword =>
      'At least 8 characters with letters and numbers';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get invalidOtp => 'Enter the 6-digit code';

  @override
  String get authErrorWrongCredentials => 'Email or password is incorrect';

  @override
  String get authErrorInvalidOtp => 'Incorrect or expired code';

  @override
  String get authErrorNetwork => 'Network error. Try again.';

  @override
  String get authErrorCancelled => 'Sign-in cancelled';

  @override
  String get authErrorFacebook => 'Facebook sign-in failed. Check app setup.';

  @override
  String get authErrorNotConfigured =>
      'Firebase is not configured yet. See auth SETUP.';

  @override
  String get authErrorUnknown => 'Something went wrong. Try again.';

  @override
  String get authErrorProviderDisabled =>
      'This sign-in method is not enabled in Firebase.';

  @override
  String get authErrorEmailInUse =>
      'This email already has an account. Please sign in.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get authErrorPopupBlocked =>
      'The browser blocked the sign-in popup. Allow popups.';

  @override
  String get authErrorDatabase =>
      'Could not save the verification code. Check Firestore.';

  @override
  String get authEmailSignInTitle => 'Sign in with email';

  @override
  String get authEmailSignUpTitle => 'Create account';

  @override
  String get authPhoneTitle => 'Phone sign-in';

  @override
  String get authOtpTitle => 'Enter verification code';

  @override
  String get noAccountSignUp => 'No account? Sign up';

  @override
  String get haveAccountSignIn => 'Have an account? Sign in';

  @override
  String get playAsGuest => 'Continue as guest';

  @override
  String debugOtpHint(String code) {
    return 'Debug code: $code';
  }
}
