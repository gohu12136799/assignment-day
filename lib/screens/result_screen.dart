import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../game/english_game_session.dart';
import '../game/game_constants.dart';
import '../game/logic_game_session.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/english_passage_text.dart';
import 'home_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.score,
    required this.answered,
    required this.total,
    required this.elapsed,
    required this.onReplay,
    this.english,
    this.logic,
  });

  final int score;
  final int answered;
  final int total;
  final Duration elapsed;
  final void Function(BuildContext context) onReplay;
  final EnglishRoundResult? english;
  final LogicRoundResult? logic;

  String get _scoreText {
    final english = this.english;
    if (english != null) return '${english.found}/${english.total}';
    final logic = this.logic;
    if (logic != null) return '${logic.answered}/${logic.total}';
    final correct = score ~/ GameConstants.pointsPerCorrect;
    return '$correct/$total';
  }

  String get _timeText {
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final english = this.english;
    final title = english != null ? l10n.englishComplete : l10n.examComplete;
    final extra = english != null ? _EnglishReview(result: english) : null;

    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            children: [
              Expanded(
                child: extra == null
                    ? Column(
                        children: [
                          const Spacer(),
                          _Celebration(title: title, result: this),
                          const Spacer(),
                        ],
                      )
                    : ListView(
                        children: [
                          _Celebration(title: title, result: this),
                          const SizedBox(height: 20),
                          extra,
                        ],
                      ),
              ),
              const SizedBox(height: 20),
              _ReplayButton(
                label: l10n.playAgain,
                onPressed: () => onReplay(context),
              ),
              const SizedBox(height: 12),
              _HomeButton(
                label: l10n.goHome,
                onPressed: () => _goHome(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Celebration extends StatelessWidget {
  const _Celebration({required this.title, required this.result});

  final String title;
  final ResultScreen result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        const _TrophyMark(),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        _StatsCard(
          rows: [
            _Stat(
              icon: Icons.workspace_premium_outlined,
              label: l10n.resultScore,
              value: result._scoreText,
            ),
            _Stat(
              icon: Icons.timer_outlined,
              label: l10n.resultTime,
              value: result._timeText,
            ),
            // Chưa có bảng xếp hạng đã lưu. Không bịa #5.
            _Stat(
              icon: Icons.workspace_premium_outlined,
              label: l10n.resultRank,
              value: '—',
            ),
          ],
        ),
      ],
    );
  }
}

class _TrophyMark extends StatelessWidget {
  const _TrophyMark();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/result_trophy.svg',
      width: 220,
      height: 176,
      fit: BoxFit.contain,
    );
  }
}

class _Stat {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.rows});

  final List<_Stat> rows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          Colors.white.withValues(alpha: 0.14),
          AppColors.bgBlueLight,
        ).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              _StatRow(stat: rows[i]),
              if (i != rows.length - 1)
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.16)),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stat});

  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(stat.icon, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stat.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            stat.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplayButton extends StatelessWidget {
  const _ReplayButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              offset: Offset(2, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.refresh_rounded, size: 28),
          label: Text(label),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.bgBlueDeep,
            elevation: 0,
            minimumSize: const Size(double.infinity, 60),
            iconSize: 28,
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  const _HomeButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.home_rounded, size: 28),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 1.5),
          minimumSize: const Size(double.infinity, 60),
          iconSize: 28,
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _EnglishReview extends StatelessWidget {
  const _EnglishReview({required this.result});

  final EnglishRoundResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.correctAnswer,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _reviewCard(EnglishCorrectText(passage: result.passage)),
        const SizedBox(height: 20),
        Text(
          l10n.yourAnswer,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _reviewCard(
          EnglishYourAnswerText(
            words: result.passage.incorrectText.split(' '),
            selected: result.selected,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _reviewCard(Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
