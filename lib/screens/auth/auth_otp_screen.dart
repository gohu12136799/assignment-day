import 'dart:async';

import 'package:flutter/material.dart';

import '../../auth/auth_scope.dart';
import '../../auth/auth_validators.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import 'auth_widgets.dart';

enum AuthOtpChannel { email, phone }

class AuthOtpScreen extends StatefulWidget {
  const AuthOtpScreen({
    super.key,
    required this.channel,
    required this.destination,
    this.newPassword,
  });

  final AuthOtpChannel channel;
  final String destination;
  final String? newPassword;

  @override
  State<AuthOtpScreen> createState() => _AuthOtpScreenState();
}

class _AuthOtpScreenState extends State<AuthOtpScreen> {
  final _code = TextEditingController();
  String? _codeError;
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);
    setState(() {
      _codeError = AuthValidators.otp(
        _code.text,
        invalidMessage: l10n.invalidOtp,
      );
    });
    if (_codeError != null) return;

    final ok = widget.channel == AuthOtpChannel.email
        ? await auth.verifyPendingEmailOtp(_code.text)
        : await auth.confirmPhoneSms(
            smsCode: _code.text,
            newPassword: widget.newPassword,
          );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(authErrorMessage(l10n, auth.errorCode ?? 'invalid-otp')),
        backgroundColor: AppColors.bgBlueDeep,
      ),
    );
  }

  Future<void> _resend() async {
    final auth = AuthScope.of(context);
    if (!auth.canResendOtp) return;
    if (widget.channel == AuthOtpChannel.email) {
      await auth.resendEmailOtp();
    } else {
      await auth.startPhoneVerification(widget.destination);
    }
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _onBack() async {
    final auth = AuthScope.of(context);
    if (widget.channel == AuthOtpChannel.email) {
      auth.cancelEmailOtpFlow();
    }
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = AuthScope.of(context);
    final seconds = auth.resendCooldowntdown.inSeconds;

    return AuthScaffold(
      title: l10n.authOtpTitle,
      onBack: _onBack,
      child: ListView(
        children: [
          Text(
            l10n.otpSentTo(widget.destination),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          if (auth.debugEmailOtp != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.debugOtpHint(auth.debugEmailOtp!),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.yellow, fontSize: 14),
            ),
          ],
          const SizedBox(height: 24),
          AuthTextField(
            controller: _code,
            label: l10n.enterCode,
            keyboardType: TextInputType.number,
            errorText: _codeError,
          ),
          const SizedBox(height: 24),
          AuthPrimaryButton(
            label: l10n.verifyCode,
            busy: auth.busy,
            onPressed: _verify,
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: auth.canResendOtp && !auth.busy ? _resend : null,
            child: Text(
              auth.canResendOtp
                  ? l10n.resendCode
                  : l10n.resendCodeIn(seconds),
              style: TextStyle(
                color: auth.canResendOtp ? Colors.white70 : Colors.white38,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
