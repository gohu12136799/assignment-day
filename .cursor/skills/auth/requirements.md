# Auth / Đăng nhập

## 1. Mục tiêu

Cho phép người chơi đăng nhập trước khi dùng tính năng cần tài khoản, và giữ phiên đăng nhập khi mở lại app.

Các cách đăng nhập bắt buộc:

- Google
- Facebook
- Email + mật khẩu
- Số điện thoại + mật khẩu

Xác minh:

- Đăng ký / xác minh bằng **email** phải gửi **mã xác thực** (OTP email), không chỉ link bấm.
- Đăng ký / xác minh bằng **SĐT** phải gửi **OTP SMS**.

Requirement này quyết định hành vi sản phẩm và ranh giới kỹ thuật. Không quyết định pixel UI chi tiết; UI theo skill `brain-rush-ui-ux` và `design-system`.

---

## 2. Provider

Dùng **Firebase Authentication** làm nguồn chân lý phiên đăng nhập.

- Không tự hash mật khẩu trên client.
- Không tự gửi SMS từ app.
- Không tự làm OAuth Google/Facebook từ đầu.
- Backend game (điểm, xếp hạng) nếu có sau này chỉ **verify Firebase ID token**, không tạo hệ user song song.

Package Flutter dự kiến:

- `firebase_core`
- `firebase_auth`
- `google_sign_in`
- `flutter_facebook_auth`

Nếu lên App Store và đã có Google/Facebook, phải thêm **Sign in with Apple** (yêu cầu Apple). Chưa ship iOS thì có thể để phase sau, nhưng không được quên trong backlog.

---

## 3. Khi nào bắt buộc đăng nhập

### Bắt buộc đăng nhập

- Lưu điểm / bảng xếp hạng gắn user (khi tính năng đó có).
- Đồng bộ thành tích / hồ sơ giữa các máy (khi tính năng đó có).
- Nút **Đăng xuất** trên Settings chỉ hiện và hoạt động khi đang đăng nhập.

### Cho chơi khách (guest)

- Splash → Home vẫn vào được **không đăng nhập**.
- Chơi Math / Logic / English / Mixed / Random vẫn được khi chưa login.
- Điểm guest chỉ local. Không ghi lên bảng xếp hạng online cho đến khi đăng nhập.

Không khóa cả app sau splash bằng màn login. Login là màn riêng, mở từ Home / Settings / khi user chạm tính năng cần tài khoản.

---

## 4. Các luồng đăng nhập

### 4.1 Google

1. User bấm Đăng nhập với Google.
2. Chọn tài khoản Google trên thiết bị / trình duyệt.
3. Firebase tạo hoặc lấy lại user.
4. Vào app với phiên đã đăng nhập.

Không hỏi mật khẩu Brain Rush. Không gửi OTP sau Google nếu email Google đã verified.

### 4.2 Facebook

1. User bấm Đăng nhập với Facebook.
2. OAuth Facebook thành công.
3. Firebase tạo hoặc lấy lại user.
4. Vào app với phiên đã đăng nhập.

Cần Facebook Developer app, hash key Android, URL scheme iOS. Thiếu cấu hình thì nút Facebook phải báo lỗi rõ, không crash.

### 4.3 Email + mật khẩu

**Đăng ký**

1. Nhập email + mật khẩu + xác nhận mật khẩu.
2. Validate phía client (mục 6).
3. Tạo tài khoản Firebase.
4. Gửi **mã OTP email** (6 chữ số, hết hạn có thời hạn).
5. User nhập mã → xác minh email → đăng nhập xong.

**Đăng nhập**

1. Nhập email + mật khẩu.
2. Đúng → vào app.
3. Sai → báo lỗi, không lộ “email tồn tại hay không” nếu tránh được (thông báo chung: email hoặc mật khẩu không đúng).

**Email chưa xác minh**

- Không cho coi là đăng nhập đầy đủ nếu chưa nhập đúng OTP.
- Cho phép **Gửi lại mã** với cooldown (ví dụ 60 giây).

### 4.4 Số điện thoại + mật khẩu

**Đăng ký**

1. Nhập SĐT (chuẩn E.164, ví dụ `+84…`) + mật khẩu + xác nhận mật khẩu.
2. Gửi **OTP SMS** qua Firebase Phone Auth.
3. User nhập OTP đúng.
4. Gắn / tạo credential mật khẩu cho số đó (hoặc tạo user phone rồi cập nhật password theo API Firebase hỗ trợ).
5. Đăng nhập xong.

**Đăng nhập**

Hai cách chấp nhận được, chọn **một** và giữ nhất quán:

- **A (khuyến nghị):** SĐT + mật khẩu. Nếu Firebase chưa hỗ trợ trực tiếp phone+password như email, dùng custom claim / Cloud Function hoặc lưu liên kết phone↔email nội bộ — ghi rõ trong design kỹ thuật trước khi code.
- **B (phase 1 đã chọn):** Đăng nhập bằng SĐT + OTP mỗi lần; mật khẩu lúc đăng ký được gắn bằng `User.updatePassword` để dùng sau khi link email / phase 2.

**OTP SMS**

- 6 chữ số.
- Có hạn dùng.
- Có **Gửi lại** với cooldown.
- Sai OTP quá nhiều lần → khóa tạm / báo thử lại sau (theo giới hạn Firebase).

---

## 5. Liên kết tài khoản (account linking)

Một người có thể có nhiều phương thức trên **cùng một Firebase uid**:

- Đã Google → sau đó gắn email/password hoặc SĐT.
- Đã email → sau đó gắn Google / Facebook / SĐT.

Khi provider trả về email/SĐT đã thuộc user khác → báo xung đột, không ghi đè im lặng.

Phase 1 có thể chỉ hỗ trợ đăng nhập riêng từng cách; linking là phase 2 nếu chưa kịp. Ghi rõ trong PR.

---

## 6. Validate form

| Trường | Rule |
|---|---|
| Email | Định dạng email hợp lệ, trim khoảng trắng |
| SĐT | Bắt buộc mã quốc gia; lưu/gửi dạng E.164 |
| Mật khẩu | Tối thiểu 8 ký tự; có chữ và số |
| Xác nhận mật khẩu | Khớp mật khẩu |
| OTP | Đúng 6 chữ số |

Lỗi hiện dưới field hoặc SnackBar branded. Copy có cả `vi` và `en` trong arb. Không hardcode tiếng Việt trong Dart.

---

## 7. Phiên đăng nhập

- Mở app lại vẫn giữ session nếu Firebase còn token hợp lệ.
- Splash có thể chờ auth state sẵn sàng trước khi vào Home (không làm loading splash thành spinner vô hạn; timeout có thông báo).
- Home hiện tên / avatar từ user khi đã login; chưa login giữ `l10n.playerName` như hiện tại.
- Settings:
  - Đã login: **Đăng xuất** gọi Firebase signOut, về trạng thái guest, không crash.
  - Chưa login: nút Đăng xuất ẩn hoặc đổi thành **Đăng nhập** mở màn auth.

Không dùng `comingSoon` cho Đăng xuất sau khi auth đã ship.

---

## 8. Bảo mật và chống lạm dụng

- Bật **App Check** (hoặc ít nhất reCAPTCHA / Play Integrity theo hướng dẫn Firebase Phone Auth) trước khi mở OTP SMS production.
- Không log mật khẩu, OTP, token ra console release.
- Không commit `google-services.json` / `GoogleService-Info.plist` có secret không được phép vào git công khai nếu repo public; với repo private team, vẫn không commit key Facebook App Secret.
- Giới hạn gửi lại OTP (cooldown). Không cho spam SMS từ UI.

---

## 9. Màn hình và điều hướng

Màn tối thiểu:

1. **Welcome / Auth hub** — Google, Facebook, Email, SĐT.
2. **Email sign in**
3. **Email sign up**
4. **Email OTP verify**
5. **Phone sign in / sign up** (có thể gộp)
6. **Phone OTP verify**

Điều hướng:

- Từ Home (chip player hoặc nút) hoặc Settings → Auth hub.
- Auth thành công → `pop` về màn trước hoặc về Home; không xếp chồng nhiều Auth hub.
- Nút Back luôn thoát được về guest play, trừ khi đang ở giữa bước OTP bắt buộc của flow đăng ký đang mở — khi đó Back hủy flow và không để user “nửa đăng ký”.

UI: nền / nút theo brand (`AppColors`, `MenuRow` hoặc nút filled vàng/xanh đã dùng). Không để FirebaseUI mặc định nếu phá brand; dùng FirebaseUI chỉ khi skin được cho khớp Brain Rush.

---

## 10. i18n

Mọi chuỗi user-facing thêm vào `app_en.arb` và `app_vi.arb` rồi gen l10n.

Tối thiểu có key cho:

- Đăng nhập / Đăng ký / Đăng xuất
- Tiếp tục với Google / Facebook
- Email, số điện thoại, mật khẩu, xác nhận mật khẩu
- Gửi mã / Nhập mã / Gửi lại mã
- Lỗi mạng, lỗi sai OTP, lỗi sai mật khẩu, SĐT không hợp lệ

---

## 11. Ngoài phạm vi (phase này không làm)

- Quên mật khẩu / reset password (làm phase sau; Firebase hỗ trợ email reset).
- Đăng nhập ẩn danh Firebase anonymous (guest local đủ).
- MFA / 2FA nâng cao.
- Xóa tài khoản (cần khi lên Store; backlog riêng).
- Hồ sơ sửa tên/avatar đầy đủ.
- Bảng xếp hạng online (auth chỉ chuẩn bị uid).

---

## 12. Tiêu chí xong (Definition of Done)

- [ ] Google đăng nhập được trên Android debug.
- [ ] Facebook đăng nhập được trên Android debug (sau khi có app Facebook).
- [ ] Email đăng ký → nhận OTP → nhập đúng → vào app.
- [ ] Email đăng nhập lại bằng mật khẩu được.
- [ ] SĐT nhận OTP SMS (test number Firebase chấp nhận được trên CI/dev).
- [ ] Session còn sau hot restart / mở lại app.
- [ ] Đăng xuất từ Settings về guest; Home không còn dữ liệu user cũ trên UI.
- [ ] Copy EN + VI.
- [ ] Không còn `comingSoon` trên Đăng xuất khi đã login.
- [ ] Tài liệu setup (Firebase console, SHA-1, Facebook, Apple nếu có) nằm cạnh skill hoặc README ngắn trong folder này.

---

## 13. Thứ tự implement đề xuất

1. Firebase project + `firebase_core` / `firebase_auth` + auth state trên app.
2. Email + password + OTP email.
3. Phone OTP (+ quyết định A/B mật khẩu ở mục 4.4).
4. Google.
5. Facebook.
6. Wire Home / Settings / Đăng xuất.
7. Sign in with Apple khi chuẩn bị iOS Store.
8. Account linking (nếu chưa làm ở bước 2–5).

Không làm cả 8 bước trong một PR. Mỗi PR ship được một provider hoặc một wire màn hình.
