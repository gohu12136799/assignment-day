# Logic Game – Image Puzzle

## 1. Mục tiêu

Khi user chọn chủ đề **Logic**, hệ thống chuyển sang màn hình chơi game Logic.

Game Logic sử dụng câu hỏi dạng hình ảnh. Mỗi câu hỏi gồm:

- 1 hình ảnh câu hỏi.
- 6 hình ảnh đáp án.
- User chọn 1 đáp án.
- Mỗi câu có 10 giây.
- Khi user chọn đáp án, chuyển ngay sang câu tiếp theo.
- Sau khi hoàn thành toàn bộ câu hỏi, hiển thị màn hình kết quả.

---

## 2. Điều hướng

Khi user chọn:

```text
Logic
```

tại màn hình chọn chủ đề:

```text
Topic Select
    ↓
Logic
    ↓
Logic Game Screen
```

Không hiển thị màn hình trung gian.

---

## 3. Câu hỏi

Hình ảnh câu hỏi được lấy từ assets:

```text
assets/images/question_logic/Q1/Q1.png
assets/images/question_logic/Q2/Q2.png
assets/images/question_logic/Q3/Q3.png
```

Mỗi file tương ứng với một câu hỏi.

Ví dụ:

```text
Question 1
→ assets/images/question_logic/Q1/Q1.png

Question 2
→ assets/images/question_logic/Q2/Q2.png

Question 3
→ assets/images/question_logic/Q3/Q3.png
```

Hình ảnh câu hỏi phải được hiển thị bên trong **1 card**.

---

## 4. Question Card

Màn hình game phải có một card dành cho câu hỏi.

Card chứa:

```text
┌─────────────────────────────┐
│                             │
│       Question Image        │
│                             │
│       Q1.png                │
│                             │
└─────────────────────────────┘
```

Hình ảnh phải được lấy từ assets tương ứng với câu hỏi hiện tại.

Không hiển thị câu hỏi dưới dạng text nếu asset đã chứa toàn bộ nội dung câu hỏi.

---

## 5. Answer Card

Bên dưới Question Card hiển thị **1 card chứa danh sách 6 đáp án**.

Các đáp án của câu hỏi được lấy từ thư mục tương ứng:

```text
assets/images/question_logic/Q1/answer/
assets/images/question_logic/Q2/answer/
assets/images/question_logic/Q3/answer/
```

Mỗi câu hỏi có chính xác:

```text
6 answer images
```

Ví dụ:

```text
assets/images/question_logic/Q1/answer/

1.png
2.png
3.png
4.png
5.png
6.png
```

Tên file thực tế có thể theo cấu trúc assets hiện có, nhưng mỗi câu phải cung cấp đủ 6 hình ảnh đáp án.

---

## 6. Answer Item

Mỗi đáp án gồm:

```text
Radio Button + Answer Image
```

Ví dụ:

```text
○  [ Answer Image 1 ]

○  [ Answer Image 2 ]

○  [ Answer Image 3 ]

○  [ Answer Image 4 ]

○  [ Answer Image 5 ]

○  [ Answer Image 6 ]
```

User có thể chọn **một đáp án duy nhất**.

---

## 7. Trạng thái đáp án

Khi user chọn một đáp án:

- Radio button được selected.
- Answer item được highlight bằng **màu xanh dương**.
- Chỉ có một đáp án được selected tại một thời điểm.

Ví dụ:

```text
○  Answer 1

🔵 Answer 2  ← selected

○  Answer 3

○  Answer 4

○  Answer 5

○  Answer 6
```

Màu xanh dương chỉ thể hiện **đáp án user đang chọn**.

Không hiển thị đúng/sai tại màn hình chơi.

---

## 8. Thời gian mỗi câu

Mỗi câu hỏi có thời gian:

```text
10 giây
```

Countdown được reset về 10 giây khi chuyển sang câu hỏi mới.

Ví dụ:

```text
Question 1
10 → 9 → 8 → ... → 1 → 0
```

Nếu user chọn đáp án trước khi hết 10 giây:

```text
Select Answer
      ↓
Next Question
```

Không chờ hết thời gian.

---

## 9. Timeout

Nếu user không chọn đáp án trong 10 giây:

```text
10 seconds expired
        ↓
Next Question
```

Không cho user chọn đáp án của câu đã hết thời gian.

Câu không có lựa chọn được tính là **không trả lời**.

---

## 10. Chuyển câu

Khi user chọn đáp án:

```text
User selects answer
        ↓
Save selected answer
        ↓
Immediately move to next question
```

Không hiển thị màn hình feedback đúng/sai giữa các câu.

Không delay trước khi chuyển câu.

---

## 11. Thứ tự câu hỏi

Các câu hỏi được chơi theo thứ tự:

```text
Q1
 ↓
Q2
 ↓
Q3
```

Mỗi câu sử dụng đúng asset tương ứng.

---

## 12. Kết thúc game

Sau khi user hoàn thành câu hỏi cuối cùng:

```text
Last Question
      ↓
Finish Game
      ↓
Result Screen
```

Nếu câu cuối cùng hết thời gian cũng phải kết thúc game sau khi xử lý timeout.

---

## 13. Result Screen

Sau khi hoàn thành toàn bộ câu hỏi, chuyển sang màn hình kết quả hiện tại của game.

Result Screen phải nhận được kết quả của phiên chơi Logic, bao gồm tối thiểu:

- Số câu đã trả lời.
- Tổng số câu.
- Kết quả của từng câu để phục vụ việc tính điểm/hiển thị kết quả.

Requirement này **không quy định cách tính điểm cụ thể**. Logic scoring sẽ được định nghĩa ở requirement riêng nếu cần.

---

## 14. Asset Structure

Cấu trúc assets dự kiến:

```text
assets/
└── images/
    └── question_logic/
        ├── Q1/
        │   ├── Q1.png
        │   └── answer/
        │       ├── 1.png
        │       ├── 2.png
        │       ├── 3.png
        │       ├── 4.png
        │       ├── 5.png
        │       └── 6.png
        │
        ├── Q2/
        │   ├── Q2.png
        │   └── answer/
        │       ├── 1.png
        │       ├── 2.png
        │       ├── 3.png
        │       ├── 4.png
        │       ├── 5.png
        │       └── 6.png
        │
        └── Q3/
            ├── Q3.png
            └── answer/
                ├── 1.png
                ├── 2.png
                ├── 3.png
                ├── 4.png
                ├── 5.png
                └── 6.png
```

---

## 15. Gameplay Flow

```text
Topic Select
     │
     │ User chọn Logic
     ▼
Logic Game Screen
     │
     ├── Question Card
     │      └── Q1.png
     │
     ├── Answer Card
     │      ├── Answer 1
     │      ├── Answer 2
     │      ├── Answer 3
     │      ├── Answer 4
     │      ├── Answer 5
     │      └── Answer 6
     │
     └── Timer: 10s
              │
              ├── User chọn
              │      ↓
              │   Next Question
              │
              └── Timeout
                     ↓
                  Next Question
                     │
                     ▼
                  Q2 → Q3
                     │
                     ▼
                Result Screen
```

---

## 16. Tên file đang có

Mục 5 cho phép dùng tên file thật trên đĩa. Đừng tìm `1.png`. Mỗi câu đã có đủ 6 ảnh:

```text
assets/images/question_logic/Q1/Q1.png
assets/images/question_logic/Q1/answer/1.png
assets/images/question_logic/Q1/answer/2.png
assets/images/question_logic/Q1/answer/3.png
assets/images/question_logic/Q1/answer/4.png
assets/images/question_logic/Q1/answer/5.png
assets/images/question_logic/Q1/answer/6.png
```

`Q2` và `Q3` cùng kiểu: `Q2.png` / `Q3.png`, đáp án `answer/1.png` đến `answer/6.png`.

Thứ tự đáp án là `1` → `6`. Không xáo thứ tự câu và không xáo thứ tự ảnh.

`pubspec.yaml` chưa khai báo thư mục này. Khi làm màn chơi, đăng ký `assets/images/question_logic/` rồi mới load ảnh.

Không lấy 2 câu Logic chữ trong `lib/data/questions.dart`. Không dùng `Question.options` hay 4 thẻ A–D. Không tự bịa ảnh. Không chấm điểm trong requirement này.
