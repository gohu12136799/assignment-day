import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Rush'**
  String get appTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge your mind\nBreak your limits!'**
  String get splashSubtitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @playerName.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get playerName;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level 1'**
  String get levelLabel;

  /// No description provided for @startPlay.
  ///
  /// In en, this message translates to:
  /// **'Start playing'**
  String get startPlay;

  /// No description provided for @chooseTopic.
  ///
  /// In en, this message translates to:
  /// **'Choose topic'**
  String get chooseTopic;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboard;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @topicMath.
  ///
  /// In en, this message translates to:
  /// **'Math'**
  String get topicMath;

  /// No description provided for @topicMathDesc.
  ///
  /// In en, this message translates to:
  /// **'Train your thinking'**
  String get topicMathDesc;

  /// No description provided for @topicLogic.
  ///
  /// In en, this message translates to:
  /// **'Logic'**
  String get topicLogic;

  /// No description provided for @topicLogicDesc.
  ///
  /// In en, this message translates to:
  /// **'Challenge your mind'**
  String get topicLogicDesc;

  /// No description provided for @topicEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get topicEnglish;

  /// No description provided for @topicEnglishDesc.
  ///
  /// In en, this message translates to:
  /// **'Find the mistakes'**
  String get topicEnglishDesc;

  /// No description provided for @topicMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get topicMixed;

  /// No description provided for @topicMixedDesc.
  ///
  /// In en, this message translates to:
  /// **'Combine many question types'**
  String get topicMixedDesc;

  /// No description provided for @topicRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get topicRandom;

  /// No description provided for @topicRandomDesc.
  ///
  /// In en, this message translates to:
  /// **'A surprise every time'**
  String get topicRandomDesc;

  /// No description provided for @badgeQuickMath.
  ///
  /// In en, this message translates to:
  /// **'Quick math'**
  String get badgeQuickMath;

  /// No description provided for @badgeLogic.
  ///
  /// In en, this message translates to:
  /// **'Logic'**
  String get badgeLogic;

  /// No description provided for @badgeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get badgeEnglish;

  /// No description provided for @badgeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get badgeMixed;

  /// No description provided for @badgeRandom.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get badgeRandom;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pausedHint.
  ///
  /// In en, this message translates to:
  /// **'Paused — tap ▶ to continue'**
  String get pausedHint;

  /// No description provided for @timeUp.
  ///
  /// In en, this message translates to:
  /// **'Time\'s up!'**
  String get timeUp;

  /// No description provided for @examComplete.
  ///
  /// In en, this message translates to:
  /// **'Finished!'**
  String get examComplete;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreLabel(int score);

  /// No description provided for @answeredLabel.
  ///
  /// In en, this message translates to:
  /// **'Answered: {answered} / {total}'**
  String answeredLabel(int answered, int total);

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgain;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get goHome;

  /// No description provided for @resultScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get resultScore;

  /// No description provided for @resultTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get resultTime;

  /// No description provided for @resultRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get resultRank;

  /// No description provided for @englishComplete.
  ///
  /// In en, this message translates to:
  /// **'English Complete'**
  String get englishComplete;

  /// No description provided for @errorsFound.
  ///
  /// In en, this message translates to:
  /// **'{found} / {total} errors found'**
  String errorsFound(int found, int total);

  /// No description provided for @scoreHeading.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreHeading;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @logicChoice.
  ///
  /// In en, this message translates to:
  /// **'Question {question}: answer {choice}'**
  String logicChoice(int question, int choice);

  /// No description provided for @logicUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Question {question}: unanswered'**
  String logicUnanswered(int question);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @backgroundMusic.
  ///
  /// In en, this message translates to:
  /// **'Background music'**
  String get backgroundMusic;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @guide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get guide;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateApp;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Brain Rush'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save progress, or play as a guest.'**
  String get authWelcomeSubtitle;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with phone'**
  String get continueWithPhone;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+84… or 09…'**
  String get phoneHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendCodeIn(int seconds);

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Code sent to {destination}'**
  String otpSentTo(String destination);

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone with country code'**
  String get invalidPhone;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters with letters and numbers'**
  String get invalidPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get invalidOtp;

  /// No description provided for @authErrorWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get authErrorWrongCredentials;

  /// No description provided for @authErrorInvalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Incorrect or expired code'**
  String get authErrorInvalidOtp;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Try again.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorCancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in cancelled'**
  String get authErrorCancelled;

  /// No description provided for @authErrorFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook sign-in failed. Check app setup.'**
  String get authErrorFacebook;

  /// No description provided for @authErrorNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Firebase is not configured yet. See auth SETUP.'**
  String get authErrorNotConfigured;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get authErrorUnknown;

  /// No description provided for @authErrorProviderDisabled.
  ///
  /// In en, this message translates to:
  /// **'This sign-in method is not enabled in Firebase.'**
  String get authErrorProviderDisabled;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email already has an account. Please sign in.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment and try again.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorPopupBlocked.
  ///
  /// In en, this message translates to:
  /// **'The browser blocked the sign-in popup. Allow popups.'**
  String get authErrorPopupBlocked;

  /// No description provided for @authErrorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Could not save the verification code. Check Firestore.'**
  String get authErrorDatabase;

  /// No description provided for @authEmailSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email'**
  String get authEmailSignInTitle;

  /// No description provided for @authEmailSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authEmailSignUpTitle;

  /// No description provided for @authPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone sign-in'**
  String get authPhoneTitle;

  /// No description provided for @authOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get authOtpTitle;

  /// No description provided for @noAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'No account? Sign up'**
  String get noAccountSignUp;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Have an account? Sign in'**
  String get haveAccountSignIn;

  /// No description provided for @playAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get playAsGuest;

  /// No description provided for @debugOtpHint.
  ///
  /// In en, this message translates to:
  /// **'Debug code: {code}'**
  String debugOtpHint(String code);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
