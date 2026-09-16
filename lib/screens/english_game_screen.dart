import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../game/english_game_session.dart';
import '../game/game_constants.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../widgets/english_passage_text.dart';
import 'result_screen.dart';

/// Lượt Tiếng Anh: một đoạn sai, 30 giây, tap từ. Không báo đúng sai lúc chơi.
class EnglishGameScreen extends StatefulWidget {
  const EnglishGameScreen({super.key, this.session});

  final EnglishGameSession? session;

  @override
  State<EnglishGameScreen> createState() => _EnglishGameScreenState();
}

class _EnglishGameScreenState extends State<EnglishGameScreen> {
  late final EnglishGameSession _session;
  Timer? _timer;
  final Stopwatch _elapsed = Stopwatch();

  bool get _warning => _session.secondsLeft <= 1;

  @override
  void initState() {
    super.initState();
    _session = widget.session ?? EnglishGameSession();
    _elapsed.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final finished = _session.tick();
      if (!mounted) return;
      if (finished) {
        _finish();
        return;
      }
      setState(() {});
    });
  }

  void _togglePause() {
    setState(_session.togglePause);
    if (_session.paused) {
      _elapsed.stop();
    } else {
      _elapsed.start();
    }
  }

  void _toggleWord(int index) {
    setState(() => _session.toggle(index));
  }

  void _finish() {
    _timer?.cancel();
    _elapsed.stop();
    if (!mounted) return;
    final selected = Set<int>.from(_session.selected);
    final elapsed = _elapsed.elapsed;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          score: _session.scorePercent(),
          answered: _session.foundCount(),
          total: GameConstants.englishErrorCount,
          elapsed: elapsed,
          onReplay: (context) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => const EnglishGameScreen(),
              ),
              (_) => false,
            );
          },
          english: EnglishRoundResult(
            found: _session.foundCount(),
            total: GameConstants.englishErrorCount,
            scorePercent: _session.scorePercent(),
            passage: _session.passage,
            selected: selected,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paused = _session.paused;
    final elapsed = GameConstants.englishRoundSeconds - _session.secondsLeft;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _togglePause,
                    icon: Icon(
                      paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      size: 32,
                    ),
                    tooltip: paused ? l10n.resume : l10n.pause,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: elapsed / GameConstants.englishRoundSeconds,
                        minHeight: 10,
                        backgroundColor: Colors.black12,
                        color: AppColors.answerBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.timer_outlined,
                    size: 20,
                    color: _warning ? Colors.red : Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_session.secondsLeft} s',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _warning ? Colors.red : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    _passageCard(l10n, paused),
                    if (paused)
                      Positioned.fill(
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: ColoredBox(
                              color: Colors.white.withValues(alpha: 0.45),
                              child: Center(
                                child: Text(
                                  l10n.pausedHint,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passageCard(AppLocalizations l10n, bool paused) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderGray),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.psychology_alt_rounded,
                color: AppColors.yellow,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.badgeEnglish,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: EnglishSelectableText(
                words: _session.words,
                selected: _session.selected,
                enabled: !paused && !_session.isFinished,
                onToggle: _toggleWord,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
