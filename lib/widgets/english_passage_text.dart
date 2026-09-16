import 'package:flutter/material.dart';

import '../models/english_passage.dart';
import '../theme/app_colors.dart';

/// Văn bản sai, mỗi từ tap riêng. Xanh dương chỉ nghĩa là đã chọn.
class EnglishSelectableText extends StatelessWidget {
  const EnglishSelectableText({
    super.key,
    required this.words,
    required this.selected,
    required this.enabled,
    required this.onToggle,
  });

  final List<String> words;
  final Set<int> selected;
  final bool enabled;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 6,
      children: [
        for (var i = 0; i < words.length; i++)
          GestureDetector(
            onTap: enabled ? () => onToggle(i) : null,
            child: Text(
              words[i],
              style: TextStyle(
                color: selected.contains(i)
                    ? AppColors.answerBlue
                    : Colors.black,
                fontSize: 17,
                fontWeight: selected.contains(i)
                    ? FontWeight.w700
                    : FontWeight.w500,
                height: 1.45,
              ),
            ),
          ),
      ],
    );
  }
}

/// Bản đúng: cụm sửa màu xanh lá. Từ không sửa màu đen.
class EnglishCorrectText extends StatelessWidget {
  const EnglishCorrectText({super.key, required this.passage});

  final EnglishPassageSet passage;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(children: _spans(passage)));
  }

  static List<TextSpan> _spans(EnglishPassageSet passage) {
    final words = passage.incorrectText.split(' ');
    const base = TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w500,
      height: 1.45,
    );
    const marked = TextStyle(
      color: AppColors.answerGreen,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      height: 1.45,
    );
    final spans = <TextSpan>[];
    var index = 0;
    for (final error in passage.errors) {
      if (index < error.start) {
        spans.add(
          TextSpan(
            text: '${words.sublist(index, error.start).join(' ')} ',
            style: base,
          ),
        );
      }
      final replacement = error.correct.isEmpty ? '—' : error.correct;
      spans.add(TextSpan(text: '$replacement ', style: marked));
      index = error.end;
    }
    if (index < words.length) {
      spans.add(TextSpan(text: words.sublist(index).join(' '), style: base));
    }
    return spans;
  }
}

/// Bản sai gốc. Từ người chơi đã chọn màu xanh dương, kể cả chọn nhầm.
class EnglishYourAnswerText extends StatelessWidget {
  const EnglishYourAnswerText({
    super.key,
    required this.words,
    required this.selected,
  });

  final List<String> words;
  final Set<int> selected;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < words.length; i++)
            TextSpan(
              text: i == words.length - 1 ? words[i] : '${words[i]} ',
              style: TextStyle(
                color: selected.contains(i)
                    ? AppColors.answerBlue
                    : Colors.black,
                fontSize: 17,
                fontWeight: selected.contains(i)
                    ? FontWeight.w700
                    : FontWeight.w500,
                height: 1.45,
              ),
            ),
        ],
      ),
    );
  }
}
