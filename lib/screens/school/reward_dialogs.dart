import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../school/candy_store.dart';
import '../../school/student_outfits.dart';
import '../../theme/app_colors.dart';

enum StudentReaction { scared, happy, calm, tease }

/// Ảnh sau khi em chọn trạng thái. Trước lúc chọn thì dùng cảnh thước sẵn.
String reactionScene(StudentReaction reaction) => switch (reaction) {
  StudentReaction.scared => 'assets/images/school/punish_scared.jpg',
  StudentReaction.happy => 'assets/images/school/punish_happy.jpg',
  StudentReaction.calm => 'assets/images/school/punish_stubborn.jpg',
  StudentReaction.tease => 'assets/images/school/punish_tease.jpg',
};

class ReactionChoice {
  const ReactionChoice(this.reaction, [this.line]);

  final StudentReaction reaction;
  final String? line;
}

String reactionReply(AppLocalizations l10n, bool male, ReactionChoice choice) {
  return switch (choice.reaction) {
    StudentReaction.scared =>
      male ? l10n.reactionReplyScaredMale : l10n.reactionReplyScaredFemale,
    StudentReaction.happy =>
      male ? l10n.reactionReplyHappyMale : l10n.reactionReplyHappyFemale,
    StudentReaction.calm =>
      male ? l10n.reactionReplyCalmMale : l10n.reactionReplyCalmFemale,
    StudentReaction.tease =>
      male
          ? l10n.reactionReplyTeaseMale(choice.line ?? '')
          : l10n.reactionReplyTeaseFemale(choice.line ?? ''),
  };
}

/// Điểm danh mới trong ngày thì tặng 1 kẹo và mở popup.
Future<void> grantDailyCandy(
  BuildContext context,
  DateTime day, {
  CandyStore? store,
}) async {
  final candy = store ?? CandyStore();
  final added = await candy.awardDailyCheckIn(day);
  if (added == 0 || !context.mounted) return;
  await showCandyGiftDialog(context, praise: false, store: candy);
}

/// Popup tặng kẹo. Đủ 10 kẹo thì mở luôn chỗ đổi đồ.
Future<void> showCandyGiftDialog(
  BuildContext context, {
  required bool praise,
  CandyStore? store,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _CandyGiftDialog(praise: praise, store: store ?? CandyStore()),
  );
}

Future<void> showOutfitShop(BuildContext context, {CandyStore? store}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _OutfitShopDialog(store: store ?? CandyStore()),
  );
}

Future<ReactionChoice?> showReactionDialog(
  BuildContext context, {
  required bool male,
}) {
  return showDialog<ReactionChoice>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ReactionDialog(male: male),
  );
}

class _CandyGiftDialog extends StatefulWidget {
  const _CandyGiftDialog({required this.praise, required this.store});

  final bool praise;
  final CandyStore store;

  @override
  State<_CandyGiftDialog> createState() => _CandyGiftDialogState();
}

class _CandyGiftDialogState extends State<_CandyGiftDialog> {
  int _count = 0;
  bool _canBuy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final count = await widget.store.count();
    final owned = await widget.store.ownedIds();
    final locked = studentOutfits.any(
      (outfit) => outfit.cost > 0 && !owned.contains(outfit.id.name),
    );
    if (!mounted) return;
    setState(() {
      _count = count;
      _canBuy = locked && count >= outfitCandyCost;
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
            const Text('🍬', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              widget.praise ? l10n.candyPraiseGift : l10n.candyCheckInGift,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.bgBlueDeep,
                fontSize: 20,
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
            if (_canBuy) ...[
              _DialogButton(
                label: l10n.exchangeOutfit,
                filled: false,
                onPressed: () async {
                  await showOutfitShop(context, store: widget.store);
                  await _load();
                },
              ),
              const SizedBox(height: 8),
            ],
            _DialogButton(
              label: l10n.candyAccept,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutfitShopDialog extends StatefulWidget {
  const _OutfitShopDialog({required this.store});

  final CandyStore store;

  @override
  State<_OutfitShopDialog> createState() => _OutfitShopDialogState();
}

class _OutfitShopDialogState extends State<_OutfitShopDialog> {
  int _count = 0;
  Set<String> _owned = {StudentOutfitId.uniform.name};
  String _equipped = StudentOutfitId.uniform.name;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final count = await widget.store.count();
    final owned = await widget.store.ownedIds();
    final equipped = await widget.store.equipped();
    if (!mounted) return;
    setState(() {
      _count = count;
      _owned = owned;
      _equipped = equipped.id.name;
    });
  }

  Future<void> _choose(StudentOutfit outfit) async {
    final ok = await widget.store.exchange(outfit);
    if (!ok || !mounted) return;
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shop = [
      for (final outfit in studentOutfits)
        if (outfit.cost > 0) outfit,
      for (final outfit in studentOutfits)
        if (outfit.cost == 0) outfit,
    ];

    return Dialog(
      backgroundColor: AppColors.schoolCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Text(
                    l10n.exchangeOutfit,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.bgBlueDeep,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.bgBlueDeep,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.candyCount(_count),
              style: const TextStyle(
                color: AppColors.bgBlueDeep,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            for (final outfit in shop) ...[
              _OutfitRow(
                outfit: outfit,
                owned: _owned.contains(outfit.id.name),
                equipped: _equipped == outfit.id.name,
                candies: _count,
                onChoose: () => _choose(outfit),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _OutfitRow extends StatelessWidget {
  const _OutfitRow({
    required this.outfit,
    required this.owned,
    required this.equipped,
    required this.candies,
    required this.onChoose,
  });

  final StudentOutfit outfit;
  final bool owned;
  final bool equipped;
  final int candies;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final short = outfit.cost - candies;
    final String label;
    final bool enabled;
    if (equipped) {
      label = l10n.outfitWearing;
      enabled = false;
    } else if (owned || outfit.cost <= 0) {
      label = l10n.outfitWear;
      enabled = true;
    } else if (candies >= outfit.cost) {
      label = l10n.outfitPrice;
      enabled = true;
    } else {
      label = l10n.outfitShort(short);
      enabled = false;
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.yellow,
          backgroundImage: AssetImage(outfit.asset),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            outfit.name(l10n),
            style: const TextStyle(
              color: AppColors.bgBlueDeep,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(onPressed: enabled ? onChoose : null, child: Text(label)),
      ],
    );
  }
}

class _ReactionDialog extends StatefulWidget {
  const _ReactionDialog({required this.male});

  final bool male;

  @override
  State<_ReactionDialog> createState() => _ReactionDialogState();
}

class _ReactionDialogState extends State<_ReactionDialog> {
  final _line = TextEditingController();
  bool _teasing = false;
  String? _error;

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  void _pick(StudentReaction reaction) {
    Navigator.of(context).pop(ReactionChoice(reaction));
  }

  void _sendTease() {
    final line = _line.text.trim();
    if (line.isEmpty) {
      setState(() => _error = AppLocalizations.of(context)!.reactionEmpty);
      return;
    }
    Navigator.of(context).pop(ReactionChoice(StudentReaction.tease, line));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.schoolCream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.reactionTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.bgBlueDeep,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _DialogButton(
                label: l10n.reactionScared,
                onPressed: () => _pick(StudentReaction.scared),
              ),
              const SizedBox(height: 8),
              _DialogButton(
                label: l10n.reactionHappy,
                onPressed: () => _pick(StudentReaction.happy),
              ),
              const SizedBox(height: 8),
              _DialogButton(
                label: l10n.reactionCalm,
                onPressed: () => _pick(StudentReaction.calm),
              ),
              const SizedBox(height: 8),
              _DialogButton(
                label: widget.male
                    ? l10n.reactionTeaseMale
                    : l10n.reactionTeaseFemale,
                filled: !_teasing,
                onPressed: () => setState(() => _teasing = true),
              ),
              if (_teasing) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _line,
                  autofocus: true,
                  maxLength: 80,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _sendTease(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.male
                        ? l10n.reactionTeaseHintMale
                        : l10n.reactionTeaseHintFemale,
                    errorText: _error,
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _DialogButton(
                  label: widget.male
                      ? l10n.reactionSendMale
                      : l10n.reactionSendFemale,
                  onPressed: _sendTease,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: filled ? AppColors.yellow : Colors.white,
      foregroundColor: AppColors.bgBlueDeep,
      minimumSize: const Size(double.infinity, 48),
      shape: const StadiumBorder(),
      side: filled ? null : const BorderSide(color: AppColors.yellow, width: 2),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
    return FilledButton(onPressed: onPressed, style: style, child: Text(label));
  }
}
