import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../locale_controller.dart';
import '../theme/app_colors.dart';

/// Cài đặt. Chỉ đổi ngôn ngữ có tác dụng. Các mục khác là giao diện.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _sound = true;
  bool _music = true;
  bool _notifications = false;

  void _comingSoon() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.comingSoon)));
  }

  void _pickLanguage() {
    final l10n = AppLocalizations.of(context)!;
    final locale = LocaleScope.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        const titleStyle = TextStyle(
          color: AppColors.bgBlue,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        );
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(l10n.vietnamese, style: titleStyle),
                  trailing: locale.isVietnamese
                      ? const Icon(Icons.check_rounded, color: AppColors.bgBlue)
                      : null,
                  onTap: () {
                    locale.setLocale(const Locale('vi'));
                    Navigator.of(sheetContext).pop();
                  },
                ),
                ListTile(
                  title: Text(l10n.english, style: titleStyle),
                  trailing: locale.isVietnamese
                      ? null
                      : const Icon(
                          Icons.check_rounded,
                          color: AppColors.bgBlue,
                        ),
                  onTap: () {
                    locale.setLocale(const Locale('en'));
                    Navigator.of(sheetContext).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = LocaleScope.of(context);
    final languageName = locale.isVietnamese ? l10n.vietnamese : l10n.english;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        foregroundColor: AppColors.bgBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.settings,
          style: const TextStyle(
            color: AppColors.bgBlue,
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
          _card([
            _switchTile(
              icon: Icons.volume_up_rounded,
              label: l10n.sound,
              value: _sound,
              activeColor: AppColors.answerGreen,
              onChanged: (value) => setState(() => _sound = value),
            ),
            _switchTile(
              icon: Icons.music_note_rounded,
              label: l10n.backgroundMusic,
              value: _music,
              activeColor: AppColors.bgBlueLight,
              onChanged: (value) => setState(() => _music = value),
            ),
            _switchTile(
              icon: Icons.notifications_none_rounded,
              label: l10n.notifications,
              value: _notifications,
              activeColor: AppColors.bgBlueLight,
              onChanged: (value) => setState(() => _notifications = value),
            ),
          ]),
          const SizedBox(height: 12),
          _card([
            _valueTile(
              icon: Icons.language_rounded,
              label: l10n.language,
              value: languageName,
              onTap: _pickLanguage,
            ),
            _valueTile(
              icon: Icons.palette_outlined,
              label: l10n.appearance,
              value: l10n.lightTheme,
              onTap: _comingSoon,
            ),
          ]),
          const SizedBox(height: 12),
          _card([
            _linkTile(
              icon: Icons.help_outline_rounded,
              label: l10n.guide,
              onTap: _comingSoon,
            ),
            _linkTile(
              icon: Icons.star_border_rounded,
              label: l10n.rateApp,
              onTap: _comingSoon,
            ),
            _linkTile(
              icon: Icons.headset_mic_outlined,
              label: l10n.contact,
              onTap: _comingSoon,
            ),
          ]),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: _comingSoon,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.redIconGradient.first,
              backgroundColor: AppColors.redIconGradient.first.withValues(
                alpha: 0.12,
              ),
              side: BorderSide(color: AppColors.redIconGradient.first),
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              l10n.logOut,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
                color: AppColors.borderGray.withValues(alpha: 0.45),
              ),
            tiles[i],
          ],
        ],
      ),
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String label,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return _row(
      icon: icon,
      label: label,
      onTap: () => onChanged(!value),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: activeColor,
      ),
    );
  }

  Widget _valueTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return _row(
      icon: icon,
      label: label,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.black45, fontSize: 14),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black38),
        ],
      ),
    );
  }

  Widget _linkTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _row(
      icon: icon,
      label: label,
      onTap: onTap,
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black38),
    );
  }

  Widget _row({
    required IconData icon,
    required String label,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.bgBlueLight),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bgBlue,
                  ),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
