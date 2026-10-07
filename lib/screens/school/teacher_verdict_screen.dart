import 'dart:async';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/play_topic.dart';
import '../../school/candy_store.dart';
import '../../school/school_class.dart';
import '../../school/school_labels.dart';
import '../../school/school_rules.dart';
import '../../theme/app_colors.dart';
import 'reward_dialogs.dart';

/// Cô chủ nhiệm nhận xét bài kiểm tra: khen (> 9), khẽ tay (< 5), hoặc động viên.
class TeacherVerdictScreen extends StatefulWidget {
  const TeacherVerdictScreen({
    super.key,
    required this.schoolClass,
    required this.grade,
    this.teacherAsset,
    this.teacherLabel,
    this.teacherMale = false,
    this.day,
    this.candy,
  });

  final SchoolClass schoolClass;
  final double grade;

  /// Ảnh và tên thầy cô chủ nhiệm đã gán. Không có thì dùng cảnh cô mặc định.
  final String? teacherAsset;
  final String? teacherLabel;
  final bool teacherMale;
  final DateTime? day;
  final CandyStore? candy;

  @override
  State<TeacherVerdictScreen> createState() => _TeacherVerdictScreenState();
}

class _TeacherVerdictScreenState extends State<TeacherVerdictScreen> {
  late final CandyStore _candy = widget.candy ?? CandyStore();
  late final DateTime _day = widget.day ?? DateTime.now();
  String? _reply;
  String? _reactionImage;
  Timer? _typing;
  int _shown = 0;
  bool _asked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _afterOpen());
  }

  @override
  void dispose() {
    _typing?.cancel();
    super.dispose();
  }

  Future<void> _afterOpen() async {
    final verdict = verdictFor(widget.grade);
    if (verdict == TeacherVerdict.praise) {
      final added = await _candy.awardHighScore(_topic, _day);
      if (!mounted || added == 0) return;
      await showCandyGiftDialog(context, praise: true, store: _candy);
      return;
    }
    if (verdict != TeacherVerdict.punish || !mounted) return;
    final line = _punishLine(AppLocalizations.of(context)!);
    _typing?.cancel();
    _typing = Timer.periodic(const Duration(milliseconds: 45), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_shown >= line.characters.length) {
        timer.cancel();
        _askReaction();
        return;
      }
      setState(() => _shown++);
    });
  }

  String _punishLine(AppLocalizations l10n) =>
      widget.teacherMale ? l10n.verdictPunishBodyMale : l10n.verdictPunishBody;

  Future<void> _askReaction() async {
    if (_asked || !mounted) return;
    _asked = true;
    final choice = await showReactionDialog(context, male: widget.teacherMale);
    if (!mounted || choice == null) return;
    setState(() {
      _reactionImage = reactionScene(choice.reaction);
      _reply = reactionReply(
        AppLocalizations.of(context)!,
        widget.teacherMale,
        choice,
      );
    });
  }

  PlayTopic get _topic => widget.schoolClass.topic;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final grade = widget.grade;
    final teacherMale = widget.teacherMale;
    final teacherAsset = widget.teacherAsset;
    final schoolClass = widget.schoolClass;
    final verdict = verdictFor(grade);
    final (image, title, body, accent) = switch (verdict) {
      TeacherVerdict.praise => (
        teacherAsset ?? 'assets/images/school/teacher_praise.jpg',
        teacherMale ? l10n.verdictPraiseTitleMale : l10n.verdictPraiseTitle,
        teacherMale ? l10n.verdictPraiseBodyMale : l10n.verdictPraiseBody,
        AppColors.yellow,
      ),
      TeacherVerdict.punish => (
        _reactionImage ?? 'assets/images/school/teacher_ruler.jpg',
        teacherMale ? l10n.verdictPunishTitleMale : l10n.verdictPunishTitle,
        _punishLine(l10n).characters.take(_shown).toString(),
        AppColors.redIconGradient.last,
      ),
      TeacherVerdict.encourage => (
        teacherAsset ?? 'assets/images/school/teacher_encourage.jpg',
        teacherMale
            ? l10n.verdictEncourageTitleMale
            : l10n.verdictEncourageTitle,
        teacherMale ? l10n.verdictEncourageBodyMale : l10n.verdictEncourageBody,
        AppColors.greenIconGradient.last,
      ),
    };
    final teacherLine =
        widget.teacherLabel ?? l10n.teacherName(schoolClass.teacherName);

    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '${classTitle(l10n, schoolClass.topic)} · $teacherLine',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.6, end: 1),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.elasticOut,
                      builder: (context, scale, child) =>
                          Transform.scale(scale: scale, child: child),
                      child: _Scene(image: image, accent: accent),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: _GradeBadge(
                        label: l10n.gradeOutOfTen(formatGrade(context, grade)),
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      body,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    if (_reply != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _reply!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.yellow,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.meeting_room_rounded, size: 28),
                label: Text(l10n.backToClass),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.bgBlueDeep,
                  minimumSize: const Size(double.infinity, 60),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Scene extends StatelessWidget {
  const _Scene({required this.image, required this.accent});

  final String image;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(2, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.asset(image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.bgBlueDeep,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
