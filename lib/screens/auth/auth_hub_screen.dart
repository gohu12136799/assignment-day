import 'package:flutter/material.dart';

import '../../auth/auth_scope.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import 'auth_email_screen.dart';
import 'auth_phone_screen.dart';
import 'auth_widgets.dart';

/// Hub đăng nhập. Guest vẫn thoát được bằng Back / Continue as guest.
class AuthHubScreen extends StatefulWidget {
  const AuthHubScreen({super.key});

  @override
  State<AuthHubScreen> createState() => _AuthHubScreenState();
}

class _AuthHubScreenState extends State<AuthHubScreen> {
  Future<void> _finishIfOk(Future<bool> Function() action) async {
    final auth = AuthScope.of(context);
    if (!auth.firebaseReady) {
      _showError(authErrorMessage(
        AppLocalizations.of(context)!,
        'not-configured',
      ));
      return;
    }
    final ok = await action();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }
    final message = authErrorMessage(
      AppLocalizations.of(context)!,
      auth.errorCode,
    );
    if (message.isNotEmpty) _showError(message);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.bgBlueDeep,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);

    return AuthScaffold(
      title: l10n.logIn,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.authWelcomeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.authWelcomeSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(),
          AuthProviderButton(
            icon: Icons.g_mobiledata_rounded,
            label: l10n.continueWithGoogle,
            onPressed: auth.busy
                ? null
                : () => _finishIfOk(auth.signInWithGoogle),
          ),
          const SizedBox(height: 12),
          AuthProviderButton(
            icon: Icons.facebook_rounded,
            label: l10n.continueWithFacebook,
            background: const Color(0xFF1877F2),
            foreground: Colors.white,
            onPressed: auth.busy
                ? null
                : () => _finishIfOk(auth.signInWithFacebook),
          ),
          const SizedBox(height: 12),
          AuthProviderButton(
            icon: Icons.email_outlined,
            label: l10n.continueWithEmail,
            background: AppColors.cardBg,
            foreground: Colors.white,
            onPressed: () async {
              final ok = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const AuthEmailScreen()),
              );
              if (ok == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),
          const SizedBox(height: 12),
          AuthProviderButton(
            icon: Icons.phone_iphone_rounded,
            label: l10n.continueWithPhone,
            background: AppColors.cardBg,
            foreground: Colors.white,
            onPressed: () async {
              final ok = await Navigator.of(context).push<bool>(
                MaterialPageRoute(builder: (_) => const AuthPhoneScreen()),
              );
              if (ok == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.playAsGuest,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (auth.busy) ...[
            const SizedBox(height: 12),
            const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            ),
          ],
        ],
      ),
    );
  }
}
