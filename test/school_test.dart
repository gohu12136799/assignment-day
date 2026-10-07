import 'dart:math';

import 'package:assignment_day/models/play_topic.dart';
import 'package:assignment_day/school/attendance_store.dart';
import 'package:assignment_day/school/enrollment_store.dart';
import 'package:assignment_day/school/homeroom_teacher.dart';
import 'package:assignment_day/school/school_class.dart';
import 'package:assignment_day/school/school_reset.dart';
import 'package:assignment_day/school/school_rules.dart';
import 'package:assignment_day/theme/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SchoolRules', () {
    test('open 24 hours', () {
      expect(SchoolRules.isOpen(DateTime(2026, 10, 8)), isTrue);
      expect(SchoolRules.isOpen(DateTime(2026, 10, 8, 3, 57)), isTrue);
      expect(SchoolRules.isOpen(DateTime(2026, 10, 8, 23, 59)), isTrue);
    });

    test('below 5 punished, above 9 praised, otherwise encouraged', () {
      expect(verdictFor(4.5), TeacherVerdict.punish);
      expect(verdictFor(5), TeacherVerdict.encourage);
      expect(verdictFor(9), TeacherVerdict.encourage);
      expect(verdictFor(9.5), TeacherVerdict.praise);
      expect(verdictFor(10), TeacherVerdict.praise);
    });

    test('ten-point grade rounds to one decimal', () {
      expect(tenPointGrade(2, 3), 6.7);
      expect(tenPointGrade(19, 20), 9.5);
      expect(tenPointGrade(0, 0), 0);
    });
  });

  test('exercise wall is blue, yellow, or pink', () {
    expect(AppColors.classroomWalls, [
      AppColors.classroomBlue,
      AppColors.classroomYellow,
      AppColors.classroomPink,
    ]);
    final random = Random(0);
    for (var i = 0; i < 20; i++) {
      expect(
        AppColors.classroomWalls,
        contains(AppColors.randomClassroomWall(random)),
      );
    }
  });

  test('every class fits the 5-student limit with the player', () {
    for (final c in schoolClasses) {
      expect(
        c.classmates.length + 1,
        lessThanOrEqualTo(SchoolRules.maxStudents),
      );
    }
  });

  test('classmate check-in is stable and inside school hours', () {
    final day = DateTime(2026, 10, 8);
    for (final c in schoolClasses) {
      for (final name in c.classmates) {
        final time = classmateCheckInTime(name, day);
        expect(time, classmateCheckInTime(name, day));
        if (time != null) expect(SchoolRules.isOpen(time), isTrue);
      }
    }
  });

  test('leaving class clears the student record', () async {
    SharedPreferences.setMockInitialValues({});
    final enrollment = EnrollmentStore();
    await enrollment.enroll(PlayTopic.math, 'Na');
    await HomeroomStore(random: Random(0)).loadOrAssign();
    await AttendanceStore().checkIn(PlayTopic.math, DateTime(2026, 10, 8, 9));

    await resetSchoolProgress();

    expect(await enrollment.isComplete(), isFalse);
    expect(await HomeroomStore().load(), isNull);
    expect(
      await AttendanceStore().load(PlayTopic.math, DateTime(2026, 10, 8, 9)),
      isNull,
    );
  });

  test('homeroom teacher is assigned once and kept', () async {
    SharedPreferences.setMockInitialValues({});
    final store = HomeroomStore(random: Random(0));
    final first = await store.loadOrAssign();
    final again = await store.loadOrAssign();
    expect(again.id, first.id);
    expect(homeroomProfiles.map((profile) => profile.id), contains(first.id));
  });

  group('AttendanceStore', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test('check-in then grade, per class per day', () async {
      final store = AttendanceStore();
      final now = DateTime(2026, 10, 8, 9, 15);

      expect(await store.load(PlayTopic.math, now), isNull);

      final checkedIn = await store.checkIn(PlayTopic.math, now);
      expect(checkedIn.tested, isFalse);

      await store.saveGrade(PlayTopic.math, now, 8.5);
      final record = await store.load(PlayTopic.math, now);
      expect(record!.grade, 8.5);
      expect(record.checkedInAt, now);

      expect(await store.load(PlayTopic.logic, now), isNull);
      expect(
        await store.load(PlayTopic.math, DateTime(2026, 10, 9, 8)),
        isNull,
      );
    });
  });
}
