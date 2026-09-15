import 'dart:async';

import 'package:flutter/material.dart';

import '../data/questions.dart';
import '../l10n/app_localizations.dart';
import '../models/play_topic.dart';
import '../models/question.dart';
import 'result_screen.dart';

/// Màn test / chơi.
/// Học: play/pause điều khiển Timer; progress theo câu hỏi hiện tại.
class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    this.topic = PlayTopic.mixed,
  });

  final PlayTopic topic;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int roundSeconds = 60;

  /// Màu 4 đáp án A B C D.
  static const _optionColors = <Color>[
    Color(0xFF1976D2), // A xanh dương
    Color(0xFF43A047), // B xanh lá
    Color(0xFFFDD835), // C vàng
    Color(0xFF8E24AA), // D tím
  ];

  late final List<Question> _questions;
  int _index = 0;
  int _score = 0;
  int _secondsLeft = roundSeconds;
  Timer? _timer;
  bool _locked = false;
  bool _paused = false;

  Question get _current => _questions[_index];

  double get _progress =>
      _questions.isEmpty ? 0 : (_index + 1) / _questions.length;

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
    _questions = _buildQuestions(widget.topic)..shuffle();
    // Nếu lọc ra rỗng (bank thiếu câu) → dùng toàn bộ để app không crash.
    if (_questions.isEmpty) {
      _questions.addAll(List<Question>.from(sampleQuestions)..shuffle());
    }
    _startTimer();
  }

  List<Question> _buildQuestions(PlayTopic topic) {
    final all = List<Question>.from(sampleQuestions);
    switch (topic) {
      case PlayTopic.math:
        return all.where((q) => q.type == QuestionType.math).toList();
      case PlayTopic.logic:
        return all.where((q) => q.type == QuestionType.logic).toList();
      case PlayTopic.english:
        return all.where((q) => q.type == QuestionType.english).toList();
      case PlayTopic.mixed:
      case PlayTopic.random:
        return all;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_paused || _locked) return;
      if (_secondsLeft <= 1) {
        _finish();
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _answer(int optionIndex) {
    if (_locked || _paused) return;
    _locked = true;

    final isCorrect = optionIndex == _current.correctIndex;
    if (isCorrect) {
      setState(() => _score += 100);
    } else {
      setState(() {}); // rebuild nếu sau này tô màu đúng/sai
    }

    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      if (_index >= _questions.length - 1) {
        _finish();
        return;
      }
      setState(() {
        _index += 1;
        _locked = false;
      });
    });
  }

  void _finish() {
    _timer?.cancel();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ResultScreen(
          score: _score,
          answered: _index + (_locked ? 1 : 0),
          total: _questions.length,
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
    final q = _current;
    final letters = ['A', 'B', 'C', 'D'];
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
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
                      _paused
                          ? Icons.play_arrow_rounded
                          : Icons.pause_rounded,
                      size: 32,
                    ),
                    tooltip: _paused ? l10n.resume : l10n.pause,
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress,
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
                        color: _secondsLeft <= 10 ? Colors.red : Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_secondsLeft s',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color:
                              _secondsLeft <= 10 ? Colors.red : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Câu hỏi / tổng
                  Text(
                    '${_index + 1}/${_questions.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              if (_paused) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.pausedHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
              const SizedBox(height: 20),

              // --- CARD CÂU HỎI ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBEBEBE)),
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
                          color: Color(0xFFFFC107),
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
                      q.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- 4 ĐÁP ÁN A B C D ---
              Expanded(
                child: ListView.separated(
                  itemCount: q.options.length.clamp(0, 4),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final bg = _optionColors[i % _optionColors.length];
                    final isLight = bg == _optionColors[2]; // vàng → chữ đen
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: (_locked || _paused)
                            ? null
                            : () => _answer(i),
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(12),
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
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.9,
                                  ),
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
                                    q.options[i],
                                    style: TextStyle(
                                      color: isLight
                                          ? Colors.black87
                                          : Colors.white,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
