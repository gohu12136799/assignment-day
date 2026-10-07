# Auth setup (Firebase)

Brain Rush dùng Firebase Auth. Code app đã có; cần cấu hình project trước khi Google / Facebook / email / phone chạy thật.

Phone login phase 1 = **option B**: OTP SMS mỗi lần đăng nhập. Mật khẩu lúc đăng ký phone được gắn bằng `updatePassword` để dùng sau (linking / email). Đăng nhập phone+password thuần là follow-up.

## 1. Tạo Firebase project

1. Vào [Firebase Console](https://console.firebase.google.com/) → Add project.
2. Thêm app **Android** với package `com.huong.brainrush`.
3. Tải `google-services.json` → đặt vào `android/app/google-services.json`.
4. (iOS) thêm iOS app, đặt `GoogleService-Info.plist` vào `ios/Runner/`.

## 2. FlutterFire options

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

File `lib/firebase_options.dart` sẽ được ghi đè. Cho đến khi `apiKey` / `projectId` khác `REPLACE_ME`, app chạy **guest** (Firebase tắt).

## 3. Bật Authentication providers

Firebase Console → Authentication → Sign-in method:

- Email/Password
- Phone
- Google
- Facebook (cần App ID + App Secret từ Facebook Developers)

## 4. SHA-1 (Google / Phone trên Android)

```bash
cd android && ./gradlew signingReport
```

Thêm SHA-1 debug vào Firebase Android app settings.

## 5. Email OTP

App ghi mã (hash) vào Firestore `email_otps` và xếp thư vào collection `mail`.

Cài [Trigger Email from Firestore](https://extensions.dev/extensions/firebase/firestore-send-email) trỏ SMTP.

Trong **debug**, màn OTP hiện `Debug code: …` nếu gửi Firestore thành công — không hiện ở release.

Firestore rules tối thiểu (siết lại trước production):

```
match /email_otps/{uid} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
match /users/{uid} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
match /mail/{doc} {
  allow create: if request.auth != null;
}
```

## 6. Facebook

1. Tạo app tại Facebook Developers → Facebook Login.
2. Thêm package name + key hash Android.
3. `android/app/src/main/res/values/strings.xml`:

```xml
<string name="facebook_app_id">YOUR_ID</string>
<string name="fb_login_protocol_scheme">fbYOUR_ID</string>
<string name="facebook_client_token">YOUR_CLIENT_TOKEN</string>
```

4. Khai báo meta-data trong `AndroidManifest.xml` theo [flutter_facebook_auth](https://pub.dev/packages/flutter_facebook_auth).
5. Dán App ID / Secret vào Firebase Facebook provider.

## 7. Phone OTP

- Thêm số test trong Firebase Authentication → Phone → Phone numbers for testing.
- Production: bật App Check / Play Integrity trước khi mở SMS thật.

## 8. Sign in with Apple

Bắt buộc khi ship iOS có Google/Facebook. Phase sau — xem requirements §2.

## 9. Kiểm tra nhanh

1. `flutter run` (guest vẫn vào Home).
2. Home → chạm chip player → Auth hub.
3. Settings → Đăng nhập / Đăng xuất theo trạng thái.
