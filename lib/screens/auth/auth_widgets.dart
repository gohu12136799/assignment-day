import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

String authErrorMessage(AppLocalizations l10n, String? code) {
  return switch (code) {
    null => '',
    'invalid-email' ||
    'user-not-found' ||
    'wrong-password' ||
    'INVALID_LOGIN_CREDENTIALS' ||
    'invalid-credential' =>
      l10n.authErrorWrongCredentials,
    'invalid-otp' || 'invalid-verification-code' || 'session-expired' =>
      l10n.authErrorInvalidOtp,
    'network-request-failed' => l10n.authErrorNetwork,
    'canceled' ||
    'aborted' ||
    'sign_in_canceled' ||
    'popup-closed-by-user' ||
    'cancelled-popup-request' =>
      l10n.authErrorCancelled,
    'facebook-login-failed' => l10n.authErrorFacebook,
    'not-configured' => l10n.authErrorNotConfigured,
    'operation-not-allowed' ||
    'configuration-not-found' =>
      l10n.authErrorProviderDisabled,
    'email-already-in-use' => l10n.authErrorEmailInUse,
    'too-many-requests' => l10n.authErrorTooManyRequests,
    'popup-blocked' => l10n.authErrorPopupBlocked,
    'permission-denied' || 'unavailable' || 'not-found' =>
      l10n.authErrorDatabase,
    _ => kDebugMode
        ? '${l10n.authErrorUnknown} ($code)'
        : l10n.authErrorUnknown,
  };
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
  });

  final String title;
  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      appBar: AppBar(
        backgroundColor: AppColors.bgBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: child,
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: busy ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.bgBlueDeep,
          disabledBackgroundColor: AppColors.yellow.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(label),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      cursorColor: AppColors.yellow,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
        errorStyle: const TextStyle(color: Color(0xFFFFCDD2)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.yellow, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.redIconGradient.first),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.redIconGradient.first),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.08),
      ),
    );
  }
}

class AuthProviderButton extends StatelessWidget {
  const AuthProviderButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.background = Colors.white,
    this.foreground = const Color(0xFF072E6E),
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
