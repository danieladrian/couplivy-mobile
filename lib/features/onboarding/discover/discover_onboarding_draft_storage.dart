import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Draft SEMUA field onboarding Discover (step 1-8) — disimpan LOKAL di
/// SharedPreferences sepanjang user mengisi step, TIDAK dikirim ke server
/// sampai step terakhir (Preview). Lihat
/// DiscoverOnboardingRepository.complete()/uploadPhotos().
///
/// Bertahan walau app di-kill (SharedPreferences persisten di disk), TAPI
/// hilang kalau app di-uninstall — keputusan produk yang diterima (lihat
/// .ai/rules/architecture.md): user yang uninstall/logout sebelum
/// menyelesaikan step terakhir mulai dari step 1 lagi.
///
/// Key di-prefix `onboarding_discover_draft_` supaya tidak bentrok dengan
/// key SharedPreferences lain.
abstract final class DiscoverOnboardingDraftStorage {
  static const _dobKey = 'onboarding_discover_draft_dob';
  static const _genderKey = 'onboarding_discover_draft_gender';
  static const _photoPathsKey = 'onboarding_discover_draft_photo_paths';
  static const _bioKey = 'onboarding_discover_draft_bio';
  static const _heightCmKey = 'onboarding_discover_draft_height_cm';
  static const _ethnicityKey = 'onboarding_discover_draft_ethnicity';
  static const _religionKey = 'onboarding_discover_draft_religion';
  static const _wantsChildrenKey = 'onboarding_discover_draft_wants_children';
  static const _heightUnitPreferenceKey =
      'onboarding_discover_draft_height_unit_preference';
  static const _occupationKey = 'onboarding_discover_draft_occupation';
  static const _educationKey = 'onboarding_discover_draft_education';
  static const _interestIdsKey = 'onboarding_discover_draft_interest_ids';
  static const _relationshipGoalKey =
      'onboarding_discover_draft_relationship_goal';
  static const _preferencesKey = 'onboarding_discover_draft_preferences';

  // --- Step 1: DOB (ISO 8601 date string, mis. "1996-08-20") ---
  static Future<void> saveDob(String isoDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dobKey, isoDate);
  }

  static Future<String?> readDob() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_dobKey);
  }

  // --- Step 2: Gender ---
  static Future<void> saveGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender);
  }

  static Future<String?> readGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_genderKey);
  }

  // --- Step 3: Photos — path LOKAL (di temp dir device, BELUM
  // ter-upload). Urutan list = urutan slot, index 0 = foto utama. ---
  static Future<void> savePhotoPaths(List<String> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_photoPathsKey, paths);
  }

  static Future<List<String>> readPhotoPaths() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_photoPathsKey) ?? [];
  }

  // --- Step 4: Bio + Detail Diri ---
  static Future<void> saveBio(String? bio) async {
    final prefs = await SharedPreferences.getInstance();
    if (bio == null || bio.isEmpty) {
      await prefs.remove(_bioKey);
    } else {
      await prefs.setString(_bioKey, bio);
    }
  }

  static Future<String?> readBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_bioKey);
  }

  static Future<void> saveHeightCm(int? heightCm) async {
    final prefs = await SharedPreferences.getInstance();
    if (heightCm == null) {
      await prefs.remove(_heightCmKey);
    } else {
      await prefs.setInt(_heightCmKey, heightCm);
    }
  }

  static Future<int?> readHeightCm() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_heightCmKey);
  }

  static Future<void> saveEthnicity(String? ethnicity) async {
    final prefs = await SharedPreferences.getInstance();
    if (ethnicity == null || ethnicity.isEmpty) {
      await prefs.remove(_ethnicityKey);
    } else {
      await prefs.setString(_ethnicityKey, ethnicity);
    }
  }

  static Future<String?> readEthnicity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_ethnicityKey);
  }

  static Future<void> saveReligion(String? religion) async {
    final prefs = await SharedPreferences.getInstance();
    if (religion == null || religion.isEmpty) {
      await prefs.remove(_religionKey);
    } else {
      await prefs.setString(_religionKey, religion);
    }
  }

  static Future<String?> readReligion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_religionKey);
  }

  /// null = belum dijawab (belum sentuh pilihan), true/false = jawaban.
  static Future<void> saveWantsChildren(bool? wantsChildren) async {
    final prefs = await SharedPreferences.getInstance();
    if (wantsChildren == null) {
      await prefs.remove(_wantsChildrenKey);
    } else {
      await prefs.setBool(_wantsChildrenKey, wantsChildren);
    }
  }

  static Future<bool?> readWantsChildren() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_wantsChildrenKey);
  }

  /// "Not sure yet" DISIMPAN sebagai null — sama seperti "belum pernah
  /// disentuh sama sekali". [readWantsChildren] tidak bisa bedakan
  /// keduanya, jadi step Bio (yang sekarang mewajibkan field ini) pakai
  /// method ini untuk tahu apakah user SUDAH memilih salah satu opsi
  /// (termasuk "Not sure yet") atau belum menyentuh sama sekali.
  static Future<bool> hasWantsChildrenKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_wantsChildrenKey);
  }

  /// Preferensi TAMPILAN unit height ('cm' atau 'ft') — MURNI lokal,
  /// TIDAK dikirim ke backend (backend cuma terima height_cm, satu-
  /// satunya bentuk yang disimpan sebagai data). Dipakai supaya step
  /// Bio ingat unit yang terakhir dipilih user, bisa dipakai lagi nanti
  /// di Preview/Edit Profile.
  static Future<void> saveHeightUnitPreference(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_heightUnitPreferenceKey, unit);
  }

  static Future<String?> readHeightUnitPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_heightUnitPreferenceKey);
  }

  // --- Step 5: Work/Education ---
  static Future<void> saveOccupation(String? occupation) async {
    final prefs = await SharedPreferences.getInstance();
    if (occupation == null || occupation.isEmpty) {
      await prefs.remove(_occupationKey);
    } else {
      await prefs.setString(_occupationKey, occupation);
    }
  }

  static Future<String?> readOccupation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_occupationKey);
  }

  static Future<void> saveEducation(String? education) async {
    final prefs = await SharedPreferences.getInstance();
    if (education == null) {
      await prefs.remove(_educationKey);
    } else {
      await prefs.setString(_educationKey, education);
    }
  }

  static Future<String?> readEducation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_educationKey);
  }

  // --- Step 6: Interests (list of interest ID dari GET /api/interests) ---
  static Future<void> saveInterestIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _interestIdsKey,
      ids.map((id) => id.toString()).toList(),
    );
  }

  static Future<List<int>> readInterestIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_interestIdsKey) ?? [];
    return raw.map(int.parse).toList();
  }

  // --- Step 7: Relationship Goal ---
  static Future<void> saveRelationshipGoal(String goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_relationshipGoalKey, goal);
  }

  static Future<String?> readRelationshipGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_relationshipGoalKey);
  }

  // --- Step 8: Dating Preferences — disimpan sebagai 1 JSON blob (bukan
  // key terpisah per field) karena bentuknya nested object saat dikirim
  // ke API (`preferences: {...}`), jadi lebih mudah round-trip lewat Map. ---
  static Future<void> savePreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferencesKey, jsonEncode(preferences));
  }

  static Future<Map<String, dynamic>> readPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_preferencesKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Kumpulkan SEMUA field jadi 1 payload untuk
  /// `DiscoverOnboardingRepository.complete()` — dipanggil di step
  /// terakhir (Preview). Foto TIDAK ikut di sini (endpoint terpisah, lihat
  /// `uploadPhotos()`).
  static Future<Map<String, dynamic>> readAllForSubmit() async {
    final dob = await readDob();
    final gender = await readGender();
    final bio = await readBio();
    final heightCm = await readHeightCm();
    final ethnicity = await readEthnicity();
    final religion = await readReligion();
    final wantsChildren = await readWantsChildren();
    final occupation = await readOccupation();
    final education = await readEducation();
    final interestIds = await readInterestIds();
    final relationshipGoal = await readRelationshipGoal();
    final preferences = await readPreferences();

    return {
      'dob': ?dob,
      'gender': ?gender,
      'bio': ?bio,
      'height_cm': ?heightCm,
      'ethnicity': ?ethnicity,
      'religion': ?religion,
      'wants_children': ?wantsChildren,
      'occupation': ?occupation,
      'education': ?education,
      'interests': interestIds,
      'relationship_goal': ?relationshipGoal,
      if (preferences.isNotEmpty) 'preferences': preferences,
    };
  }

  /// Tentukan route step SELANJUTNYA yang belum diisi — dipakai
  /// [OnboardingStatus.resolveResumeRoute] supaya Splash/Login membawa
  /// user balik ke step tempat dia berhenti (bukan selalu step 1),
  /// mis. sudah sampai Photos (step 3) lalu keluar app, masuk lagi harus
  /// langsung ke Photos, bukan DOB lagi.
  ///
  /// Cuma cek field yang WAJIB per step (tidak ada tombol Skip di HTML
  /// sumbernya) — step optional (Bio, Work/Education, Interests,
  /// Preferences) dianggap "boleh kosong selamanya" jadi tidak bisa
  /// dipakai sebagai penanda "belum sampai sini". Kalau user pernah lewat
  /// step optional (skip atau isi), dia akan mendarat di Preview begitu
  /// semua step wajib (DOB, Gender, Photos, Relationship Goal) terisi —
  /// draft optional yang sudah diisi tetap ke-preserve dan tampil di
  /// Preview, cuma urutan "kembali ke mana" yang disederhanakan.
  static Future<String> resolveNextStepRoute() async {
    if (await readDob() == null) return '/onboarding/discover/dob';
    if (await readGender() == null) return '/onboarding/discover/gender';
    if ((await readPhotoPaths()).isEmpty) {
      return '/onboarding/discover/photos';
    }
    if (await readRelationshipGoal() == null) {
      return '/onboarding/discover/relationship-goal';
    }

    return '/onboarding/discover/preview';
  }

  /// Hapus semua draft — dipanggil setelah submit sukses ke server,
  /// supaya draft lama tidak nyangkut kalau user onboarding lagi nanti
  /// (device baru/akun baru login di device sama).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_dobKey),
      prefs.remove(_genderKey),
      prefs.remove(_photoPathsKey),
      prefs.remove(_bioKey),
      prefs.remove(_heightCmKey),
      prefs.remove(_ethnicityKey),
      prefs.remove(_religionKey),
      prefs.remove(_wantsChildrenKey),
      prefs.remove(_occupationKey),
      prefs.remove(_educationKey),
      prefs.remove(_interestIdsKey),
      prefs.remove(_relationshipGoalKey),
      prefs.remove(_preferencesKey),
    ]);
  }
}
