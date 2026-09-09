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
  int get schemaVersion => 1;
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
/// Interests onboarding tanpa network round-trip.
class CachedInterests extends Table {
  IntColumn get id => integer()();
  TextColumn get slug => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Instance tunggal dipakai seluruh app — SAMA seperti pola
/// `CouplivyApiClient.instance`/`interestRepository` lain di project ini.
final appDatabase = AppDatabase();
