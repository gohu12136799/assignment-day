import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/play_topic.dart';
import '../theme/app_colors.dart';
import '../widgets/menu_row.dart';
import 'game_screen.dart';

/// Màn Chọn chủ đề.
class TopicSelectScreen extends StatelessWidget {
  const TopicSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Học: dùng chung MenuRow (card trắng + description + iconGradient).
    final topics =
        <
          ({
            PlayTopic topic,
            IconData icon,
            String title,
            String description,
            List<Color> iconGradient,
          })
        >[
          (
            topic: PlayTopic.math,
            icon: Icons.calculate_rounded,
            title: l10n.topicMath,
            description: l10n.topicMathDesc,
            iconGradient: AppColors.redIconGradient,
          ),
          (
            topic: PlayTopic.logic,
            icon: Icons.psychology_alt_rounded,
            title: l10n.topicLogic,
            description: l10n.topicLogicDesc,
            iconGradient: AppColors.yellowIconGradient,
          ),
          (
            topic: PlayTopic.english,
            icon: Icons.abc_rounded,
            title: l10n.topicEnglish,
            description: l10n.topicEnglishDesc,
            iconGradient: AppColors.blueIconGradient,
          ),
          (
            topic: PlayTopic.mixed,
            icon: Icons.hub_rounded,
            title: l10n.topicMixed,
            description: l10n.topicMixedDesc,
            iconGradient: AppColors.purpleIconGradient,
          ),
          (
            topic: PlayTopic.random,
            icon: Icons.casino_rounded,
            title: l10n.topicRandom,
            description: l10n.topicRandomDesc,
            iconGradient: AppColors.greenIconGradient,
          ),
        ];

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.chooseTopic,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 23,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: topics.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = topics[index];
          return MenuRow(
            icon: item.icon,
            label: item.title,
            description: item.description,
            iconGradient: item.iconGradient,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => GameScreen(topic: item.topic),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
