import '../models/english_passage.dart';

/// Các bộ tìm lỗi. Mỗi bộ có đúng [EnglishPassageSet.errorCount] lỗi.
const englishPassages = [
  englishQuynhPassage,
  englishFamilyPassage,
  englishHobbyPassage,
];

/// Đoạn giới thiệu, 20 lỗi đã gắn chỉ số từ.
const englishQuynhPassage = EnglishPassageSet(
  incorrectText: 'My name is Quynh, and I am currently a marketing executive on Smartcom English. I consider myself as a dedicated person whom always strives for professionalism in every projects I undertakes. Over the past few year, I have develop strong interpersonal skills through work with diverse teams. My daily routine involves to analyze market trends and create engaging content for social media. I am also passionate on learning languages, as I believe it open new doors for my career. Currently, I am focusing on a path to constant improvement to become an expert on my field. I enjoy challenges because it helps me grow both personally and professionally. In the next five years, I hope to lead a creative team in a international environment. Learning by Smartcom AI have been a game-changer for my writing skill lately. I am confident that with hard work, I will achieve my long-term goals.',
  correctText: 'My name is Quynh, and I am currently a marketing executive at Smartcom English. I consider myself a dedicated person who always strives for professionalism in every project I undertake. Over the past few years, I have developed strong interpersonal skills through working with diverse teams. My daily routine involves analyzing market trends and creating engaging content for social media. I am also passionate about learning languages, as I believe it opens new doors for my career. Currently, I am focusing on a path of constant improvement to become an expert in my field. I enjoy challenges because they help me grow both personally and professionally. In the next five years, I hope to lead a creative team in an international environment. Learning with Smartcom AI has been a game-changer for my writing skills lately. I am confident that with hard work, I will achieve my long-term goals.',
  errors: [
    EnglishError(start: 11, end: 12, incorrect: 'on', correct: 'at'),
    EnglishError(start: 17, end: 18, incorrect: 'as', correct: ''),
    EnglishError(start: 21, end: 22, incorrect: 'whom', correct: 'who'),
    EnglishError(start: 28, end: 29, incorrect: 'projects', correct: 'project'),
    EnglishError(
      start: 30,
      end: 31,
      incorrect: 'undertakes.',
      correct: 'undertake.',
    ),
    EnglishError(start: 35, end: 36, incorrect: 'year,', correct: 'years,'),
    EnglishError(
      start: 38,
      end: 39,
      incorrect: 'develop',
      correct: 'developed',
    ),
    EnglishError(start: 43, end: 44, incorrect: 'work', correct: 'working'),
    EnglishError(
      start: 51,
      end: 53,
      incorrect: 'to analyze',
      correct: 'analyzing',
    ),
    EnglishError(start: 56, end: 57, incorrect: 'create', correct: 'creating'),
    EnglishError(start: 66, end: 67, incorrect: 'on', correct: 'about'),
    EnglishError(start: 73, end: 74, incorrect: 'open', correct: 'opens'),
    EnglishError(start: 86, end: 87, incorrect: 'to', correct: 'of'),
    EnglishError(start: 93, end: 94, incorrect: 'on', correct: 'in'),
    EnglishError(start: 100, end: 101, incorrect: 'it', correct: 'they'),
    EnglishError(start: 101, end: 102, incorrect: 'helps', correct: 'help'),
    EnglishError(start: 121, end: 122, incorrect: 'a', correct: 'an'),
    EnglishError(start: 125, end: 126, incorrect: 'by', correct: 'with'),
    EnglishError(start: 128, end: 129, incorrect: 'have', correct: 'has'),
    EnglishError(start: 135, end: 136, incorrect: 'skill', correct: 'skills'),
  ],
);

/// Đoạn gia đình và bạn bè. Chữ have thừa ở bản đúng gắn vào từ shared.
const englishFamilyPassage = EnglishPassageSet(
  incorrectText: 'Family and friends plays a vital role on my life, serving like a solid anchor while difficult times. My family consists with four peoples, and we share a bond building on unconditional love and respect. My father, whom is my greatest role model, teach me the importance of integrity and hard work. These core value have shaped the person I was today. Whenever I face about a problem, I know I can always turn back to my parents for wise advices. Beside my family, my best friend is like a soulmate which understands me without words. We have been friends for over a decade and shared countless memories together. We often motivate each others to study about English and pursue our individual passions. Having such a supportive network make me feel extremely lucky and empowered. I believe that healthy relationships are the key for a happy and balanced life.',
  correctText: 'Family and friends play a vital role in my life, serving as a solid anchor during difficult times. My family consists of four people, and we share a bond built on unconditional love and respect. My father, who is my greatest role model, taught me the importance of integrity and hard work. These core values have shaped the person I am today. Whenever I face a problem, I know I can always turn to my parents for wise advice. Beside my family, my best friend is like a soulmate who understands me without words. We have been friends for over a decade and have shared countless memories together. We often motivate each other to study English and pursue our individual passions. Having such a supportive network makes me feel extremely lucky and empowered. I believe that healthy relationships are the key to a happy and balanced life.',
  errors: [
    EnglishError(start: 3, end: 4, incorrect: 'plays', correct: 'play'),
    EnglishError(start: 7, end: 8, incorrect: 'on', correct: 'in'),
    EnglishError(start: 11, end: 12, incorrect: 'like', correct: 'as'),
    EnglishError(start: 15, end: 16, incorrect: 'while', correct: 'during'),
    EnglishError(start: 21, end: 22, incorrect: 'with', correct: 'of'),
    EnglishError(start: 23, end: 24, incorrect: 'peoples,', correct: 'people,'),
    EnglishError(start: 29, end: 30, incorrect: 'building', correct: 'built'),
    EnglishError(start: 37, end: 38, incorrect: 'whom', correct: 'who'),
    EnglishError(start: 43, end: 44, incorrect: 'teach', correct: 'taught'),
    EnglishError(start: 54, end: 55, incorrect: 'value', correct: 'values'),
    EnglishError(start: 60, end: 61, incorrect: 'was', correct: 'am'),
    EnglishError(start: 65, end: 66, incorrect: 'about', correct: ''),
    EnglishError(start: 74, end: 75, incorrect: 'back', correct: ''),
    EnglishError(start: 80, end: 81, incorrect: 'advices.', correct: 'advice.'),
    EnglishError(start: 91, end: 92, incorrect: 'which', correct: 'who'),
    EnglishError(
      start: 105,
      end: 106,
      incorrect: 'shared',
      correct: 'have shared',
    ),
    EnglishError(start: 113, end: 114, incorrect: 'others', correct: 'other'),
    EnglishError(start: 116, end: 117, incorrect: 'about', correct: ''),
    EnglishError(start: 128, end: 129, incorrect: 'make', correct: 'makes'),
    EnglishError(start: 143, end: 144, incorrect: 'for', correct: 'to'),
  ],
);

/// Đoạn sở thích. Năm khác biệt không bắt buộc đã được viết giống bản đúng để còn đúng 20 lỗi.
const englishHobbyPassage = EnglishPassageSet(
  incorrectText: 'Having a hobby are essential for maintaining a good mental health in today fast-paced world. Personally, I love to indulge into reading books, especially them related to psychology and marketing. Reading is not just a pastime; it is a way of me to expand my horizon and gain new perspective. It also helps improving my cognitive functional and focus after a long day of work. Besides read, I am quite keen about photography, which allow me to capture beautiful moments in life. I often spend my weekends to explore the city and taking photos of ancient architectures. These activity provide me about a sense of creative freedom and joy. I also enjoy to practice English through movies, which are both entertaining and educational. My hobbies help me stay balance and prevent burnout from my busy job. Ultimately, pursue what I love makes my life more meaningful and colorful.',
  correctText: 'Having a hobby is essential for maintaining good mental health in today’s fast-paced world. Personally, I love to indulge in reading books, especially those related to psychology and marketing. Reading is not just a pastime; it is a way for me to expand my horizon and gain new perspectives. It also helps improve my cognitive function and focus after a long day of work. Besides reading, I am quite keen on photography, which allows me to capture beautiful moments in life. I often spend my weekends exploring the city and taking photos of ancient architecture. These activities provide me with a sense of creative freedom and joy. I also enjoy practicing English through movies, which is both entertaining and educational. My hobbies help me stay balanced and prevent burnout from my busy job. Ultimately, pursuing what I love makes my life more meaningful and colorful.',
  errors: [
    EnglishError(start: 3, end: 4, incorrect: 'are', correct: 'is'),
    EnglishError(start: 7, end: 8, incorrect: 'a', correct: ''),
    EnglishError(start: 12, end: 13, incorrect: 'today', correct: 'today’s'),
    EnglishError(start: 20, end: 21, incorrect: 'into', correct: 'in'),
    EnglishError(start: 24, end: 25, incorrect: 'them', correct: 'those'),
    EnglishError(start: 40, end: 41, incorrect: 'of', correct: 'for'),
    EnglishError(
      start: 49,
      end: 50,
      incorrect: 'perspective.',
      correct: 'perspectives.',
    ),
    EnglishError(
      start: 53,
      end: 54,
      incorrect: 'improving',
      correct: 'improve',
    ),
    EnglishError(
      start: 56,
      end: 57,
      incorrect: 'functional',
      correct: 'function',
    ),
    EnglishError(start: 66, end: 67, incorrect: 'read,', correct: 'reading,'),
    EnglishError(start: 71, end: 72, incorrect: 'about', correct: 'on'),
    EnglishError(start: 74, end: 75, incorrect: 'allow', correct: 'allows'),
    EnglishError(
      start: 87,
      end: 89,
      incorrect: 'to explore',
      correct: 'exploring',
    ),
    EnglishError(
      start: 96,
      end: 97,
      incorrect: 'architectures.',
      correct: 'architecture.',
    ),
    EnglishError(
      start: 98,
      end: 99,
      incorrect: 'activity',
      correct: 'activities',
    ),
    EnglishError(start: 101, end: 102, incorrect: 'about', correct: 'with'),
    EnglishError(
      start: 112,
      end: 114,
      incorrect: 'to practice',
      correct: 'practicing',
    ),
    EnglishError(start: 118, end: 119, incorrect: 'are', correct: 'is'),
    EnglishError(
      start: 128,
      end: 129,
      incorrect: 'balance',
      correct: 'balanced',
    ),
    EnglishError(
      start: 137,
      end: 138,
      incorrect: 'pursue',
      correct: 'pursuing',
    ),
  ],
);
