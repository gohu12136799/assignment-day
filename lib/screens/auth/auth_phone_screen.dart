import 'package:flutter/material.dart';

import '../../auth/auth_scope.dart';
import '../../auth/auth_validators.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import 'auth_otp_screen.dart';
import 'auth_widgets.dart';

/// Phone: OTP mỗi lần (option B). Đăng ký có thể kèm mật khẩu để gắn sau OTP.
class AuthPhoneScreen extends StatefulWidget {
  const AuthPhoneScreen({super.key});

  @override
  State<AuthPhoneScreen> createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends State<AuthPhoneScreen> {
  bool _signUp = false;
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _phoneError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);
    if (!auth.firebaseReady) {
      _toast(authErrorMessage(l10n, 'not-configured'));
      return;
    }

    final e164 = AuthValidators.normalizeVietnamPhone(_phone.text);
    setState(() {
      _phoneError = e164 == null ? l10n.invalidPhone : null;
      if (_signUp) {
        _passwordError = AuthValidators.password(
          _password.text,
          invalidMessage: l10n.invalidPassword,
        );
        _confirmError = AuthValidators.confirmPassword(
          _confirm.text,
          _password.text,
          mismatchMessage: l10n.passwordMismatch,
        );
      } else {
        _passwordError = null;
        _confirmError = null;
      }
    });
    if (_phoneError != null ||
        _passwordError != null ||
        _confirmError != null) {
      return;
    }

    final sent = await auth.startPhoneVerification(e164!);
    if (!mounted) return;
    if (!sent) {
      _toast(authErrorMessage(l10n, auth.errorCode));
      return;
    }

    if (auth.isSignedIn) {
      Navigator.of(context).pop(true);
      return;
    }

    final ok = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AuthOtpScreen(
          channel: AuthOtpChannel.phone,
          destination: e164,
          newPassword: _signUp ? _password.text : null,
        ),
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop(true);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.bgBlueDeep),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);

    return AuthScaffold(
      title: l10n.authPhoneTitle,
      child: ListView(
        children: [
          AuthTextField(
            controller: _phone,
            label: l10n.phoneLabel,
            hint: l10n.phoneHint,
            keyboardType: TextInputType.phone,
            errorText: _phoneError,
          ),
          if (_signUp) ...[
            const SizedBox(height: 12),
            AuthTextField(
              controller: _password,
              label: l10n.passwordLabel,
              obscure: true,
              errorText: _passwordError,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _confirm,
              label: l10n.confirmPasswordLabel,
              obscure: true,
              errorText: _confirmError,
            ),
          ],
          const SizedBox(height: 24),
          AuthPrimaryButton(
            label: l10n.sendCode,
            busy: auth.busy,
            onPressed: _submit,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() => _signUp = !_signUp),
            child: Text(
              _signUp ? l10n.haveAccountSignIn : l10n.noAccountSignUp,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
