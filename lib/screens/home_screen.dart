import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/brain_rush_title.dart';
import '../widgets/menu_row.dart';
import 'settings_screen.dart';
import 'topic_select_screen.dart';

/// Màn Home / menu chơi.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openTopics(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const TopicSelectScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 1, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Transform.translate(
                        offset: const Offset(0, -48),
                        child: const BrainRushTitle(
                          fontSize: 48,
                          arcDegrees: 36,
                          height: 150,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            offset: Offset(2, 4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.yellow,
                            child: Icon(
                              Icons.person,
                              color: AppColors.bgBlueDeep,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.playerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.levelLabel,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.yellow,
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    MenuRow(
                      icon: Icons.play_arrow_rounded,
                      label: l10n.startPlay,
                      gradient: AppColors.yellowGradient,
                      foreground: Colors.black,
                      height: 65,
                      onTap: () => _openTopics(context),
                    ),
                    const SizedBox(height: 12),
                    MenuRow(
                      icon: Icons.apps_rounded,
                      label: l10n.chooseTopic,
                      gradient: AppColors.greenGradient,
                      foreground: Colors.white,
                      height: 65,
                      onTap: () => _openTopics(context),
                    ),
                    const SizedBox(height: 12),
                    MenuRow(
                      icon: Icons.bar_chart_rounded,
                      label: l10n.leaderboard,
                      gradient: AppColors.blueGradient,
                      foreground: Colors.white,
                      height: 65,
                      onTap: () => _comingSoon(context),
                    ),
                    const SizedBox(height: 12),
                    MenuRow(
                      icon: Icons.emoji_events_rounded,
                      label: l10n.achievements,
                      gradient: AppColors.purpleGradient,
                      foreground: Colors.white,
                      height: 65,
                      onTap: () => _comingSoon(context),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                  tooltip: l10n.settings,
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
  }
}
