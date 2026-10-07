import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/play_topic.dart';
import '../../school/attendance_store.dart';
import '../../school/enrollment_store.dart';
import '../../school/homeroom_teacher.dart';
import '../../school/school_class.dart';
import '../../school/school_labels.dart';
import '../../school/school_rules.dart';
import '../../theme/app_colors.dart';
import '../../widgets/menu_row.dart';
import 'classroom_screen.dart';

/// Trường học Hoa Sen: danh sách lớp và trạng thái điểm danh hôm nay.
class SchoolScreen extends StatefulWidget {
  const SchoolScreen({
    super.key,
    this.clock = DateTime.now,
    this.store,
    this.enrollment,
  });

  final DateTime Function() clock;
  final AttendanceStore? store;
  final EnrollmentStore? enrollment;

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  late final AttendanceStore _store = widget.store ?? AttendanceStore();
  late final EnrollmentStore _enrollment =
      widget.enrollment ?? EnrollmentStore();
  Map<PlayTopic, ClassDayRecord?> _records = {};
  PlayTopic? _enrolled;
  HomeroomProfile? _teacher;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final today = widget.clock();
    final enrolled = await _enrollment.load();
    final teacher = await HomeroomStore().load();
    final records = <PlayTopic, ClassDayRecord?>{
      for (final c in schoolClasses) c.topic: await _store.load(c.topic, today),
    };
    if (!mounted) return;
    setState(() {
      _enrolled = enrolled;
      _teacher = teacher;
      _records = records;
    });
  }

  /// Lớp của con lên đầu. Chưa đăng ký lớp nào thì mở cả ba.
  List<SchoolClass> get _orderedClasses => [
    ...schoolClasses.where((c) => c.topic == _enrolled),
    ...schoolClasses.where((c) => c.topic != _enrolled),
  ];

  bool _isLocked(SchoolClass schoolClass) =>
      _enrolled != null && schoolClass.topic != _enrolled;

  void _showLocked(AppLocalizations l10n) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.classLockedHint)));
  }

  Future<void> _openClass(SchoolClass schoolClass) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClassroomScreen(
          schoolClass: schoolClass,
          clock: widget.clock,
          store: _store,
        ),
      ),
    );
    _load();
  }

  String _status(AppLocalizations l10n, ClassDayRecord? record) {
    if (record == null) return l10n.notCheckedIn;
    final grade = record.grade;
    if (grade == null) return l10n.checkedInNoTest;
    return l10n.todayGrade(formatGrade(context, grade));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final open = SchoolRules.isOpen(widget.clock());
    final openLabel = SchoolRules.hourLabel(SchoolRules.openHour);
    final closeLabel = SchoolRules.hourLabel(SchoolRules.closeHour);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.schoolName,
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _HoursBanner(
            open: open,
            hours: l10n.schoolHours(openLabel, closeLabel),
            message: open
                ? l10n.schoolOpenNow
                : l10n.schoolClosedNow(openLabel, closeLabel),
            teacherImage:
                _teacher?.portrait ?? 'assets/images/school/teacher_idle.jpg',
          ),
          const SizedBox(height: 16),
          for (final schoolClass in _orderedClasses) ...[
            if (_isLocked(schoolClass))
              Opacity(
                opacity: 0.6,
                child: MenuRow(
                  icon: Icons.lock_rounded,
                  label: classTitle(l10n, schoolClass.topic),
                  description: l10n.classNotEnrolled,
                  iconGradient: const [
                    AppColors.borderGray,
                    AppColors.borderGray,
                  ],
                  onTap: () => _showLocked(l10n),
                ),
              )
            else
              MenuRow(
                icon: classIcon(schoolClass.topic),
                label: classTitle(l10n, schoolClass.topic),
                description: [
                  if (schoolClass.topic == _enrolled) l10n.myClass,
                  if (_teacher != null) _teacher!.title(l10n),
                  _status(l10n, _records[schoolClass.topic]),
                ].join(' · '),
                iconGradient: classIconGradient(schoolClass.topic),
                onTap: () => _openClass(schoolClass),
              ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _HoursBanner extends StatelessWidget {
  const _HoursBanner({
    required this.open,
    required this.hours,
    required this.message,
    required this.teacherImage,
  });

  final bool open;
  final String hours;
  final String message;
  final String teacherImage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.bgBlue, AppColors.bgBlueLight],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(2, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                teacherImage,
                width: 64,
                height: 84,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        open
                            ? Icons.notifications_active_rounded
                            : Icons.nightlight_round,
                        color: AppColors.yellow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          hours,
                          style: const TextStyle(
                            color: AppColors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
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
