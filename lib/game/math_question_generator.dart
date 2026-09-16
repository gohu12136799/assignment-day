import 'dart:math';

import '../models/question.dart';
import 'game_constants.dart';

/// Sinh câu tính nhanh cho chủ đề Toán.
/// Luật nằm ở `.cursor/skills/math-question-generator/requirements.md`.
class MathQuestionGenerator {
  MathQuestionGenerator({Random? random}) : _random = random ?? Random();

  static const _ops = ['+', '-', '×', '÷'];
  static const _maxOperand = 29;
  static const _maxWrongDelta = 5;

  final Random _random;

  List<Question> generate() {
    final prompts = <String>{};
    final questions = <Question>[];
    var attempts = 0;
    while (questions.length < GameConstants.mathQuestionCount && attempts < 4000) {
      attempts += 1;
      final question = _tryOne();
      if (question == null || !prompts.add(question.prompt)) continue;
      questions.add(question);
    }
    if (questions.length < GameConstants.mathQuestionCount) {
      throw StateError('Could not generate a valid math round');
    }
    return questions;
  }

  Question? _tryOne() {
    final twoOps = _random.nextBool();
    final prompt = twoOps ? _twoOps() : _oneOp();
    if (prompt == null) return null;

    final answer = _valueOf(prompt);
    if (answer == null) return null;
    final options = _options(answer);
    if (options == null) return null;

    final question = Question(
      type: QuestionType.math,
      prompt: '$prompt = ?',
      options: options,
      correctIndex: options.indexOf('$answer'),
    );
    return _valid(question) ? question : null;
  }

  String? _oneOp() {
    final a = _operand();
    final b = _operand();
    final op = _ops[_random.nextInt(_ops.length)];
    if (_apply(a, op, b) == null) return null;
    return '$a $op $b';
  }

  String? _twoOps() {
    final a = _operand();
    final b = _operand();
    final c = _operand();
    final op1 = _ops[_random.nextInt(_ops.length)];
    final op2 = _ops[_random.nextInt(_ops.length)];
    final prompt = '$a $op1 $b $op2 $c';
    if (_valueOf(prompt) == null) return null;
    return prompt;
  }

  int _operand() => 1 + _random.nextInt(_maxOperand);

  List<String>? _options(int answer) {
    final wrong = <int>[];
    for (var delta = 1; delta <= _maxWrongDelta; delta++) {
      final low = answer - delta;
      final high = answer + delta;
      if (low >= 0) wrong.add(low);
      if (high <= 99) wrong.add(high);
    }
    if (wrong.length < 9) return null;
    wrong.shuffle(_random);
    final values = [...wrong.take(9), answer]..shuffle(_random);
    return values.map((value) => '$value').toList();
  }

  int? _valueOf(String body) {
    final parts = body.split(' ');
    if (parts.length == 3) {
      return _apply(_number(parts[0]), parts[1], _number(parts[2]));
    }
    if (parts.length != 5) return null;
    final a = _number(parts[0]);
    final op1 = parts[1];
    final b = _number(parts[2]);
    final op2 = parts[3];
    final c = _number(parts[4]);
    if (a == null || b == null || c == null) return null;
    if (!_ops.contains(op1) || !_ops.contains(op2)) return null;

    final op2First = _high(op2) && !_high(op1);
    if (op2First) {
      final right = _apply(b, op2, c);
      if (right == null) return null;
      return _apply(a, op1, right);
    }
    final left = _apply(a, op1, b);
    if (left == null) return null;
    return _apply(left, op2, c);
  }

  bool _high(String op) => op == '×' || op == '÷';

  int? _number(String raw) => int.tryParse(raw);

  int? _apply(int? left, String op, int? right) {
    if (left == null || right == null || !_ops.contains(op)) return null;
    switch (op) {
      case '+':
        return left + right;
      case '-':
        final value = left - right;
        return value < 0 ? null : value;
      case '×':
        return left * right;
      case '÷':
        if (right == 0 || left % right != 0) return null;
        return left ~/ right;
    }
    return null;
  }

  bool _valid(Question question) {
    if (question.type != QuestionType.math) return false;
    if (!question.prompt.endsWith(' = ?')) return false;
    final body = question.prompt.replaceFirst(' = ?', '');
    final parts = body.split(' ');
    if (parts.length != 3 && parts.length != 5) return false;
    final opCount = parts.where(_ops.contains).length;
    if (opCount < 1 || opCount > 2) return false;
    for (var i = 0; i < parts.length; i += 2) {
      final operand = int.tryParse(parts[i]);
      if (operand == null || operand < 1 || operand > _maxOperand) return false;
    }

    final answer = _valueOf(body);
    if (answer == null || answer < 0 || answer >= 100) return false;
    if (question.options.length != 10) return false;
    if (question.correctIndex < 0 ||
        question.correctIndex >= question.options.length) {
      return false;
    }

    final values = <int>[];
    for (final option in question.options) {
      final value = int.tryParse(option);
      if (value == null || value < 0 || value > 99) return false;
      values.add(value);
    }
    if (values.toSet().length != 10) return false;
    if (values[question.correctIndex] != answer) return false;

    var wrong = 0;
    for (var i = 0; i < values.length; i++) {
      if (i == question.correctIndex) continue;
      final delta = (values[i] - answer).abs();
      if (delta < 1 || delta > _maxWrongDelta) return false;
      wrong += 1;
    }
    return wrong == 9;
  }
}
