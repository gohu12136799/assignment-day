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
