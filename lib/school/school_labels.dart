import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/play_topic.dart';
import '../theme/app_colors.dart';

String classTitle(AppLocalizations l10n, PlayTopic topic) => switch (topic) {
  PlayTopic.math => l10n.classMath,
  PlayTopic.logic => l10n.classLogic,
  PlayTopic.english => l10n.classEnglish,
  PlayTopic.mixed => l10n.topicMixed,
  PlayTopic.random => l10n.topicRandom,
};

IconData classIcon(PlayTopic topic) => switch (topic) {
  PlayTopic.math => Icons.calculate_rounded,
  PlayTopic.logic => Icons.psychology_alt_rounded,
  PlayTopic.english => Icons.abc_rounded,
  PlayTopic.mixed => Icons.hub_rounded,
  PlayTopic.random => Icons.casino_rounded,
};

List<Color> classIconGradient(PlayTopic topic) => switch (topic) {
  PlayTopic.math => AppColors.redIconGradient,
  PlayTopic.logic => AppColors.yellowIconGradient,
  PlayTopic.english => AppColors.blueIconGradient,
  PlayTopic.mixed => AppColors.purpleIconGradient,
  PlayTopic.random => AppColors.greenIconGradient,
};

/// `8` hoặc `8,5` theo locale.
String formatGrade(BuildContext context, double grade) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat('0.#', locale).format(grade);
}

String formatClock(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
