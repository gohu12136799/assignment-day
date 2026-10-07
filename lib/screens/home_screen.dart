import 'package:flutter/material.dart';

import '../auth/auth_scope.dart';
import '../l10n/app_localizations.dart';
import '../school/candy_store.dart';
import '../school/enrollment_store.dart';
import '../school/student_outfits.dart';
import '../theme/app_colors.dart';
import '../widgets/brain_rush_title.dart';
import 'school/class_entry_screen.dart';
import 'school/reward_dialogs.dart';
import 'settings_screen.dart';

/// Màn Home / menu chơi.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openClass(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ClassEntryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 1, 20, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BrainRushTitle(
                      topLine: l10n.schoolNameTop,
                      bottomLine: l10n.schoolNameBottom,
                      fontSize: 34,
                      bottomFontSize: 42,
                      arcDegrees: 46,
                      height: 176,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.schoolTagline,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _StudentChip(grade: l10n.studentGrade),
                    const SizedBox(height: 36),
                    _EnterClassButton(
                      label: l10n.enterClass,
                      onTap: () => _openClass(context),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                  tooltip: l10n.settings,
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white24,
                  ),
                  icon: const Icon(Icons.settings_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip tên và lớp. Chỉ avatar mở ảnh lớn, tên, và chỗ đổi đồ.
class _StudentChip extends StatefulWidget {
  const _StudentChip({required this.grade});

  final String grade;

  @override
  State<_StudentChip> createState() => _StudentChipState();
}

class _StudentChipState extends State<_StudentChip> {
  final CandyStore _candy = CandyStore();
  String _name = '';
  String _asset = studentOutfits.first.asset;
  bool _onTop = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final outfit = await _candy.equipped();
    final stored = await EnrollmentStore().studentName();
    if (!mounted) return;
    if (stored != null) {
      setState(() {
        _name = stored;
        _asset = outfit.asset;
      });
      return;
    }
    final auth = AuthScope.of(context);
    if (!auth.isSignedIn) {
      setState(() => _asset = outfit.asset);
      return;
    }
    final account = auth.displayName('');
    if (!mounted) return;
    setState(() {
      if (account.isNotEmpty) _name = account;
      _asset = outfit.asset;
    });
  }

  Future<void> _showPortrait() async {
    await showDialog<void>(
      context: context,
      builder: (_) =>
          _PortraitDialog(name: _name, asset: _asset, candy: _candy),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final onTop = ModalRoute.of(context)?.isCurrent ?? true;
    if (onTop != _onTop) {
      _onTop = onTop;
      if (onTop) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _load();
        });
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(2, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showPortrait,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.yellow,
              backgroundImage: AssetImage(_asset),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            widget.grade,
            style: const TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortraitDialog extends StatefulWidget {
  const _PortraitDialog({
    required this.name,
    required this.asset,
    required this.candy,
  });

  final String name;
  final String asset;
  final CandyStore candy;

  @override
  State<_PortraitDialog> createState() => _PortraitDialogState();
}

class _PortraitDialogState extends State<_PortraitDialog> {
  late String _asset = widget.asset;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final outfit = await widget.candy.equipped();
    final count = await widget.candy.count();
    if (!mounted) return;
    setState(() {
      _asset = outfit.asset;
      _count = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.schoolCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 96,
              backgroundColor: AppColors.yellow,
              backgroundImage: AssetImage(_asset),
            ),
            const SizedBox(height: 16),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.bgBlueDeep,
                fontSize: 23,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.candyCount(_count),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.bgBlueDeep,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await showOutfitShop(context, store: widget.candy);
                await _load();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.bgBlueDeep,
                minimumSize: const Size(double.infinity, 48),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text(l10n.exchangeOutfit),
            ),
          ],
        ),
      ),
    );
  }
}

/// Nút vàng lớn, nhịp thở nhẹ và hào quang để mời vào lớp.
class _EnterClassButton extends StatefulWidget {
  const _EnterClassButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_EnterClassButton> createState() => _EnterClassButtonState();
}

class _EnterClassButtonState extends State<_EnterClassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final t = Curves.easeInOut.transform(_pulse.value);
        return Transform.scale(
          scale: 1 + 0.04 * t,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              boxShadow: [
                BoxShadow(
                  color: AppColors.yellow.withValues(alpha: 0.28 + 0.32 * t),
                  blurRadius: 16 + 14 * t,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(36),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(36),
          child: Ink(
            height: 132,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.yellowGradient,
              ),
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 18,
                  left: 22,
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const Positioned(
                  right: 26,
                  bottom: 18,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.meeting_room_rounded,
                      color: AppColors.bgBlueDeep,
                      size: 40,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppColors.bgBlueDeep,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
