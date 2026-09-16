# Math Quiz Generator Skill

## 1. Mục tiêu

Tạo các câu hỏi toán tính nhanh dành cho game mobile.

Người chơi cần có khả năng đọc, tính toán và chọn đáp án trong khoảng **3 giây**.

Các câu hỏi phải có độ khó vừa đủ để người chơi phải tính nhanh, nhưng không sử dụng các số quá lớn.

---

## 2. Phạm vi phép tính

Chỉ sử dụng 4 loại phép tính:

* Cộng `+`
* Trừ `-`
* Nhân `×`
* Chia `÷`

Một câu hỏi có thể chứa:

* 1 phép tính
* Hoặc tối đa 2 phép tính

Không được tạo câu hỏi có hơn 2 phép tính.

### Ví dụ hợp lệ

```text
12 + 8 = ?
15 - 7 = ?
6 × 4 = ?
24 ÷ 6 = ?

8 + 5 × 2 = ?
20 - 6 + 3 = ?
18 ÷ 3 + 4 = ?
7 × 3 - 5 = ?
```

### Ví dụ không hợp lệ

```text
5 + 3 + 2 + 1 = ?
10 × 2 - 3 + 4 = ?
```

Vì có nhiều hơn 2 phép tính.

---

## 3. Giới hạn số

Các số được sử dụng trong phép tính phải **nhỏ hơn 30**.

Allowed:

```text
1 → 29
```

Không được sử dụng số từ 30 trở lên làm operand.

Ví dụ:

```text
12 + 8
7 × 4
24 ÷ 6
29 - 13
```

---

## 4. Luật phép chia

Phép chia phải cho ra **kết quả là số nguyên**.

Không tạo phép chia có dư.

Hợp lệ:

```text
24 ÷ 6 = 4
18 ÷ 3 = 6
20 ÷ 5 = 4
```

Không hợp lệ:

```text
20 ÷ 3
17 ÷ 5
```

Không tạo phép chia cho `0`.

---

## 5. Luật kết quả

Đáp án đúng phải:

* Là số nguyên.
* Lớn hơn hoặc bằng `0`.
* Nhỏ hơn `100`.

```text
0 <= answer < 100
```

Không tạo câu hỏi có đáp án đúng từ `100` trở lên.

Ví dụ:

```text
9 × 9 = 81
```

Hợp lệ.

```text
15 × 8 = 120
```

Không hợp lệ.

---

## 6. Ưu tiên tính toán

Khi câu hỏi có 2 phép tính, áp dụng thứ tự ưu tiên toán học thông thường:

1. Nhân `×` và chia `÷`
2. Cộng `+` và trừ `-`

Ví dụ:

```text
8 + 4 × 2 = ?
```

Đáp án:

```text
16
```

Không phải `24`.

---

## 7. Sinh đáp án

Mỗi câu hỏi phải có chính xác **10 đáp án lựa chọn**.

Trong 10 đáp án:

* 1 đáp án đúng.
* 9 đáp án sai.
* Tất cả đáp án đều là số nguyên.
* Tất cả đáp án đều nằm trong khoảng `0 → 99`.

### Độ khó của đáp án sai

Để tăng độ khó, đáp án sai phải rất gần đáp án đúng.

Mỗi đáp án sai phải có sai số từ 1 đến 5 so với đáp án đúng.

Sai số chỉ 1 hoặc 2 thì quanh một đáp án đúng chỉ có tối đa 4 số khác, không đủ 9 đáp án sai. Sai số tối đa 5 thì có đủ chỗ cho 9 đáp án sai khác nhau.

Ví dụ đáp án đúng:

```text
24
```

Các đáp án sai có thể là:

```text
19
20
21
22
23
25
26
27
28
```

Không được tạo đáp án sai cách đáp án đúng từ 6 đơn vị trở lên.

Ví dụ không hợp lệ:

```text
5
10
15
40
80
```

nếu đáp án đúng là `24`.

### Trường hợp đáp án đúng nằm gần biên

Đáp án sai phải nằm trong `0 → 99` và lệch tối đa 5 so với đáp án đúng.

Nếu trong khoảng đó không đủ 9 số khác nhau, không được lấy số xa hơn và không được trùng. Phải regenerate câu hỏi cho đến khi đáp án đúng đủ chỗ để tạo 9 đáp án sai.

Không được tạo đáp án âm.

Không được tạo đáp án từ `100` trở lên.

---

## 8. Không trùng đáp án

10 đáp án trong cùng một câu phải là các giá trị khác nhau.

Ví dụ không hợp lệ:

```text
23
24
24
25
26
...
```

Nếu không thể tạo đủ 10 đáp án thỏa mãn tất cả điều kiện, phải regenerate câu hỏi hoặc điều chỉnh cách sinh đáp án.

---

## 9. Random vị trí đáp án đúng

Đáp án đúng không được luôn nằm ở cùng một vị trí.

Sau khi tạo đủ 10 đáp án:

* Random vị trí của đáp án đúng.
* Random thứ tự toàn bộ 10 đáp án.

Ví dụ:

```text
Question:
12 + 12 = ?

Options:
[25, 22, 24, 26, 23, 21, 27, 20, 28, 19]

Correct answer:
24
```

Ở câu tiếp theo, đáp án đúng phải có khả năng nằm ở vị trí khác.

---

# 10. Session

Một session của game gồm chính xác:

```text
10 câu hỏi
```

Mỗi câu có thời gian tối đa:

```text
3 giây
```

Flow:

```text
Question 1
   ↓
3 seconds OR user selects answer
   ↓
Question 2
   ↓
3 seconds OR user selects answer
   ↓
...
   ↓
Question 10
   ↓
3 seconds OR user selects answer
   ↓
Result Screen
```

---

## 11. Khi người chơi chọn đáp án

Nếu người chơi chọn một đáp án:

1. Ghi nhận đáp án được chọn.
2. Xác định đúng hoặc sai.
3. Không cần chờ hết 3 giây.
4. Chuyển sang câu tiếp theo.

Ví dụ:

```text
Question 3
User selects answer
       ↓
Check answer
       ↓
Question 4
```

---

## 12. Khi hết 3 giây

Nếu người chơi không chọn đáp án trong vòng 3 giây:

1. Câu hỏi được đánh dấu là `timeout`.
2. Không ghi nhận đáp án đúng.
3. Chuyển sang câu tiếp theo.

Ví dụ:

```text
Question 3
   ↓
3 seconds
   ↓
Timeout
   ↓
Question 4
```

---

## 13. Câu thứ 10

Sau khi câu thứ 10 kết thúc:

* Nếu user chọn đáp án → chuyển sang Result Screen.
* Nếu timeout → chuyển sang Result Screen sau khi xử lý timeout.

Không tạo câu thứ 11 trong session.

---

# 14. Session data

Mỗi session nên lưu:

```text
totalQuestions = 10
currentQuestion
correctAnswers
wrongAnswers
timeoutAnswers
score
```

Mỗi câu nên lưu:

```text
question
options
correctAnswer
selectedAnswer
isCorrect
isTimeout
```

Ví dụ:

```json
{
  "question": "8 × 3 = ?",
  "options": [24, 23, 25, 22, 26, 21, 27, 20, 28, 29],
  "correctAnswer": 24,
  "selectedAnswer": 25,
  "isCorrect": false,
  "isTimeout": false
}
```

---

# 15. Validation

Mỗi câu hỏi phải được validate trước khi đưa cho người chơi.

Kiểm tra:

* [ ] Chỉ sử dụng `+`, `-`, `×`, `÷`.
* [ ] Tối đa 2 phép tính.
* [ ] Mọi operand < 30.
* [ ] Không chia cho 0.
* [ ] Phép chia cho kết quả nguyên.
* [ ] Đáp án đúng >= 0.
* [ ] Đáp án đúng < 100.
* [ ] Có chính xác 10 đáp án.
* [ ] Có đúng 1 đáp án đúng.
* [ ] Có 9 đáp án sai.
* [ ] Các đáp án không trùng nhau.
* [ ] Mỗi đáp án sai lệch từ 1 đến 5 so với đáp án đúng.
* [ ] Không có đáp án < 0.
* [ ] Không có đáp án >= 100.
* [ ] Vị trí đáp án đúng được random.

Nếu câu hỏi không thỏa mãn validation thì không được đưa vào game.
