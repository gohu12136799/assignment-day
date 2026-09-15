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
  String get language => 'Language';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';
}
