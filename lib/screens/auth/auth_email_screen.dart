import 'package:flutter/material.dart';

import '../../auth/auth_scope.dart';
import '../../auth/auth_validators.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import 'auth_otp_screen.dart';
import 'auth_widgets.dart';

class AuthEmailScreen extends StatefulWidget {
  const AuthEmailScreen({super.key, this.startInSignUp = false});

  final bool startInSignUp;

  @override
  State<AuthEmailScreen> createState() => _AuthEmailScreenState();
}

class _AuthEmailScreenState extends State<AuthEmailScreen> {
  late bool _signUp = widget.startInSignUp;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  bool _validate(AppLocalizations l10n) {
    setState(() {
      _emailError = AuthValidators.email(
        _email.text,
        invalidMessage: l10n.invalidEmail,
      );
      _passwordError = AuthValidators.password(
        _password.text,
        invalidMessage: l10n.invalidPassword,
      );
      _confirmError = _signUp
          ? AuthValidators.confirmPassword(
              _confirm.text,
              _password.text,
              mismatchMessage: l10n.passwordMismatch,
            )
          : null;
    });
    return _emailError == null &&
        _passwordError == null &&
        _confirmError == null;
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);
    if (!auth.firebaseReady) {
      _toast(authErrorMessage(l10n, 'not-configured'));
      return;
    }
    if (!_validate(l10n)) return;

    final ok = _signUp
        ? await auth.registerWithEmail(
            email: _email.text,
            password: _password.text,
          )
        : await auth.signInWithEmail(
            email: _email.text,
            password: _password.text,
          );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }

    if (auth.pendingEmail != null) {
      final verified = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => AuthOtpScreen(
            channel: AuthOtpChannel.email,
            destination: auth.pendingEmail!,
          ),
        ),
      );
      if (verified == true && mounted) {
        Navigator.of(context).pop(true);
      }
      return;
    }

    _toast(authErrorMessage(l10n, auth.errorCode));
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
      title: _signUp ? l10n.authEmailSignUpTitle : l10n.authEmailSignInTitle,
      child: ListView(
        children: [
          AuthTextField(
            controller: _email,
            label: l10n.emailLabel,
            keyboardType: TextInputType.emailAddress,
            errorText: _emailError,
          ),
          const SizedBox(height: 12),
          AuthTextField(
            controller: _password,
            label: l10n.passwordLabel,
            obscure: true,
            errorText: _passwordError,
          ),
          if (_signUp) ...[
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
            label: _signUp ? l10n.signUp : l10n.logIn,
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
