import '../l10n/app_localizations.dart';

/// Bộ đồ của học sinh. Hai bộ đổi bằng kẹo, đồng phục là đồ sẵn.
enum StudentOutfitId { uniform, sunflower, sailor }

class StudentOutfit {
  const StudentOutfit({
    required this.id,
    required this.asset,
    required this.cost,
  });

  final StudentOutfitId id;
  final String asset;

  /// 0 là đồ mặc định. Bộ đổi tốn 10 kẹo.
  final int cost;

  String name(AppLocalizations l10n) => switch (id) {
    StudentOutfitId.uniform => l10n.outfitUniform,
    StudentOutfitId.sunflower => l10n.outfitSunflower,
    StudentOutfitId.sailor => l10n.outfitSailor,
  };
}

const outfitCandyCost = 10;

const studentOutfits = <StudentOutfit>[
  StudentOutfit(
    id: StudentOutfitId.uniform,
    asset: 'assets/images/school/student_avatar.jpg',
    cost: 0,
  ),
  StudentOutfit(
    id: StudentOutfitId.sunflower,
    asset: 'assets/images/school/outfit_sunflower.jpg',
    cost: outfitCandyCost,
  ),
  StudentOutfit(
    id: StudentOutfitId.sailor,
    asset: 'assets/images/school/outfit_sailor.jpg',
    cost: outfitCandyCost,
  ),
];

StudentOutfit outfitById(String? id) {
  for (final outfit in studentOutfits) {
    if (outfit.id.name == id) return outfit;
  }
  return studentOutfits.first;
}
