/// Representasi LENGKAP profil sendiri, dari response `GET /me` — dipakai
/// halaman Profile/Account dan turunannya (My Profile, dst). Beda dari
/// [User] (cuma kolom `users`/auth inti) — ini gabungan `profiles` +
/// love languages + interests + photos + skor `completeness_percent`
/// yang dihitung server-side.
class MyProfile {
  const MyProfile({
    required this.nickName,
    required this.fullName,
    required this.age,
    required this.bio,
    required this.occupation,
    required this.education,
    required this.heightCm,
    required this.gender,
    required this.ethnicity,
    required this.religion,
    required this.relationshipGoal,
    required this.drinking,
    required this.smoking,
    required this.petPreference,
    required this.childrenPreference,
    required this.marriagePreference,
    required this.loveLanguages,
    required this.interestSlugs,
    required this.photoPaths,
    required this.completenessPercent,
    required this.preferences,
  });

  factory MyProfile.fromJson(Map<String, dynamic> json) {
    return MyProfile(
      nickName: json['nick_name'] as String?,
      fullName: json['full_name'] as String,
      age: json['age'] as int?,
      bio: json['bio'] as String?,
      occupation: json['occupation'] as String?,
      education: json['education'] as String?,
      heightCm: json['height_cm'] as int?,
      gender: json['gender'] as String?,
      ethnicity: json['ethnicity'] as String?,
      religion: json['religion'] as String?,
      relationshipGoal: json['relationship_goal'] as String?,
      drinking: json['drinking'] as String?,
      smoking: json['smoking'] as String?,
      petPreference: json['pet_preference'] as String?,
      childrenPreference: json['children_preference'] as String?,
      marriagePreference: json['marriage_preference'] as String?,
      loveLanguages: (json['love_languages'] as List<dynamic>).cast<String>(),
      interestSlugs: (json['interests'] as List<dynamic>).cast<String>(),
      photoPaths: (json['photos'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((photo) => photo['path'] as String)
          .toList(),
      completenessPercent: json['completeness_percent'] as int,
      preferences: json['preferences'] != null
          ? MyDatingPreferences.fromJson(
              json['preferences'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  final String? nickName;
  final String fullName;
  final int? age;
  final String? bio;
  final String? occupation;
  final String? education;
  final int? heightCm;
  final String? gender;
  final String? ethnicity;
  final String? religion;
  final String? relationshipGoal;
  final String? drinking;
  final String? smoking;
  final String? petPreference;
  final String? childrenPreference;
  final String? marriagePreference;
  final List<String> loveLanguages;
  final List<String> interestSlugs;
  final List<String> photoPaths;
  final int completenessPercent;
  final MyDatingPreferences? preferences;

  Map<String, dynamic> toJson() => {
    'nick_name': nickName,
    'full_name': fullName,
    'age': age,
    'bio': bio,
    'occupation': occupation,
    'education': education,
    'height_cm': heightCm,
    'gender': gender,
    'ethnicity': ethnicity,
    'religion': religion,
    'relationship_goal': relationshipGoal,
    'drinking': drinking,
    'smoking': smoking,
    'pet_preference': petPreference,
    'children_preference': childrenPreference,
    'marriage_preference': marriagePreference,
    'love_languages': loveLanguages,
    'interests': interestSlugs,
    'photos': [
      for (final path in photoPaths) {'path': path},
    ],
    'completeness_percent': completenessPercent,
    'preferences': preferences?.toJson(),
  };
}

/// Preferensi pencarian pasangan (step 10 onboarding, "My Preferences" di
/// halaman Profile) — null kalau `dating_preferences` belum pernah dibuat
/// sama sekali (mustahil setelah onboarding selesai, tapi tetap nullable
/// untuk jaga-jaga sebelum onboarding, sama pola field lain di
/// [MyProfile]).
class MyDatingPreferences {
  const MyDatingPreferences({
    required this.ageMin,
    required this.ageMax,
    required this.genderPreference,
    required this.childrenPreference,
    required this.marriagePreference,
    required this.ethnicityPreference,
    required this.religionPreference,
    required this.educationPreference,
    required this.drinkingPreference,
    required this.smokingPreference,
    required this.petPreference,
  });

  factory MyDatingPreferences.fromJson(Map<String, dynamic> json) {
    List<String> asStringList(String key) =>
        (json[key] as List<dynamic>).cast<String>();

    return MyDatingPreferences(
      ageMin: json['age_min'] as int?,
      ageMax: json['age_max'] as int?,
      genderPreference: json['gender_preference'] as String?,
      childrenPreference: asStringList('children_preference'),
      marriagePreference: asStringList('marriage_preference'),
      ethnicityPreference: asStringList('ethnicity_preference'),
      religionPreference: asStringList('religion_preference'),
      educationPreference: asStringList('education_preference'),
      drinkingPreference: asStringList('drinking_preference'),
      smokingPreference: asStringList('smoking_preference'),
      petPreference: asStringList('pet_preference'),
    );
  }

  final int? ageMin;
  final int? ageMax;
  final String? genderPreference;
  final List<String> childrenPreference;
  final List<String> marriagePreference;
  final List<String> ethnicityPreference;
  final List<String> religionPreference;
  final List<String> educationPreference;
  final List<String> drinkingPreference;
  final List<String> smokingPreference;
  final List<String> petPreference;

  Map<String, dynamic> toJson() => {
    'age_min': ageMin,
    'age_max': ageMax,
    'gender_preference': genderPreference,
    'children_preference': childrenPreference,
    'marriage_preference': marriagePreference,
    'ethnicity_preference': ethnicityPreference,
    'religion_preference': religionPreference,
    'education_preference': educationPreference,
    'drinking_preference': drinkingPreference,
    'smoking_preference': smokingPreference,
    'pet_preference': petPreference,
  };
}
