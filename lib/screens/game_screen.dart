import 'dart:async';

import 'package:flutter/material.dart';

import '../data/questions.dart';
import '../models/question.dart';
import 'result_screen.dart';

/// Màn chơi: StatefulWidget vì cần đổi UI khi chọn đáp án / hết giờ.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int roundSeconds = 60;

  late final List<Question> _questions;
  int _index = 0;
  int _score = 0;
  int _secondsLeft = roundSeconds;
  Timer? _timer;
  bool _locked = false;

  Question get _current => _questions[_index];

  @override
  void initState() {
    super.initState();
    // Xáo trộn nhẹ để mỗi lần chơi khác nhau một chút.
    _questions = List<Question>.from(sampleQuestions)..shuffle();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _finish();
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
  }

  void _answer(int optionIndex) {
    if (_locked) return;
    _locked = true;

    final isCorrect = optionIndex == _current.correctIndex;
    if (isCorrect) {
      setState(() => _score += 100);
    }

    Future<void>.delayed(const Duration(milliseconds: 350), () {
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
    // Luôn hủy Timer khi rời màn hình để tránh memory leak.
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _current;

    return Scaffold(
      appBar: AppBar(
        title: Text('${q.typeLabel} · ${_index + 1}/${_questions.length}'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '⏱ $_secondsLeft s',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _secondsLeft <= 10 ? Colors.red : null,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Điểm: $_score',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              q.prompt,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 28),
            ...List.generate(q.options.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton(
                  onPressed: _locked ? null : () => _answer(i),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(q.options[i]),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
