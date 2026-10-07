import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'auth_service.dart';

/// Phiên đăng nhập app. Guest = [user] null hoặc chờ OTP email.
class AuthController extends ChangeNotifier {
  AuthController({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;
  StreamSubscription<User?>? _authSub;

  User? _user;
  bool _ready = false;
  bool _firebaseReady = false;
  bool _busy = false;
  String? _errorCode;
  String? _pendingEmailOtpUid;
  String? _pendingEmail;
  String? _debugEmailOtp;
  String? _phoneVerificationId;
  DateTime? _otpResendAvailableAt;

  AuthService get service => _service;

  bool get ready => _ready;
  bool get firebaseReady => _firebaseReady;
  bool get busy => _busy;
  bool get isSignedIn => _user != null && _pendingEmailOtpUid == null;
  User? get user => isSignedIn ? _user : null;
  String? get errorCode => _errorCode;
  String? get pendingEmail => _pendingEmail;
  String? get debugEmailOtp => kDebugMode ? _debugEmailOtp : null;
  String? get phoneVerificationId => _phoneVerificationId;

  bool get canResendOtp {
    final at = _otpResendAvailableAt;
    if (at == null) return true;
    return DateTime.now().isAfter(at);
  }

  Duration get resendCooldowntdown {
    final at = _otpResendAvailableAt;
    if (at == null) return Duration.zero;
    final left = at.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  String displayName(String guestLabel) {
    final user = this.user;
    if (user == null) return guestLabel;
    final name = user.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = user.email?.trim();
    if (email != null && email.isNotEmpty) return email.split('@').first;
    final phone = user.phoneNumber;
    if (phone != null && phone.isNotEmpty) return phone;
    return guestLabel;
  }

  String? get photoUrl => user?.photoURL;
  /**bootstrap() trong auth_controller.dart làm hai việc:
Kiểm tra lần trước có còn đăng nhập không. Firebase tự lưu phiên, nên mở lại app không phải đăng nhập lại.
Lắng nghe authStateChanges. Mỗi lần đăng nhập hoặc đăng xuất, controller gọi notifyListeners(). */
  Future<void> bootstrap({required bool firebaseConfigured}) async {
    _firebaseReady = firebaseConfigured;
    if (!firebaseConfigured) {
      _ready = true;
      notifyListeners();
      return;
    }

    _user = _service.currentUser;
    if (_user != null) {
      final verified = await _ensureEmailGate(_user!);
      if (!verified) {
        _pendingEmailOtpUid = _user!.uid;
        _pendingEmail = _user!.email;
      }
    }
    _ready = true;
    notifyListeners();

    _authSub = _service.authStateChanges.listen((user) async {
      _user = user;
      if (user == null) {
        _pendingEmailOtpUid = null;
        _pendingEmail = null;
        _debugEmailOtp = null;
      } else if (_pendingEmailOtpUid == null) {
        final ok = await _ensureEmailGate(user);
        if (!ok) {
          _pendingEmailOtpUid = user.uid;
          _pendingEmail = user.email;
        }
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<bool> _ensureEmailGate(User user) async {
    final hasPasswordProvider = user.providerData.any(
      (p) => p.providerId == EmailAuthProvider.PROVIDER_ID,
    );
    if (!hasPasswordProvider) return true;
    if (user.emailVerified) return true;
    return _service.isEmailOtpVerified(user.uid);
  }

  void clearError() {
    _errorCode = null;
    notifyListeners();
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return _run(() async {
      final cred = await _service.signInWithEmail(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        _errorCode = 'unknown';
        return false;
      }
      final ok = await _ensureEmailGate(user);
      if (!ok) {
        _pendingEmailOtpUid = user.uid;
        _pendingEmail = user.email;
        _debugEmailOtp = await _service.sendEmailOtp(
          // (2)
          email: user.email!,
          uid: user.uid,
        );
        _startResendCooldowntdown();
        return false;
      }
      return true;
    });
  }

  Future<bool> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return _run(() async {
      final cred = await _service.registerWithEmail(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        _errorCode = 'unknown';
        return false;
      }
      _pendingEmailOtpUid = user.uid;
      _pendingEmail = email.trim();
      _debugEmailOtp = await _service.sendEmailOtp(email: email, uid: user.uid);
      _startResendCooldowntdown();
      return false;
    });
  }

  Future<bool> verifyPendingEmailOtp(String code) async {
    final uid = _pendingEmailOtpUid;
    if (uid == null) return false;
    return _run(() async {
      final ok = await _service.verifyEmailOtp(uid: uid, code: code);
      if (!ok) {
        _errorCode = 'invalid-otp';
        return false;
      }
      _pendingEmailOtpUid = null;
      _pendingEmail = null;
      _debugEmailOtp = null;
      _user = _service.currentUser;
      return true;
    });
  }

  Future<void> resendEmailOtp() async {
    final uid = _pendingEmailOtpUid;
    final email = _pendingEmail;
    if (uid == null || email == null || !canResendOtp) return;
    await _run(() async {
      _debugEmailOtp = await _service.sendEmailOtp(email: email, uid: uid);
      _startResendCooldowntdown();
      return true;
    });
  }

  Future<bool> signInWithGoogle() async {
    return _run(() async {
      await _service.signInWithGoogle();
      _pendingEmailOtpUid = null;
      return true;
    });
  }

  Future<bool> signInWithFacebook() async {
    return _run(() async {
      await _service.signInWithFacebook();
      _pendingEmailOtpUid = null;
      return true;
    });
  }

  Future<bool> startPhoneVerification(String phoneE164) async {
    return _run(() async {
      var completed = false;
      var failed = false;
      await _service.verifyPhoneNumber(
        phoneE164: phoneE164,
        forceResendingToken: _service.lastResendToken,
        onCodeSent: (verificationId) {
          _phoneVerificationId = verificationId;
          _startResendCooldowntdown();
          completed = true;
          notifyListeners();
        },
        onError: (error) {
          _errorCode = error.code;
          failed = true;
          notifyListeners();
        },
        onAutoVerified: (credential) async {
          await _service.signInWithPhoneCredential(credential);
          _pendingEmailOtpUid = null;
          completed = true;
          notifyListeners();
        },
      );
      // verifyPhoneNumber returns before callbacks; wait briefly for codeSent.
      for (var i = 0; i < 40 && !completed && !failed; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      return completed && !failed;
    });
  }

  Future<bool> confirmPhoneSms({
    required String smsCode,
    String? newPassword,
  }) async {
    final verificationId = _phoneVerificationId;
    if (verificationId == null) {
      _errorCode = 'missing-verification';
      notifyListeners();
      return false;
    }
    return _run(() async {
      await _service.signInWithSmsCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      if (newPassword != null && newPassword.isNotEmpty) {
        try {
          await _service.setPasswordAfterPhone(newPassword);
        } on FirebaseAuthException catch (e) {
          // Phone user may already have a password; ignore weak/requires-recent.
          if (e.code != 'requires-recent-login') {
            _errorCode = e.code;
          }
        }
      }
      _pendingEmailOtpUid = null;
      _phoneVerificationId = null;
      return true;
    });
  }

  Future<void> signOut() async {
    await _run(() async {
      await _service.signOut();
      _pendingEmailOtpUid = null;
      _pendingEmail = null;
      _phoneVerificationId = null;
      _debugEmailOtp = null;
      return true;
    });
  }

  void cancelEmailOtpFlow() {
    // User đã được tạo nhưng chưa verify — sign out để không nửa đăng ký. (1)
    final unverified = _user != null && _pendingEmailOtpUid != null;
    _pendingEmailOtpUid = null;
    _pendingEmail = null;
    _debugEmailOtp = null;
    if (unverified) {
      _user = null;
      _service.signOut();
    }
    notifyListeners();
  }

  void _startResendCooldowntdown() {
    _otpResendAvailableAt = DateTime.now().add(AuthService.resendCooldowntdown);
  }

  Future<bool> _run(Future<bool> Function() action) async {
    if (_busy) return false;
    _busy = true;
    _errorCode = null;
    notifyListeners();
    try {
      final result = await action();
      return result;
    } on FirebaseException catch (e) {
      _errorCode = e.code;
      debugPrint('[auth] ${e.plugin}/${e.code}: ${e.message}');
      return false;
    } catch (e) {
      _errorCode = 'unknown';
      debugPrint('[auth] $e');
      return false;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }
}
