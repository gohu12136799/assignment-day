import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../models/play_topic.dart';
import '../../school/enrollment_store.dart';
import '../../school/school_class.dart';
import '../../school/school_labels.dart';
import '../../theme/app_colors.dart';
import '../../widgets/menu_row.dart';
import '../auth/auth_hub_screen.dart';
import '../home_screen.dart';
import '../../auth/auth_scope.dart';

/// Lần đầu mở app: cô chào mẹ, phụ đề chạy chữ, xong thì mẹ chọn lớp cho con.
class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key, this.store});

  final EnrollmentStore? store;

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

enum _Step { greet, askName, welcome }

class _EnrollmentScreenState extends State<EnrollmentScreen>
    with SingleTickerProviderStateMixin {
  static const _typeDelay = Duration(milliseconds: 600);
  static const _charInterval = Duration(milliseconds: 55);
  static const _popupDelay = Duration(milliseconds: 500);
  static const _welcomeHold = Duration(milliseconds: 1600);

  late final EnrollmentStore _store = widget.store ?? EnrollmentStore();

  /// 0 → 1: đứng, cúi chào + cười, đứng thẳng lại (vẫn cười).
  late final AnimationController _greet = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  Timer? _typing;
  int _shown = 0;
  bool _popupOpen = false;
  bool _left = false;
  _Step _step = _Step.greet;
  PlayTopic? _topic;
  String? _studentName;

  @override
  void initState() {
    super.initState();
    _greet.forward();
    _typing = Timer(_typeDelay, _startTyping);
  }

  String _fullLine(AppLocalizations l10n) => switch (_step) {
    _Step.greet => l10n.enrollGreeting,
    _Step.askName => l10n.enrollAskName,
    _Step.welcome => l10n.enrollWelcome(
      _studentName!,
      classTitle(l10n, _topic!),
    ),
  };

  List<String> _chars(BuildContext context) =>
      _fullLine(AppLocalizations.of(context)!).characters.toList();

  void _startTyping() {
    _typing = Timer.periodic(_charInterval, (timer) {
      if (!mounted) return;
      if (_shown >= _chars(context).length) {
        timer.cancel();
        _scheduleAfterLine();
        return;
      }
      setState(() => _shown += 1);
    });
  }

  void _scheduleAfterLine() {
    final delay = _step == _Step.welcome ? _welcomeHold : _popupDelay;
    _typing = Timer(delay, _followUp);
  }

  void _followUp() {
    switch (_step) {
      case _Step.greet:
        _showClassPicker();
      case _Step.askName:
        _showNameDialog();
      case _Step.welcome:
        _goHome();
    }
  }

  void _beginLine() {
    _typing?.cancel();
    setState(() => _shown = 0);
    _typing = Timer(_typeDelay, _startTyping);
  }

  /// Chạm màn hình thì hiện hết chữ ngay. Cảnh dắt vào lớp thì vào game luôn.
  void _skipTyping() {
    if (_popupOpen) return;
    final total = _chars(context).length;
    if (_shown >= total) {
      if (_step == _Step.welcome) _goHome();
      return;
    }
    _typing?.cancel();
    setState(() => _shown = total);
    _scheduleAfterLine();
  }

  Future<void> _showClassPicker() async {
    if (!mounted || _popupOpen || _topic != null) return;
    _popupOpen = true;
    final topic = await showDialog<PlayTopic>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ClassPickerDialog(),
    );
    if (topic == null || !mounted) return;
    setState(() {
      _topic = topic;
      _step = _Step.askName;
      _popupOpen = false;
    });
    _beginLine();
  }

  Future<void> _showNameDialog() async {
    if (!mounted || _popupOpen || _studentName != null) return;
    _popupOpen = true;
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _NameDialog(),
    );
    if (name == null || !mounted || _topic == null) return;
    await _store.enroll(_topic!, name);
    if (!mounted) return;
    setState(() {
      _studentName = name;
      _step = _Step.welcome;
      _popupOpen = false;
    });
    _beginLine();
  }

  void _goHome() {
    if (!mounted || _left) return;
    _left = true;
    _typing?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _typing?.cancel();
    _greet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final full = _fullLine(l10n);
    final chars = full.characters.toList();

    return Scaffold(
      backgroundColor: AppColors.schoolCream,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _skipTyping,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.schoolName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.bgBlueDeep,
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: _step == _Step.welcome
                      ? Image.asset(
                          'assets/images/school/teacher_lead.jpg',
                          fit: BoxFit.contain,
                        )
                      : AnimatedBuilder(
                          animation: _greet,
                          builder: (context, _) =>
                              _GreetingTeacher(progress: _greet.value),
                        ),
                ),
                const SizedBox(height: 16),
                _Subtitle(full: full, shown: chars.take(_shown).join()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Ảnh cô chính diện. Cúi người bằng cách nghiêng quanh chân,
/// cười bằng cách mờ dần sang ảnh mặt cười cùng khung hình.
class _GreetingTeacher extends StatelessWidget {
  const _GreetingTeacher({required this.progress});

  final double progress;

  static const _maxBowRadians = 0.15;
  static const _maxBowSquash = 0.2;

  double get _bow {
    const start = 0.2, end = 0.8;
    if (progress <= start || progress >= end) return 0;
    return math.sin(math.pi * (progress - start) / (end - start));
  }

  double get _smile => ((progress - 0.25) / 0.2).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    // Đầu hạ xuống (co theo chiều dọc) và hơi chúi về phía người xem.
    final transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0012)
      ..scaleByDouble(1, 1 - _maxBowSquash * _bow, 1, 1)
      ..rotateX(_maxBowRadians * _bow);

    return ClipRect(
      child: Transform(
        alignment: Alignment.bottomCenter,
        transform: transform,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/school/teacher_front.jpg',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
            ),
            Opacity(
              opacity: _smile,
              child: Image.asset(
                'assets/images/school/teacher_front_smile.jpg',
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Phụ đề kiểu phim. Giữ sẵn chỗ cho cả câu để khung không nhảy khi chạy chữ.
class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.full, required this.shown});

  final String full;
  final String shown;

  static const _style = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgBlueDeep.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Stack(
          children: [
            Text(
              full,
              textAlign: TextAlign.center,
              style: _style.copyWith(color: Colors.transparent),
            ),
            Positioned.fill(
              child: Text(shown, textAlign: TextAlign.center, style: _style),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameDialog extends StatefulWidget {
  const _NameDialog();

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  final _name = TextEditingController();
  String? _error;
  bool _writing = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = AppLocalizations.of(context)!.enrollNameEmpty);
      return;
    }
    Navigator.of(context).pop(name);
  }

  Future<void> _login() async {
    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const AuthHubScreen()),
    );
    if (!mounted || ok != true) return;
    final l10n = AppLocalizations.of(context)!;
    final name = AuthScope.of(context).displayName(l10n.playerName).trim();
    if (name.isEmpty || name == l10n.playerName) {
      setState(() => _writing = true);
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.bgLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.enrollNameTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            if (!_writing) ...[
              _NameChoiceButton(
                icon: Icons.edit_rounded,
                label: l10n.enrollWriteName,
                filled: true,
                onPressed: () => setState(() => _writing = true),
              ),
              const SizedBox(height: 12),
              _NameChoiceButton(
                icon: Icons.login_rounded,
                label: l10n.logIn,
                filled: false,
                onPressed: _login,
              ),
            ] else ...[
              TextField(
                controller: _name,
                autofocus: true,
                maxLength: 24,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: l10n.enrollNameHint,
                  errorText: _error,
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.borderGray),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _NameChoiceButton(
                icon: Icons.check_rounded,
                label: l10n.enrollNameConfirm,
                filled: true,
                onPressed: _submit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NameChoiceButton extends StatelessWidget {
  const _NameChoiceButton({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 52)),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      backgroundColor: WidgetStatePropertyAll(
        filled ? AppColors.yellow : Colors.white,
      ),
      foregroundColor: const WidgetStatePropertyAll(AppColors.bgBlueDeep),
      side: filled
          ? null
          : const WidgetStatePropertyAll(
              BorderSide(color: AppColors.bgBlue, width: 1.5),
            ),
    );
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: style,
    );
  }
}

class _ClassPickerDialog extends StatelessWidget {
  const _ClassPickerDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.bgLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.enrollChooseClass,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            for (final schoolClass in schoolClasses) ...[
              MenuRow(
                icon: classIcon(schoolClass.topic),
                label: classTitle(l10n, schoolClass.topic),
                description: l10n.homeroomTeacher,
                iconGradient: classIconGradient(schoolClass.topic),
                onTap: () => Navigator.of(context).pop(schoolClass.topic),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
