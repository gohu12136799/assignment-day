import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/play_topic.dart';
import '../../school/attendance_store.dart';
import '../../school/candy_store.dart';
import '../../school/enrollment_store.dart';
import '../../school/homeroom_teacher.dart';
import '../../school/school_class.dart';
import '../../theme/app_colors.dart';
import '../english_game_screen.dart';
import '../game_screen.dart';
import '../logic_game_screen.dart';
import 'punish_intro_screen.dart';
import 'reward_dialogs.dart';
import 'school_screen.dart';
import 'teacher_verdict_screen.dart';

enum _Step { ask, welcome, start }

/// Vào lớp: thầy cô hỏi tên, các bạn chào đón, rồi bắt đầu bài kiểm tra.
class ClassEntryScreen extends StatefulWidget {
  const ClassEntryScreen({
    super.key,
    this.homeroom,
    this.enrollment,
    this.attendance,
    this.candy,
    this.clock = DateTime.now,
  });

  final HomeroomStore? homeroom;
  final EnrollmentStore? enrollment;
  final AttendanceStore? attendance;
  final CandyStore? candy;
  final DateTime Function() clock;

  @override
  State<ClassEntryScreen> createState() => _ClassEntryScreenState();
}

class _ClassEntryScreenState extends State<ClassEntryScreen> {
  static const _welcomeHold = Duration(milliseconds: 2200);

  late final HomeroomStore _homeroom = widget.homeroom ?? HomeroomStore();
  late final EnrollmentStore _enrollment =
      widget.enrollment ?? EnrollmentStore();
  late final AttendanceStore _attendance =
      widget.attendance ?? AttendanceStore();
  late final CandyStore _candy = widget.candy ?? CandyStore();

  final _name = TextEditingController();
  Timer? _welcomeTimer;
  HomeroomProfile? _teacher;
  PlayTopic? _topic;
  _Step _step = _Step.ask;
  String? _error;
  bool _ready = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final teacher = await _homeroom.loadOrAssign();
    final topic = await _enrollment.load();
    final name = await _enrollment.studentName();
    final introDone = await _homeroom.introDone();
    if (!mounted) return;
    if (name != null) _name.text = name;
    setState(() {
      _teacher = teacher;
      _topic = topic;
      _step = introDone ? _Step.start : _Step.ask;
      _ready = true;
    });
  }

  Future<void> _answer() async {
    final name = _name.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (name.isEmpty) {
      setState(() => _error = l10n.enrollNameEmpty);
      return;
    }
    await _enrollment.saveStudentName(name);
    if (!mounted) return;
    setState(() {
      _error = null;
      _step = _Step.welcome;
    });
    _welcomeTimer?.cancel();
    _welcomeTimer = Timer(_welcomeHold, () {
      if (!mounted || _step != _Step.welcome) return;
      setState(() => _step = _Step.start);
    });
  }

  void _skipWelcome() {
    if (_step != _Step.welcome) return;
    _welcomeTimer?.cancel();
    setState(() => _step = _Step.start);
  }

  Widget _testScreen(PlayTopic topic) => switch (topic) {
    PlayTopic.english => const EnglishGameScreen(classTest: true),
    PlayTopic.logic => const LogicGameScreen(classTest: true),
    _ => GameScreen(topic: topic, classTest: true),
  };

  SchoolClass? _schoolClass(PlayTopic topic) {
    for (final schoolClass in schoolClasses) {
      if (schoolClass.topic == topic) return schoolClass;
    }
    return null;
  }

  Future<void> _startTest() async {
    final topic = _topic;
    final teacher = _teacher;
    if (topic == null || teacher == null) {
      await Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const SchoolScreen()));
      return;
    }
    final schoolClass = _schoolClass(topic);
    if (schoolClass == null) return;
    setState(() => _busy = true);
    await _homeroom.markIntroDone();
    final day = widget.clock();
    await _attendance.checkIn(topic, day);
    if (!mounted) return;
    await grantDailyCandy(context, day, store: _candy);
    if (!mounted) return;
    await _attendance.saveGrade(topic, day, 0);
    if (!mounted) return;
    final grade = await Navigator.of(context).push<double>(
      MaterialPageRoute<double>(builder: (_) => _testScreen(topic)),
    );
    final record = await _attendance.saveGrade(topic, day, grade ?? 0);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final studentName = _name.text.trim().isEmpty
        ? l10n.playerName
        : _name.text.trim();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => verdictOrPunishIntro(
          studentName: studentName,
          verdict: TeacherVerdictScreen(
            schoolClass: schoolClass,
            grade: record.grade ?? 0,
            teacherAsset: teacher.portrait,
            teacherLabel: teacher.title(l10n),
            teacherMale: teacher.male,
            day: day,
            candy: _candy,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _welcomeTimer?.cancel();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final teacher = _teacher;
    final studentName = _name.text.trim();
    final scene = teacher == null
        ? null
        : _step == _Step.ask
        ? teacher.enterScene
        : teacher.seatScene;

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
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      teacher?.title(l10n) ?? l10n.homeroomTeacher,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              Expanded(
                child: scene == null
                    ? const SizedBox.shrink()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(scene, fit: BoxFit.cover),
                      ),
              ),
              const SizedBox(height: 16),
              if (_ready && teacher != null)
                GestureDetector(
                  onTap: _skipWelcome,
                  child: _LineCard(
                    child: switch (_step) {
                      _Step.ask => _AskName(
                        controller: _name,
                        error: _error,
                        onSubmit: _busy ? null : _answer,
                      ),
                      _Step.welcome => Text(
                        teacher.welcome(
                          l10n,
                          studentName.isEmpty ? l10n.playerName : studentName,
                        ),
                        textAlign: TextAlign.center,
                        style: _lineStyle,
                      ),
                      _Step.start => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.classStartTest,
                            textAlign: TextAlign.center,
                            style: _lineStyle,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _busy ? null : _startTest,
                            style: _buttonStyle,
                            child: Text(l10n.classStartButton),
                          ),
                        ],
                      ),
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

const _lineStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

final _buttonStyle = FilledButton.styleFrom(
  backgroundColor: AppColors.yellow,
  foregroundColor: AppColors.bgBlueDeep,
  minimumSize: const Size(double.infinity, 52),
  shape: const StadiumBorder(),
  textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
);

class _LineCard extends StatelessWidget {
  const _LineCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgBlueDeep.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: child,
      ),
    );
  }
}

class _AskName extends StatelessWidget {
  const _AskName({
    required this.controller,
    required this.error,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final String? error;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.classAskName, textAlign: TextAlign.center, style: _lineStyle),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          autofocus: true,
          maxLength: 24,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit?.call(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: l10n.enrollNameHint,
            errorText: error,
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: onSubmit,
          style: _buttonStyle,
          child: Text(l10n.classAnswer),
        ),
      ],
    );
  }
}
