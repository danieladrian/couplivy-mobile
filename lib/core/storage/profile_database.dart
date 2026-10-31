import 'package:drift/drift.dart';

import '../models/my_profile.dart';
import 'app_database.dart';

/// Database LOKAL profil sendiri — SQLite via drift. BUKAN cache
/// sementara: ini SUMBER UTAMA yang dibaca UI (ProfileScreen, My Profile,
/// My Preferences) — bisa dibuka OFFLINE. Server (`GET /me`,
/// `ProfileRepository.syncMyProfile()`) dipakai HANYA untuk
/// SYNC, di titik-titik eksplisit berikut, TIDAK ADA background sync/
/// polling:
/// - Setelah login/register sukses (lihat `AuthRepository._post()`).
/// - Setelah onboarding submit sukses (lihat `PreviewStepScreen._submit()`).
/// - Setelah edit profil sukses (MENYUSUL — edit WAJIB online: submit ke
///   server dulu, baru panggil `save()` di sini kalau sukses. TIDAK ADA
///   optimistic write — [save] TIDAK PERNAH dipanggil sebelum server
///   confirm).
///
/// Field scalar di tabel [Profiles] (1 baris, `id` selalu 0), field array
/// di tabel anak ([LoveLanguages], [ProfileInterests], [Photos],
/// `Preference*`) — lihat `app_database.dart`.
abstract final class ProfileDatabase {
  static const _singleRowId = 0;

  static Future<void> save(MyProfile profile) async {
    final db = appDatabase;
    await db.transaction(() async {
      await db
          .into(db.profiles)
          .insertOnConflictUpdate(
            ProfilesCompanion(
              id: const Value(_singleRowId),
              nickName: Value(profile.nickName),
              fullName: Value(profile.fullName),
              age: Value(profile.age),
              bio: Value(profile.bio),
              occupation: Value(profile.occupation),
              education: Value(profile.education),
              heightCm: Value(profile.heightCm),
              gender: Value(profile.gender),
              ethnicity: Value(profile.ethnicity),
              religion: Value(profile.religion),
              relationshipGoal: Value(profile.relationshipGoal),
              drinking: Value(profile.drinking),
              smoking: Value(profile.smoking),
              petPreference: Value(profile.petPreference),
              childrenPreference: Value(profile.childrenPreference),
              marriagePreference: Value(profile.marriagePreference),
              completenessPercent: Value(profile.completenessPercent),
              preferenceAgeMin: Value(profile.preferences?.ageMin),
              preferenceAgeMax: Value(profile.preferences?.ageMax),
              preferenceGenderPreference: Value(
                profile.preferences?.genderPreference,
              ),
              hasPreferences: Value(profile.preferences != null),
            ),
          );

      await _replaceAll(
        db.loveLanguages,
        profile.loveLanguages,
        (value) => LoveLanguagesCompanion.insert(value: value),
      );
      await _replaceAll(
        db.profileInterests,
        profile.interestSlugs,
        (value) => ProfileInterestsCompanion.insert(value: value),
      );

      await db.delete(db.photos).go();
      await db.photos.insertAll(
        profile.photoPaths.asMap().entries.map(
          (entry) => PhotosCompanion.insert(
            path: entry.value,
            position: entry.key,
            isMain: entry.key == 0,
          ),
        ),
      );

      final preferences = profile.preferences;
      await _replaceAll(
        db.preferenceChildren,
        preferences?.childrenPreference ?? const [],
        (value) => PreferenceChildrenCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferenceMarriages,
        preferences?.marriagePreference ?? const [],
        (value) => PreferenceMarriagesCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferenceEthnicities,
        preferences?.ethnicityPreference ?? const [],
        (value) => PreferenceEthnicitiesCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferenceReligions,
        preferences?.religionPreference ?? const [],
        (value) => PreferenceReligionsCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferenceEducations,
        preferences?.educationPreference ?? const [],
        (value) => PreferenceEducationsCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferenceDrinkings,
        preferences?.drinkingPreference ?? const [],
        (value) => PreferenceDrinkingsCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferenceSmokings,
        preferences?.smokingPreference ?? const [],
        (value) => PreferenceSmokingsCompanion.insert(value: value),
      );
      await _replaceAll(
        db.preferencePets,
        preferences?.petPreference ?? const [],
        (value) => PreferencePetsCompanion.insert(value: value),
      );
    });
  }

  static Future<MyProfile?> read() async {
    final db = appDatabase;
    final row = await (db.select(
      db.profiles,
    )..where((t) => t.id.equals(_singleRowId))).getSingleOrNull();
    if (row == null) return null;

    final loveLanguages = await _readAll(db.loveLanguages);
    final interestSlugs = await _readAll(db.profileInterests);
    final photoRows = await (db.select(
      db.photos,
    )..orderBy([(t) => OrderingTerm(expression: t.position)])).get();

    MyDatingPreferences? preferences;
    if (row.hasPreferences) {
      preferences = MyDatingPreferences(
        ageMin: row.preferenceAgeMin,
        ageMax: row.preferenceAgeMax,
        genderPreference: row.preferenceGenderPreference,
        childrenPreference: await _readAll(db.preferenceChildren),
        marriagePreference: await _readAll(db.preferenceMarriages),
        ethnicityPreference: await _readAll(db.preferenceEthnicities),
        religionPreference: await _readAll(db.preferenceReligions),
        educationPreference: await _readAll(db.preferenceEducations),
        drinkingPreference: await _readAll(db.preferenceDrinkings),
        smokingPreference: await _readAll(db.preferenceSmokings),
        petPreference: await _readAll(db.preferencePets),
      );
    }

    return MyProfile(
      nickName: row.nickName,
      fullName: row.fullName,
      age: row.age,
      bio: row.bio,
      occupation: row.occupation,
      education: row.education,
      heightCm: row.heightCm,
      gender: row.gender,
      ethnicity: row.ethnicity,
      religion: row.religion,
      relationshipGoal: row.relationshipGoal,
      drinking: row.drinking,
      smoking: row.smoking,
      petPreference: row.petPreference,
      childrenPreference: row.childrenPreference,
      marriagePreference: row.marriagePreference,
      loveLanguages: loveLanguages,
      interestSlugs: interestSlugs,
      photoPaths: photoRows.map((p) => p.path).toList(),
      completenessPercent: row.completenessPercent,
      preferences: preferences,
    );
  }

  static Future<void> clear() async {
    final db = appDatabase;
    await db.transaction(() async {
      await db.delete(db.profiles).go();
      await db.delete(db.loveLanguages).go();
      await db.delete(db.profileInterests).go();
      await db.delete(db.photos).go();
      await db.delete(db.preferenceChildren).go();
      await db.delete(db.preferenceMarriages).go();
      await db.delete(db.preferenceEthnicities).go();
      await db.delete(db.preferenceReligions).go();
      await db.delete(db.preferenceEducations).go();
      await db.delete(db.preferenceDrinkings).go();
      await db.delete(db.preferenceSmokings).go();
      await db.delete(db.preferencePets).go();
    });
  }

  /// Helper generik — tabel anak field-array SEMUA berbentuk sama (1
  /// kolom `value` string), jadi replace-total (delete lalu insertAll)
  /// bisa dipakai ulang lewat 1 method, bukan diduplikasi 8x.
  static Future<void> _replaceAll<T extends Table, D>(
    TableInfo<T, D> table,
    List<String> values,
    Insertable<D> Function(String value) toCompanion,
  ) async {
    await appDatabase.delete(table).go();
    await table.insertAll(values.map(toCompanion));
  }

  static Future<List<String>> _readAll<T extends Table, D>(
    TableInfo<T, D> table,
  ) async {
    final rows = await appDatabase.select(table).get();
    return rows.map((row) => (row as dynamic).value as String).toList();
  }
}
