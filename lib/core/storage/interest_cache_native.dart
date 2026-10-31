import 'package:drift/drift.dart' show Value;

import '../models/interest.dart';
import 'app_database.dart';
import 'interest_cache.dart';

/// Implementasi native (Android/iOS/desktop) — SQLite via drift, persist
/// di disk antar app restart. Lihat `interest_cache.dart` untuk kontrak,
/// `interest_cache_web.dart` untuk pasangan implementasi web-nya.
class NativeInterestCache implements InterestCache {
  NativeInterestCache(this._db);

  final AppDatabase _db;

  @override
  Future<List<Interest>> readAll() async {
    final rows = await _db.select(_db.cachedInterests).get();
    return rows
        .map(
          (row) => Interest(id: row.id, slug: row.slug, category: row.category),
        )
        .toList();
  }

  @override
  Future<void> writeAll(List<Interest> interests) async {
    await _db.batch((batch) {
      batch.deleteAll(_db.cachedInterests);
      batch.insertAll(
        _db.cachedInterests,
        interests.map(
          (i) => CachedInterestsCompanion.insert(
            id: Value(i.id),
            slug: i.slug,
            category: Value(i.category),
          ),
        ),
      );
    });
  }
}

InterestCache createInterestCache() => NativeInterestCache(appDatabase);
