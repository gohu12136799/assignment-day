# English Question Generator

## 1. Mục tiêu

Tạo dữ liệu cho game English tìm lỗi. Mỗi bộ là một đoạn văn có lỗi, đoạn đúng tương ứng, và đúng **20 lỗi** xác định trước.

Người chơi đọc đoạn sai và tap các từ mình cho là sai. Một lượt có **30 giây**. Hết giờ mới chấm. Trong lúc chơi không báo đúng hay sai.

Requirement này chỉ nói dữ liệu phải có hình dạng nào và 20 lỗi được xác định thế nào. Không sinh lỗi mới khi đang chơi.

---

## 2. Không sinh lúc chơi

- Dữ liệu nằm sẵn trong `lib/data/english_questions.dart`.
- Khi vào `PlayTopic.english`, chọn một bộ có sẵn. Không gọi LLM, không gọi network, không dùng `Random` để bịa thêm lỗi.
- Không sửa chữ trong đoạn văn sau khi lượt đã bắt đầu.
- Đây không phải `Question` trắc nghiệm. Không nhét đoạn này vào `sampleQuestions`. Không dùng `options` hay `correctIndex`.
- Hai câu English trong `lib/data/questions.dart` không phải bộ tìm lỗi.

Ba bộ hiện có là `englishQuynhPassage`, `englishFamilyPassage`, và `englishHobbyPassage` trong `englishPassages`. Mỗi bộ đã có đúng 20 span. Không để game đọc chuỗi thô rồi tự diff. Khi thêm bộ mới, dùng dạng ở mục 4.

---

## 3. Một bộ gồm gì

Mỗi bộ phải có:

- Văn bản sai.
- Văn bản đúng.
- Đúng 20 lỗi. Mỗi lỗi gắn với một hoặc nhiều từ **có trong văn bản sai**.

Ví dụ hình dạng, không phải bộ hợp lệ vì mới có 2 lỗi:

```text
Incorrect:
She go to school every day because she don't like staying home.

Correct:
She goes to school every day because she doesn't like staying home.

Errors:
- index 1: go → goes
- index 7: don't → doesn't
```

Hai chữ `She` giống nhau không được tính lỗi chỉ vì cùng một chuỗi xuất hiện hai lần. Lỗi nhận bằng **chỉ số từ**, không nhận bằng chuỗi.

---

## 4. Dạng dữ liệu

Tách văn bản sai thành từ bằng khoảng trắng. Dấu câu dính vào từ (`world.` là một từ). Không tách dấu câu thành mục tap riêng.

```dart
class EnglishError {
  /// Chỉ số từ trong văn bản sai. [start] inclusive, [end] exclusive.
  final int start;
  final int end;

  /// Đúng các từ incorrectTokens.sublist(start, end), nối bằng một dấu cách.
  final String incorrect;

  /// Cụm thay thế trong văn bản đúng. Rỗng nếu lỗi là từ thừa.
  final String correct;
}

class EnglishPassageSet {
  final String incorrectText;
  final String correctText;
  final List<EnglishError> errors; // length == 20
}
```

`incorrectTokens` là `incorrectText` tách bằng khoảng trắng. Thứ tự token là thứ tự trên màn hình.

---

## 5. Một lỗi là gì

Một lỗi là một span từ liên tiếp trong văn bản sai, khác span tương ứng trong văn bản đúng.

Hợp lệ:

- Đổi một từ: `go` → `goes`.
- Thừa một từ: `as` → rỗng, như `myself as` → `myself`.
- Đổi một cụm: `turn back to` → `turn to`, nếu cả cụm là một lỗi ngữ pháp.
- Chèn từ ở bản đúng phải bám vào một từ sai đang có. `and shared` → `and have shared` là một lỗi trên từ `shared`, phần đúng là `have shared`. Không tạo lỗi không có từ để tap.

Không hợp lệ:

- Lỗi chỉ tồn tại ở văn bản đúng, không sở hữu từ nào trong văn bản sai.
- Hai lỗi dùng chung một chỉ số từ.
- Span chồng lên nhau, hoặc `start >= end`.
- Lỗi thứ 21 chỉ vì dấu câu khác nhau. Dấu câu khác thuộc về từ mang nó.

Áp lần lượt 20 phần `correct` vào các span phải ra đúng chuỗi từ của văn bản đúng. Từ không nằm trong span nào phải giống nhau ở hai bản, cùng vị trí sau khi đã căn span.

---

## 6. Đúng 20 lỗi

Mỗi bộ có đúng 20 phần tử trong `errors`. Không hơn, không kém.

Khi soạn:

- Bản đúng phải là tiếng Anh đúng ngữ pháp. Không nhét lỗi giả vào bản đúng.
- Bản sai chỉ sai ở 20 span đó.
- Nếu cặp nháp chưa đủ 20 lỗi thật, sửa bản sai cho đến khi đủ 20. Không đếm một lỗi hai lần.
- Nếu hơn 20, gộp các từ của cùng một lỗi ngữ pháp thành một span, hoặc bỏ lỗi phụ, cho đến khi còn 20.
- Không đệm bằng từ đúng bị đánh dấu sai.

---

## 7. Từ tap và cụm nhiều từ

Mọi từ trong văn bản sai là một mục tap, cùng kiểu. Không gộp sẵn cụm trên màn hình. Gộp sẵn sẽ lộ chỗ sai trước khi người chơi chọn.

Trong 30 giây:

- Tap từ chưa chọn thì chọn từ đó.
- Tap lại thì bỏ chọn.
- Chỉ đổi màu từ vừa tap. Không tự chọn các từ bên cạnh.
- Chưa chọn: màu đen. Đã chọn: xanh dương.
- Xanh dương nghĩa là người chơi đã chọn, không nghĩa là đúng.

Hết giờ, một lỗi chỉ tính là tìm được khi **mọi** chỉ số từ trong span đều đang được chọn. Chọn một phần span không tính lỗi đó, và cũng không báo đang chọn dở.

Chọn một từ không thuộc span nào thì vẫn xanh dương, nhưng không tăng và không giảm số lỗi đúng.

---

## 8. Thời gian và điểm

Requirement này cố định các số sau. Khi có code, đặt cạnh `questionSeconds` trong `lib/game/game_constants.dart`. Không hardcode trên màn hình.

- Một lượt English: 30 giây, một đoạn.
- Đếm `30 → 0`. Đến 0 thì khóa tap và chấm.
- 20 lỗi đúng = 100%. Mỗi lỗi đúng = 5%.
- `scorePercent = correctErrors / 20 * 100`.
- `correctErrors` là số span mà người chơi đã chọn đủ mọi từ. Không trừ điểm vì chọn nhầm.

```text
20 / 20 → 100%
15 / 20 → 75%
10 / 20 → 50%
5 / 20  → 25%
0 / 20  → 0%
```

---

## 9. Dữ liệu mà màn kết quả cần

Hết giờ, cùng một bộ phải đủ để vẽ hai bản:

- **Correct Answer:** văn bản đúng. Chỉ các cụm `EnglishError.correct` (hoặc chỗ đã xóa từ thừa) được tô xanh lá. Các từ không sửa giữ màu đen.
- **Your Answer:** văn bản sai ban đầu. Chỉ các từ người chơi còn chọn được tô xanh dương, kể cả từ chọn nhầm.

Không tô cả đoạn. Không dùng xanh dương để đánh dấu đáp án đúng. Không hiện xanh lá trong lúc còn giờ.

Màn kết quả đọc được từ dữ liệu:

```text
X / 20 errors found
scorePercent%
```

`X` là `correctErrors`. Mẫu số luôn là 20.

---

## 10. Kiểm tra trước khi coi bộ là xong

Một bộ chưa xong nếu thiếu một mục:

- `errors.length == 20`.
- Span đã sort, không chồng, mỗi span có ít nhất một từ sai.
- `incorrect` khớp đúng substring của token sai.
- Ghép 20 phần sửa ra đúng `correctText` sau khi tách từ.
- Không còn lỗi nào trong bản sai mà chưa nằm trong `errors`.
- Không có lỗi nào mà người chơi không thể tap.

---

## 11. Ngoài phạm vi

Requirement này không quy định:

- Cách chọn bộ nào khi trong file có nhiều bộ.
- Animation, âm thanh, combo, bảng xếp hạng, lưu điểm cao.
- UI chi tiết ngoài màu đen, xanh dương, xanh lá ở mục 7 và 9.
