import 'package:flutter/material.dart';

import '../../auth/auth_scope.dart';
import '../../l10n/app_localizations.dart';
import '../../models/play_topic.dart';
import '../../school/attendance_store.dart';
import '../../school/candy_store.dart';
import '../../school/enrollment_store.dart';
import '../../school/homeroom_teacher.dart';
import '../../school/school_class.dart';
import '../../school/school_labels.dart';
import '../../school/school_rules.dart';
import '../../theme/app_colors.dart';
import '../english_game_screen.dart';
import '../game_screen.dart';
import '../logic_game_screen.dart';
import 'punish_intro_screen.dart';
import 'reward_dialogs.dart';
import 'teacher_verdict_screen.dart';

/// Một lớp: cô chủ nhiệm, sĩ số, điểm danh rồi làm bài kiểm tra.
class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({
    super.key,
    required this.schoolClass,
    this.clock = DateTime.now,
    this.store,
    this.candy,
  });

  final SchoolClass schoolClass;
  final DateTime Function() clock;
  final AttendanceStore? store;
  final CandyStore? candy;

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  late final AttendanceStore _store = widget.store ?? AttendanceStore();
  late final CandyStore _candy = widget.candy ?? CandyStore();
  ClassDayRecord? _record;
  String? _studentName;
  HomeroomProfile? _teacher;
  bool _loading = true;
  bool _busy = false;

  PlayTopic get _topic => widget.schoolClass.topic;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final record = await _store.load(_topic, widget.clock());
    final name = await EnrollmentStore().studentName();
    final teacher = await HomeroomStore().loadOrAssign();
    if (!mounted) return;
    setState(() {
      _record = record;
      _studentName = name;
      _teacher = teacher;
      _loading = false;
    });
  }

  Future<void> _checkIn() async {
    setState(() => _busy = true);
    final record = await _store.checkIn(_topic, widget.clock());
    if (!mounted) return;
    setState(() {
      _record = record;
      _busy = false;
    });
    await grantDailyCandy(context, widget.clock(), store: _candy);
  }

  Widget _testScreen() => switch (_topic) {
    PlayTopic.english => const EnglishGameScreen(classTest: true),
    PlayTopic.logic => const LogicGameScreen(classTest: true),
    _ => GameScreen(topic: _topic, classTest: true),
  };

  Future<void> _startTest() async {
    setState(() => _busy = true);
    final day = widget.clock();
    // Thoát giữa chừng vẫn bị tính 0 điểm.
    await _store.saveGrade(_topic, day, 0);
    if (!mounted) return;
    final grade = await Navigator.of(context)
        .push<double>(MaterialPageRoute<double>(builder: (_) => _testScreen()));
    final record = await _store.saveGrade(_topic, day, grade ?? 0);
    if (!mounted) return;
    setState(() {
      _record = record;
      _busy = false;
    });
    _openVerdict(record.grade!);
  }

  void _openVerdict(double grade) {
    final teacher = _teacher;
    final l10n = AppLocalizations.of(context)!;
    final studentName =
        _studentName ?? AuthScope.of(context).displayName(l10n.playerName);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => verdictOrPunishIntro(
          studentName: studentName,
          verdict: TeacherVerdictScreen(
            schoolClass: widget.schoolClass,
            grade: grade,
            teacherAsset: teacher?.portrait,
            teacherLabel: teacher?.title(l10n),
            teacherMale: teacher?.male ?? false,
            day: widget.clock(),
            candy: _candy,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = widget.clock();
    final schoolClass = widget.schoolClass;
    final playerName =
        _studentName ?? AuthScope.of(context).displayName(l10n.playerName);
    final playerCheckIn = _record?.checkedInAt;

    final students = <({String name, DateTime? checkedInAt, bool isPlayer})>[
      (
        name: l10n.studentYou(playerName),
        checkedInAt: playerCheckIn,
        isPlayer: true,
      ),
      for (final name in schoolClass.classmates.take(
        SchoolRules.maxStudents - 1,
      ))
        (
          name: name,
          checkedInAt: _presentBy(classmateCheckInTime(name, now), now),
          isPlayer: false,
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
          classTitle(l10n, _topic),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _TeacherCard(
                      name:
                          _teacher?.title(l10n) ??
                          l10n.teacherName(schoolClass.teacherName),
                      role: l10n.homeroomTeacher,
                      rules: _teacher?.male == true
                          ? l10n.classRulesMale
                          : l10n.classRules,
                      image:
                          _teacher?.portrait ??
                          'assets/images/school/teacher_idle.jpg',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.classSize(students.length, SchoolRules.maxStudents),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final student in students) ...[
                      _StudentTile(
                        name: student.name,
                        isPlayer: student.isPlayer,
                        status: student.checkedInAt == null
                            ? l10n.notArrived
                            : l10n.presentAt(formatClock(student.checkedInAt!)),
                        present: student.checkedInAt != null,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (!_loading) _buildAction(l10n, now),
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _presentBy(DateTime? checkIn, DateTime now) {
    if (checkIn == null || checkIn.isAfter(now)) return null;
    return checkIn;
  }

  Widget _buildAction(AppLocalizations l10n, DateTime now) {
    final record = _record;
    final grade = record?.grade;
    if (grade != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${l10n.todayGrade(formatGrade(context, grade))}. ${l10n.testDoneToday}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 12),
          _ActionButton(
            icon: Icons.record_voice_over_rounded,
            label: l10n.seeTeacherComment,
            onPressed: () => _openVerdict(grade),
          ),
        ],
      );
    }
    if (!SchoolRules.isOpen(now)) {
      return _ActionButton(
        icon: Icons.lock_clock_rounded,
        label: l10n.schoolClosedAction,
        onPressed: null,
      );
    }
    if (record == null) {
      return _ActionButton(
        icon: Icons.how_to_reg_rounded,
        label: l10n.checkIn,
        onPressed: _busy ? null : _checkIn,
      );
    }
    return _ActionButton(
      icon: Icons.edit_note_rounded,
      label: l10n.startTest,
      onPressed: _busy ? null : _startTest,
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    required this.name,
    required this.role,
    required this.rules,
    required this.image,
  });

  final String name;
  final String role;
  final String rules;
  final String image;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 96,
                height: 128,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      color: AppColors.bgBlueLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rules,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  const _StudentTile({
    required this.name,
    required this.isPlayer,
    required this.status,
    required this.present,
  });

  final String name;
  final bool isPlayer;
  final String status;
  final bool present;

  @override
  Widget build(BuildContext context) {
    final initial = name.characters.first.toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPlayer ? AppColors.yellow : AppColors.borderGray,
          width: isPlayer ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isPlayer ? AppColors.yellow : AppColors.bgBlue,
              foregroundColor: isPlayer ? AppColors.bgBlueDeep : Colors.white,
              child: Text(
                initial,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              present ? Icons.check_circle_rounded : Icons.schedule_rounded,
              size: 18,
              color: present
                  ? AppColors.greenIconGradient.last
                  : Colors.black38,
            ),
            const SizedBox(width: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 13,
                color: present ? Colors.black87 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 26),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.bgBlueDeep,
        minimumSize: const Size(double.infinity, 60),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
    );
  }
}
