import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Cache lokal master data — SQLite via drift, cross-platform (iOS,
/// Android, dan desktop kalau nanti perlu). Dipakai untuk data yang
/// jarang berubah dan idealnya tidak di-fetch ulang tiap buka layar (mis.
/// Interests) — beda dari [DiscoverOnboardingDraftStorage]
/// (SharedPreferences) yang menyimpan draft JAWABAN user, bukan master
/// data dari server.
///
/// SATU instance per app lifetime — akses lewat [appDatabase] singleton,
/// bukan di-construct manual di widget.
@DriftDatabase(tables: [CachedInterests])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Test/isolated instance — dipakai widget test supaya tidak nulis ke
  /// file DB sungguhan di disk (lihat [_openConnection] untuk versi
  /// production, yang selalu file-based).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

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
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'couplivy_cache.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Cache `GET /api/interests` — di-refresh tiap login/register sukses
/// (lihat `InterestRepository.refreshCache()`), dibaca instan di step
/// Interests onboarding tanpa network round-trip. `category` dipakai
/// mengelompokkan chip per section (Food/Travel/Sports/Arts/
/// Entertainment) — ditambah di schemaVersion 2, lihat [AppDatabase.migration].
class CachedInterests extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text()();
  TextColumn get category => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Instance tunggal dipakai seluruh app — SAMA seperti pola
/// `CouplivyApiClient.instance`/`interestRepository` lain di project ini.
final appDatabase = AppDatabase();
