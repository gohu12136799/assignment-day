import '../models/question.dart';

/// Bank câu hỏi mẫu — sau này bạn có thể thêm nhiều câu hơn.
const sampleQuestions = <Question>[
  Question(
    type: QuestionType.math,
    prompt: '8 + 7 = ?',
    options: ['14', '15', '16', '17'],
    correctIndex: 1,
  ),
  Question(
    type: QuestionType.math,
    prompt: '15 × 4 − 20 = ?',
    options: ['40', '45', '50', '60'],
    correctIndex: 0,
  ),
  Question(
    type: QuestionType.math,
    prompt: '1/2 + 1/4 = ?',
    options: ['1/6', '2/6', '3/4', '1/8'],
    correctIndex: 2,
  ),
  Question(
    type: QuestionType.math,
    prompt: '9 × 6 = ?',
    options: ['45', '54', '56', '63'],
    correctIndex: 1,
  ),
  Question(
    type: QuestionType.logic,
    prompt: 'Nếu tất cả A là B, và một số B là C, thì điều nào chắc chắn đúng?',
    options: [
      'Tất cả A là C',
      'Một số A có thể là C',
      'Không A nào là C',
      'Tất cả C là A',
    ],
    correctIndex: 1,
  ),
  Question(
    type: QuestionType.english,
    prompt: 'Chọn câu đúng ngữ pháp:',
    options: [
      'She go to school everyday.',
      'She goes to school every day.',
      'She going to school every day.',
      'She gone to school every day.',
    ],
    correctIndex: 1,
  ),
  Question(
    type: QuestionType.english,
    prompt: 'Tìm lỗi: "He don\'t like coffee."',
    options: [
      'like → likes',
      'don\'t → doesn\'t',
      'coffee → coffees',
      'Không có lỗi',
    ],
    correctIndex: 1,
  ),
  Question(
    type: QuestionType.logic,
    prompt: 'Số nào tiếp theo: 2, 4, 8, 16, ?',
    options: ['18', '24', '32', '30'],
    correctIndex: 2,
  ),
];
