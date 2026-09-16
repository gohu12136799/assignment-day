import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../game/game_session.dart';
import '../l10n/app_localizations.dart';
import '../models/play_topic.dart';
import '../models/question.dart';
import '../theme/app_colors.dart';
import '../widgets/math_answer_scatter.dart';
import 'result_screen.dart';

/// Màn test / chơi.
/// Học: play/pause điều khiển Timer; progress theo câu hỏi hiện tại.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.topic = PlayTopic.mixed});

  final PlayTopic topic;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameSession _session;
  Timer? _timer;
  final Stopwatch _elapsed = Stopwatch();

  bool get _warning => _session.secondsLeft <= 1;

  String _badgeLabel(AppLocalizations l10n) => switch (widget.topic) {
    PlayTopic.math => l10n.badgeQuickMath,
    PlayTopic.logic => l10n.badgeLogic,
    PlayTopic.english => l10n.badgeEnglish,
    PlayTopic.mixed => l10n.badgeMixed,
    PlayTopic.random => l10n.badgeRandom,
  };

  @override
  void initState() {
    super.initState();
    _session = GameSession(topic: widget.topic);
    _elapsed.start();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
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
    final topic = widget.topic;
    final elapsed = _elapsed.elapsed;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          score: _session.grade(),
          answered: _session.answeredCount,
          total: _session.questions.length,
          elapsed: elapsed,
          onReplay: (context) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => GameScreen(topic: topic),
              ),
              (_) => false,
            );
          },
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
    final q = _session.current;
    final l10n = AppLocalizations.of(context)!;
    final paused = _session.paused;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- HEADER ---
              // play/pause + progress | countdown | câu hiện tại/tổng
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
                        color: const Color(0xFF1976D2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Đồng hồ countdown
                  Row(
                    children: [
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
                  const SizedBox(width: 12),
                  // Câu hỏi / tổng
                  Text(
                    '${_session.index + 1}/${_session.questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _questionCard(q.prompt, l10n),
                        const SizedBox(height: 24),
                        Expanded(child: _answers(q, paused)),
                      ],
                    ),
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

  Widget _questionCard(String prompt, AppLocalizations l10n) {
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
                          _badgeLabel(l10n),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _answers(Question q, bool paused) {
    if (widget.topic == PlayTopic.math) {
      return MathAnswerScatter(
        key: ValueKey(_session.index),
        options: q.options,
        enabled: !paused,
        onSelect: _select,
      );
    }
    return _AnswerColumn(
      options: q.options,
      paused: paused,
      selectedIndex: _session.selectedIndex,
      onSelect: _select,
    );
  }
}

class _AnswerColumn extends StatelessWidget {
  const _AnswerColumn({
    required this.options,
    required this.paused,
    required this.selectedIndex,
    required this.onSelect,
  });


  final List<String> options;
  final bool paused;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const letters = ['A', 'B', 'C', 'D'];
    return ListView.separated(
      itemCount: options.length.clamp(0, 4),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final bg = AppColors.answerColors[i % AppColors.answerColors.length];
        final isLight = bg == AppColors.answerYellow;
        final selected = selectedIndex == i;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: paused ? null : () => onSelect(i),
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? (isLight ? AppColors.bgBlueDeep : Colors.white)
                      : Colors.transparent,
                  width: 3,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      child: Text(
                        letters[i],
                        style: TextStyle(
                          color: bg,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        options[i],
                        style: TextStyle(
                          color: isLight ? Colors.black87 : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
