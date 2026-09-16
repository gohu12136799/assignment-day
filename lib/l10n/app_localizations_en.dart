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
}
