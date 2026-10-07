import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';

/// Giáo viên chủ nhiệm được gán một lần và đi cùng học sinh suốt lớp.
enum HomeroomTeacher { hung, nga, hoa }

class HomeroomProfile {
  const HomeroomProfile({
    required this.id,
    required this.name,
    required this.male,
    required this.portrait,
    required this.enterScene,
    required this.seatScene,
  });

  final HomeroomTeacher id;
  final String name;
  final bool male;
  final String portrait;
  final String enterScene;
  final String seatScene;

  String title(AppLocalizations l10n) => switch (id) {
    HomeroomTeacher.hung => l10n.teacherHung,
    HomeroomTeacher.nga => l10n.teacherNga,
    HomeroomTeacher.hoa => l10n.teacherHoa,
  };

  String welcome(AppLocalizations l10n, String studentName) => male
      ? l10n.classWelcomeMale(studentName)
      : l10n.classWelcomeFemale(studentName);
}

const homeroomProfiles = <HomeroomProfile>[
  HomeroomProfile(
    id: HomeroomTeacher.hung,
    name: 'Hùng',
    male: true,
    portrait: 'assets/images/school/teacher_hung.jpg',
    enterScene: 'assets/images/school/class_enter_hung.jpg',
    seatScene: 'assets/images/school/class_seat_hung.jpg',
  ),
  HomeroomProfile(
    id: HomeroomTeacher.nga,
    name: 'Nga',
    male: false,
    portrait: 'assets/images/school/teacher_nga.jpg',
    enterScene: 'assets/images/school/class_enter_nga.jpg',
    seatScene: 'assets/images/school/class_seat_nga.jpg',
  ),
  HomeroomProfile(
    id: HomeroomTeacher.hoa,
    name: 'Hoa',
    male: false,
    portrait: 'assets/images/school/teacher_hoa.jpg',
    enterScene: 'assets/images/school/class_enter_hoa.jpg',
    seatScene: 'assets/images/school/class_seat_hoa.jpg',
  ),
];

class HomeroomStore {
  HomeroomStore({Random? random}) : _random = random ?? Random();

  final Random _random;
  static const _key = 'school.homeroom';
  static const _introKey = 'school.classIntroDone';

  Future<HomeroomProfile?> load() async {
    final saved = (await SharedPreferences.getInstance()).getString(_key);
    for (final profile in homeroomProfiles) {
      if (profile.id.name == saved) return profile;
    }
    return null;
  }

  /// Chưa có thầy cô thì chọn ngẫu nhiên một người và giữ mãi.
  Future<HomeroomProfile> loadOrAssign() async {
    final existing = await load();
    if (existing != null) return existing;
    final profile = homeroomProfiles[_random.nextInt(homeroomProfiles.length)];
    await (await SharedPreferences.getInstance()).setString(
      _key,
      profile.id.name,
    );
    return profile;
  }

  Future<bool> introDone() async =>
      (await SharedPreferences.getInstance()).getBool(_introKey) ?? false;

  Future<void> markIntroDone() async {
    await (await SharedPreferences.getInstance()).setBool(_introKey, true);
  }
}
