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
  String get studentGrade => 'Grade 5';

  @override
  String get levelLabel => 'Level 1';

  @override
  String get startPlay => 'Start playing';

  @override
  String get enterClass => 'Enter class';

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
  String get leaveClass => 'Leave class';

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

  @override
  String get schoolName => 'Lotus School';

  @override
  String get schoolNameTop => 'LOTUS';

  @override
  String get schoolNameBottom => 'SCHOOL';

  @override
  String get schoolTagline => 'Where young sprouts grow';

  @override
  String get freePractice => 'Free practice';

  @override
  String get classMath => 'Math class';

  @override
  String get classLogic => 'Logic class';

  @override
  String get classEnglish => 'English class';

  @override
  String teacherName(String name) {
    return 'Ms. $name';
  }

  @override
  String get homeroomTeacher => 'Homeroom teacher';

  @override
  String schoolHours(String open, String close) {
    return 'School hours $open – $close';
  }

  @override
  String get schoolOpenNow => 'Class is in session. Go check in!';

  @override
  String schoolClosedNow(String open, String close) {
    return 'School is closed. Classes run from $open to $close.';
  }

  @override
  String classSize(int count, int max) {
    return 'Students $count/$max';
  }

  @override
  String studentYou(String name) {
    return '$name (you)';
  }

  @override
  String presentAt(String time) {
    return 'Present $time';
  }

  @override
  String get notArrived => 'Not here yet';

  @override
  String get notCheckedIn => 'Not checked in';

  @override
  String get checkedInNoTest => 'Checked in, test not taken';

  @override
  String get checkIn => 'Check in';

  @override
  String get startTest => 'Take the test';

  @override
  String get classRules =>
      'Your teacher gives one test per class. Below 5 earns a ruler tap on the hand, above 9 earns praise. Leaving mid-test scores 0.';

  @override
  String todayGrade(String grade) {
    return 'Today: $grade pts';
  }

  @override
  String get testDoneToday =>
      'You already took this class\'s test today. Come back tomorrow!';

  @override
  String get seeTeacherComment => 'See teacher\'s comment';

  @override
  String get schoolClosedAction => 'School is closed';

  @override
  String gradeOutOfTen(String grade) {
    return '$grade/10';
  }

  @override
  String get verdictPraiseTitle => 'Excellent! Your teacher is proud!';

  @override
  String get verdictPraiseBody =>
      'Above 9 points. You get praised in front of the class.';

  @override
  String get verdictPunishTitle => 'Ouch! A ruler tap on the hand!';

  @override
  String get verdictPunishBody => 'Your teacher gives you 5 ruler taps.';

  @override
  String scoreResult(String name, String grade) {
    return '$name got $grade points.';
  }

  @override
  String get goToPunish => 'Go to the punishment';

  @override
  String get verdictEncourageTitle => 'Good job, push a little more!';

  @override
  String get verdictEncourageBody =>
      'Your teacher believes you\'ll score above 9 next time.';

  @override
  String get backToClass => 'Back to class';

  @override
  String get enrollGreeting =>
      'Hello! Which class would you like to enroll your child in?';

  @override
  String get enrollChooseClass => 'Choose a class';

  @override
  String get enrollAskName => 'What is your child\'s name?';

  @override
  String get enrollNameTitle => 'Your child\'s name';

  @override
  String get enrollWriteName => 'Enter a name';

  @override
  String get enrollNameHint => 'Enter a name';

  @override
  String get enrollNameConfirm => 'Enroll';

  @override
  String get enrollNameEmpty => 'Please tell the teacher your child\'s name.';

  @override
  String enrollWelcome(String name, String className) {
    return 'Let\'s take $name to $className!';
  }

  @override
  String get myClass => 'Your class';

  @override
  String get classNotEnrolled => 'Not enrolled';

  @override
  String get classLockedHint => 'Your child isn\'t enrolled in this class.';

  @override
  String get classRulesMale =>
      'Your teacher gives one test per class. Below 5 earns a ruler tap on the hand, above 9 earns praise. Leaving mid-test scores 0.';

  @override
  String get teacherHung => 'Mr. Hùng';

  @override
  String get teacherNga => 'Ms. Nga';

  @override
  String get teacherHoa => 'Ms. Hoa';

  @override
  String get classAskName => 'What is your name?';

  @override
  String get classAnswer => 'Answer';

  @override
  String classWelcomeMale(String name) {
    return 'Class, please welcome $name. I\'ll show you to your seat.';
  }

  @override
  String classWelcomeFemale(String name) {
    return 'Class, please welcome $name. I\'ll show you to your seat.';
  }

  @override
  String get classStartTest => 'Let\'s start the 15-minute test.';

  @override
  String get classStartButton => 'Start the test';

  @override
  String get verdictPraiseTitleMale => 'Excellent! Your teacher is proud!';

  @override
  String get verdictPraiseBodyMale =>
      'Above 9 points. You get praised in front of the class.';

  @override
  String get verdictPunishTitleMale => 'Ouch! A ruler tap on the hand!';

  @override
  String get verdictPunishBodyMale => 'Your teacher gives you 5 ruler taps.';

  @override
  String get verdictEncourageTitleMale => 'Good job, push a little more!';

  @override
  String get verdictEncourageBodyMale =>
      'Your teacher believes you\'ll score above 9 next time.';

  @override
  String get candyCheckInGift => 'You came to school today. Here is 1 candy!';

  @override
  String get candyPraiseGift => 'Above 9 points. Here are 2 candies!';

  @override
  String candyCount(int count) {
    return 'You have $count candies.';
  }

  @override
  String get candyAccept => 'Take the candy';

  @override
  String get exchangeOutfit => 'New outfit';

  @override
  String get outfitUniform => 'School uniform';

  @override
  String get outfitSunflower => 'Sunflower shirt';

  @override
  String get outfitSailor => 'Sailor shirt';

  @override
  String get outfitPrice => '10 candies';

  @override
  String get outfitWear => 'Wear this';

  @override
  String get outfitWearing => 'Wearing';

  @override
  String outfitShort(int count) {
    return '$count more candies to go.';
  }

  @override
  String get reactionTitle => 'How do you react?';

  @override
  String get reactionScared => 'Scared';

  @override
  String get reactionHappy => 'Cheerful';

  @override
  String get reactionCalm => 'Stubborn';

  @override
  String get reactionTeaseMale => 'Tease him';

  @override
  String get reactionTeaseFemale => 'Tease her';

  @override
  String get reactionTeaseHintMale => 'What do you want to say?';

  @override
  String get reactionTeaseHintFemale => 'What do you want to say?';

  @override
  String get reactionSendMale => 'Say it';

  @override
  String get reactionSendFemale => 'Say it';

  @override
  String get reactionEmpty => 'Type a sentence first.';

  @override
  String get reactionReplyScaredMale =>
      'That was only a light tap. Learn the lesson and next time will be fine.';

  @override
  String get reactionReplyScaredFemale =>
      'That was only a light tap. Learn the lesson and next time will be fine.';

  @override
  String get reactionReplyHappyMale =>
      'You are smiling? Go review, and your teacher will smile too.';

  @override
  String get reactionReplyHappyFemale =>
      'You are smiling? Go review, and your teacher will smile too.';

  @override
  String get reactionReplyCalmMale =>
      'So calm. Look again at the part you missed.';

  @override
  String get reactionReplyCalmFemale =>
      'So calm. Look again at the part you missed.';

  @override
  String reactionReplyTeaseMale(String line) {
    return 'Your teacher heard you say: \"$line\". Score above 9, then tease again.';
  }

  @override
  String reactionReplyTeaseFemale(String line) {
    return 'Your teacher heard you say: \"$line\". Score above 9, then tease again.';
  }
}
