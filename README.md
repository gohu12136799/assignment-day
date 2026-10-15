# Trường học Hoa Sen

App Flutter cho trẻ vào lớp, điểm danh và làm một bài kiểm tra. Ba lớp: Toán, Logic, Tiếng Anh. Dưới 5 điểm thì cô khẽ tay, trên 9 điểm thì được khen. Đi học đều và làm bài trên 9 điểm được kẹo để đổi bộ đồ.

Tên và lớp ghi trên máy bằng `SharedPreferences`. Đăng nhập (email, điện thoại, Google, Facebook) là tùy chọn.

## Chạy

```bash
flutter pub get
flutter run
```

Không có điện thoại thì chọn macOS hoặc Chrome khi Flutter hỏi thiết bị.

## Build APK để cài máy

```bash
flutter build apk
```

File nằm ở `build/app/outputs/flutter-apk/app-release.apk`.

## Cấu trúc

```text
lib/
├── main.dart                 # mở app, bọc đăng nhập
├── locale_controller.dart    # tiếng Việt / tiếng Anh
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   ├── game_screen.dart      # toán
│   ├── english_game_screen.dart
│   ├── logic_game_screen.dart
│   ├── result_screen.dart
│   ├── auth/                 # đăng nhập
│   └── school/               # đăng ký, vào lớp, khen / phạt
├── school/                   # lớp, tên, điểm danh, kẹo, bộ đồ
├── game/                     # đồng hồ, câu hiện tại, chấm điểm
├── data/                     # ngân hàng câu tiếng Anh, logic
├── models/                   # câu hỏi, chủ đề
├── widgets/                  # chữ cong, đáp án toán, đoạn tiếng Anh
├── theme/                    # màu, font
├── l10n/                     # chữ trên màn hình
└── auth/                     # Firebase Auth
assets/images/school/         # ảnh trường, thầy cô, bộ đồ
test/
```

Đường đi: splash → đăng ký lớp (lần đầu) hoặc home → vào lớp → bài kiểm tra → màn nhận xét.

## Yêu cầu

- Flutter SDK (stable), Dart `^3.13.3`
- Android Studio / Android SDK để build APK
- Xcode (macOS) để build iOS
