import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../school/school_labels.dart';
import '../../school/school_rules.dart';
import '../../theme/app_colors.dart';
import 'teacher_verdict_screen.dart';

/// Bài dưới 5 điểm thì xem điểm trước, rồi mới vào màn phạt.
Widget verdictOrPunishIntro({
  required String studentName,
  required TeacherVerdictScreen verdict,
}) {
  if (verdictFor(verdict.grade) != TeacherVerdict.punish) return verdict;
  return PunishIntroScreen(
    studentName: studentName,
    grade: verdict.grade,
    next: verdict,
  );
}

/// Điểm của em, trước khi vào màn cô phạt.
class PunishIntroScreen extends StatelessWidget {
  const PunishIntroScreen({
    super.key,
    required this.studentName,
    required this.grade,
    required this.next,
  });

  final String studentName;
  final double grade;
  final Widget next;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.schoolCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              const Spacer(),
              Text(
                l10n.scoreResult(studentName, formatGrade(context, grade)),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.bgBlueDeep,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 168,
                height: 168,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(builder: (_) => next),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.bgBlueDeep,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Text(l10n.goToPunish, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
