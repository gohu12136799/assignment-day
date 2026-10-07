import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Phase 1 phone login = OTP mỗi lần (option B trong requirements §4.4).
/// Mật khẩu lúc đăng ký phone được gắn bằng [User.updatePassword] để dùng sau.
class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  }) : _authOverride = auth,
       _firestoreOverride = firestore,
       _googleSignInOverride = googleSignIn;

  final FirebaseAuth? _authOverride;
  final FirebaseFirestore? _firestoreOverride;
  final GoogleSignIn? _googleSignInOverride;

  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;
  GoogleSignIn get _googleSignIn =>
      _googleSignInOverride ?? GoogleSignIn.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  static const otpLength = 6;
  static const otpTtl = Duration(minutes: 10);
  static const resendCooldowntdown = Duration(seconds: 60);

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Tạo OTP 6 số, lưu hash trên Firestore, xếp hàng gửi mail (Trigger Email).
  /// Trả về mã chỉ khi [kDebugMode] để test không cần SMTP.
  Future<String?> sendEmailOtp({
    required String email,
    required String uid,
  }) async {
    final code = _generateOtp();
    final hash = _hashOtp(code);
    final expiresAt = DateTime.now().toUtc().add(otpTtl);

    await _firestore.collection('email_otps').doc(uid).set({
      'email': email.trim().toLowerCase(),
      'codeHash': hash,
      'expiresAt': Timestamp.fromDate(expiresAt),
      'attempts': 0,
    });

    // Firebase Extension "Trigger Email from Firestore" đọc collection `mail`.
    await _firestore.collection('mail').add({
      'to': email.trim(),
      'message': {
        'subject': 'Brain Rush verification code',
        'text': 'Your Brain Rush code is $code. It expires in 10 minutes.',
        'html':
            '<p>Your Brain Rush code is <strong>$code</strong>.</p>'
            '<p>It expires in 10 minutes.</p>',
      },
    });

    return kDebugMode ? code : null;
  }

  Future<bool> verifyEmailOtp({
    required String uid,
    required String code,
  }) async {
    final doc = await _firestore.collection('email_otps').doc(uid).get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    final attempts = (data['attempts'] as num?)?.toInt() ?? 0;
    if (attempts >= 5) return false;

    await doc.reference.update({'attempts': attempts + 1});

    final expiresAt = (data['expiresAt'] as Timestamp).toDate();
    if (DateTime.now().toUtc().isAfter(expiresAt)) return false;

    final expected = data['codeHash'] as String?;
    if (expected == null || expected != _hashOtp(code.trim())) return false;

    await _firestore.collection('users').doc(uid).set({
      'emailOtpVerified': true,
      'email': data['email'],
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await doc.reference.delete();
    return true;
  }

  Future<bool> isEmailOtpVerified(String uid) async {
    final user = _auth.currentUser;
    if (user != null && user.uid == uid && user.emailVerified) return true;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['emailOtpVerified'] == true;
  }

  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) return _auth.signInWithPopup(GoogleAuthProvider());
    await _googleSignIn.initialize();
    final account = await _googleSignIn.authenticate();
    final auth = account.authentication;
    final credential = GoogleAuthProvider.credential(idToken: auth.idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    if (kIsWeb) return _auth.signInWithPopup(FacebookAuthProvider());
    final result = await FacebookAuth.instance.login();
    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw FirebaseAuthException(
        code: 'facebook-login-failed',
        message: result.message ?? 'Facebook login failed',
      );
    }
    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );
    return _auth.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber({
    required String phoneE164,
    required void Function(String verificationId) onCodeSent,
    required void Function(FirebaseAuthException error) onError,
    required void Function(PhoneAuthCredential credential) onAutoVerified,
    int? forceResendingToken,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      forceResendingToken: forceResendingToken,
      verificationCompleted: onAutoVerified,
      verificationFailed: onError,
      codeSent: (verificationId, resendToken) {
        _lastResendToken = resendToken;
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  int? _lastResendToken;
  int? get lastResendToken => _lastResendToken;

  Future<UserCredential> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode.trim(),
    );
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) {
    return _auth.signInWithCredential(credential);
  }

  /// Gắn mật khẩu sau khi phone OTP thành công (đăng ký).
  Future<void> setPasswordAfterPhone(String password) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No signed-in user to set password');
    }
    await user.updatePassword(password);
  }

  Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  String _generateOtp() {
    final random = Random.secure();
    final value = random.nextInt(1000000);
    return value.toString().padLeft(otpLength, '0');
  }

  String _hashOtp(String code) {
    return sha256.convert(utf8.encode(code)).toString();
  }
}
