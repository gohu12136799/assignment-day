import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../game/logic_game_session.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import 'result_screen.dart';

/// Lượt Logic: ảnh đề, 6 ảnh đáp án, 10 giây. Chọn xong sang câu ngay.
class LogicGameScreen extends StatefulWidget {
  const LogicGameScreen({super.key, this.session});

  final LogicGameSession? session;

  @override
  State<LogicGameScreen> createState() => _LogicGameScreenState();
}

class _LogicGameScreenState extends State<LogicGameScreen> {
  late final LogicGameSession _session;
  Timer? _timer;
  final Stopwatch _elapsed = Stopwatch();

  bool get _warning => _session.secondsLeft <= 1;

  @override
  void initState() {
    super.initState();
    _session = widget.session ?? LogicGameSession();
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

  void _select(int optionIndex) {
    final finished = _session.select(optionIndex);
    if (!mounted) return;
    if (finished) {
      _finish();
      return;
    }
    setState(() {});
  }

  void _finish() {
    _timer?.cancel();
    _elapsed.stop();
    if (!mounted) return;
    final elapsed = _elapsed.elapsed;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          score: 0,
          answered: _session.answeredCount,
          total: _session.questions.length,
          elapsed: elapsed,
          onReplay: (context) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => const LogicGameScreen(),
              ),
              (_) => false,
            );
          },
          logic: LogicRoundResult(
            answered: _session.answeredCount,
            total: _session.questions.length,
            choices: _session.choices(),
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
    final question = _session.current;

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
                        value: _session.progress,
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
                  const SizedBox(width: 12),
                  Text(
                    '${_session.index + 1}/${_session.questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: _card(
                            child: Image.asset(
                              question.promptAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          flex: 6,
                          child: _card(
                            child: Column(
                              children: [
                                for (var row = 0; row < 2; row++) ...[
                                  if (row > 0) const SizedBox(height: 8),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        for (var col = 0; col < 3; col++) ...[
                                          if (col > 0) const SizedBox(width: 8),
                                          Expanded(
                                            child: FractionallySizedBox(
                                              widthFactor: 0.7,
                                              heightFactor: 0.7,
                                              child: _AnswerCell(
                                                letter: 'ABCDEF'[row * 3 + col],
                                                asset:
                                                    question.answerAssets[row *
                                                            3 +
                                                        col],
                                                selected:
                                                    _session.selectedIndex ==
                                                    row * 3 + col,
                                                enabled:
                                                    !paused &&
                                                    !_session.isFinished,
                                                onTap: () =>
                                                    _select(row * 3 + col),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (paused) _pauseCover(l10n),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
      child: child,
    );
  }

  Widget _pauseCover(AppLocalizations l10n) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
    );
  }
}

class _AnswerCell extends StatelessWidget {
  const _AnswerCell({
    required this.letter,
    required this.asset,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String letter;
  final String asset;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.answerBlue.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.answerBlue : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                letter,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: selected ? AppColors.answerBlue : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Expanded(child: Image.asset(asset, fit: BoxFit.contain)),
            ],
          ),
        ),
      ),
    );
  }
}
