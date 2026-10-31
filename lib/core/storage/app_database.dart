import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Database lokal utama app — SQLite via drift, cross-platform (iOS,
/// Android, dan desktop kalau nanti perlu). Dua kelompok tabel:
/// - `CachedInterests` — MEMANG cache (master data publik, bukan milik
///   user, boleh hilang & di-refetch kapan saja tanpa dampak).
/// - `Profiles` dkk — database LOKAL profil milik user sendiri, BUKAN
///   cache sementara. UI (ProfileScreen, My Profile, My Preferences)
///   BACA dari sini sebagai sumber utama, server cuma dipakai untuk
///   SYNC (tarik data masuk saat login/submit onboarding, dorong
///   perubahan keluar saat edit) — lihat `ProfileDatabase` dan
///   .ai/rules/architecture.md untuk aturan baca/tulis lengkap.
///
/// Beda dari [DiscoverOnboardingDraftStorage] (SharedPreferences) yang
/// menyimpan draft JAWABAN onboarding SEBELUM submit — itu pola terpisah,
/// tidak diubah oleh desain ini.
///
/// SATU instance per app lifetime — akses lewat [appDatabase] singleton,
/// bukan di-construct manual di widget.
@DriftDatabase(
  tables: [
    CachedInterests,
    Profiles,
    LoveLanguages,
    ProfileInterests,
    Photos,
    PreferenceChildren,
    PreferenceMarriages,
    PreferenceEthnicities,
    PreferenceReligions,
    PreferenceEducations,
    PreferenceDrinkings,
    PreferenceSmokings,
    PreferencePets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test/isolated instance — dipakai widget test supaya tidak nulis ke
  /// file DB sungguhan di disk (lihat [_openConnection] untuk versi
  /// production, yang selalu file-based).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v1 -> v2: tambah kolom `category` (grouping chip Interests per
        // kategori Food/Travel/Sports/Arts/Entertainment, lihat
        // backend InterestSeeder). Default '' untuk baris lama — akan
        // langsung ditimpa oleh `refreshCache()` di request login/
        // register berikutnya, jadi nilai sementara ini tidak pernah
        // benar-benar dipakai user.
        await m.addColumn(cachedInterests, cachedInterests.category);
      }
      if (from < 3) {
        // v2 -> v3: tabel database lokal profil milik user sendiri (My
        // Profile/My Preferences) — lihat ProfileDatabase. Semua tabel
        // BARU, tidak ada migrasi data dari skema lama.
        await m.createTable(profiles);
        await m.createTable(loveLanguages);
        await m.createTable(profileInterests);
        await m.createTable(photos);
        await m.createTable(preferenceChildren);
        await m.createTable(preferenceMarriages);
        await m.createTable(preferenceEthnicities);
        await m.createTable(preferenceReligions);
        await m.createTable(preferenceEducations);
        await m.createTable(preferenceDrinkings);
        await m.createTable(preferenceSmokings);
        await m.createTable(preferencePets);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'couplivy_local.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Cache `GET /api/interests` — di-refresh tiap login/register sukses
/// (lihat `InterestRepository.refreshCache()`), dibaca instan di step
/// Interests onboarding tanpa network round-trip. `category` dipakai
/// mengelompokkan chip per section (Food/Travel/Sports/Arts/
/// Entertainment) — ditambah di schemaVersion 2, lihat [AppDatabase.migration].
///
/// INI BENAR-BENAR cache (beda dari `Profiles` dkk di bawah) — master
/// data publik, bukan milik user, aman hilang & di-refetch kapan saja.
class CachedInterests extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text()();
  TextColumn get category => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Database lokal profil sendiri (field scalar) — SATU baris saja (`id`
/// SELALU 0, single-row table, bukan per-user — device cuma login 1 akun
/// sekaligus, lihat `ProfileDatabase.save()` yang selalu
/// `insertOnConflictUpdate` ke id yang sama). Field array (love
/// languages, interests, photos, dating preferences) di tabel ANAK
/// terpisah di bawah — pola sama `dating_preference_religions` dkk di
/// backend.
///
/// BUKAN cache sementara — ini SUMBER yang dibaca UI (ProfileScreen, My
/// Profile, My Preferences). Server cuma dipakai untuk SYNC, lihat
/// `ProfileDatabase`.
class Profiles extends Table {
  IntColumn get id => integer()();
  TextColumn get nickName => text().nullable()();
  TextColumn get fullName => text()();
  IntColumn get age => integer().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get occupation => text().nullable()();
  TextColumn get education => text().nullable()();
  IntColumn get heightCm => integer().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get ethnicity => text().nullable()();
  TextColumn get religion => text().nullable()();
  TextColumn get relationshipGoal => text().nullable()();
  TextColumn get drinking => text().nullable()();
  TextColumn get smoking => text().nullable()();
  TextColumn get petPreference => text().nullable()();
  TextColumn get childrenPreference => text().nullable()();
  TextColumn get marriagePreference => text().nullable()();
  IntColumn get completenessPercent => integer()();
  // --- Preferences (dating_preferences) field scalar — null kalau
  // belum pernah ada `dating_preferences` sama sekali (lihat
  // MyDatingPreferences nullable di model). Field array-nya ADA di
  // tabel anak Preference* di bawah.
  IntColumn get preferenceAgeMin => integer().nullable()();
  IntColumn get preferenceAgeMax => integer().nullable()();
  TextColumn get preferenceGenderPreference => text().nullable()();
  // Penanda apakah `preferences` ADA sama sekali (beda dari field
  // scalar di atas yang semuanya nullable secara individual — tanpa ini
  // tidak bisa bedakan "preferences null" dari "preferences ada tapi
  // age_min/age_max/gender_preference-nya kosong").
  BoolColumn get hasPreferences =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tabel anak generik untuk field array string — SEMUA tabel anak di
/// bawah (`LoveLanguages`, `ProfileInterests`, `PreferenceChildren`, dst)
/// cuma simpan 1 kolom `value`, tidak perlu foreign key eksplisit
/// (`Profiles` SELALU 1 baris, `id` 0) — `ProfileDatabase.save()`
/// `deleteAll()` lalu `insertAll()` ulang tiap kali, bukan di-update
/// parsial.
class LoveLanguages extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class ProfileInterests extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

/// Beda dari tabel anak lain — foto punya `position`/`isMain`, bukan
/// cuma 1 kolom `value` string.
class Photos extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get path => text()();
  IntColumn get position => integer()();
  BoolColumn get isMain => boolean()();
}

class PreferenceChildren extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferenceMarriages extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferenceEthnicities extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferenceReligions extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferenceEducations extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferenceDrinkings extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferenceSmokings extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

class PreferencePets extends Table {
  IntColumn get rowId => integer().autoIncrement()();
  TextColumn get value => text()();
}

/// Instance tunggal dipakai seluruh app — SAMA seperti pola
/// `CouplivyApiClient.instance`/`interestRepository` lain di project ini.
///
/// SENGAJA bukan `final` — widget test mengganti ini dengan
/// `AppDatabase.forTesting(NativeDatabase.memory())` (lihat
/// `test/test_helpers/profile_database_test_helper.dart`) supaya
/// `ProfileDatabase`/`InterestRepository` bisa ditest tanpa nulis ke file
/// SQLite sungguhan di disk. Production code TIDAK PERNAH reassign ini.
AppDatabase appDatabase = AppDatabase();
