import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/models/interest.dart';
import '../../../core/storage/app_database.dart';

/// Panggil `GET /api/interests` — daftar master data minat untuk render
/// chip di step Interests. Terpisah dari `DiscoverOnboardingRepository`
/// karena endpoint ini BUKAN di bawah `/onboarding/discover/*` (interests
/// adalah master data umum, bisa dipakai fitur lain di luar onboarding
/// nanti, mis. Edit Profile).
///
/// DI-CACHE lokal (SQLite via drift, lihat `core/storage/app_database.dart`)
/// — [refreshCache] dipanggil sekali setelah login/register sukses
/// (lihat `AuthRepository._post`), BUKAN tiap kali step Interests dibuka.
/// [list] baca dari cache dulu (instan, tanpa network) dan cuma fallback
/// ke network kalau cache kosong (mis. akun lama sebelum fitur cache ini
/// ada, atau data lokal terhapus).
class InterestRepository {
  InterestRepository(this._dio, this._db);

  final Dio _dio;
  final AppDatabase _db;

  /// Dipanggil step Interests — cache-first supaya render instan.
  Future<List<Interest>> list() async {
    final cached = await _readCache();
    if (cached.isNotEmpty) return cached;

    // Cache kosong (akun lama / data lokal terhapus) — fallback network,
    // sekalian isi cache untuk pemanggilan berikutnya.
    final fresh = await _fetchFromNetwork();
    await _writeCache(fresh);
    return fresh;
  }

  /// Dipanggil setelah login/register sukses (lihat AuthRepository) —
  /// refresh cache di background SEBELUM user sampai step Interests,
  /// supaya [list] di atas hampir selalu hit cache. Kegagalan di sini
  /// SENGAJA diabaikan (bukan dilempar) — [list] tetap punya fallback
  /// network kalau cache masih kosong nanti.
  Future<void> refreshCache() async {
    try {
      final fresh = await _fetchFromNetwork();
      await _writeCache(fresh);
    } catch (_) {
      // Diamkan — lihat dokumentasi method di atas.
    }
  }

  Future<List<Interest>> _fetchFromNetwork() async {
    try {
      final response = await _dio.get('/interests');
      final body = response.data as Map<String, dynamic>;
      final rawInterests = body['interests'] as List<dynamic>;
      return rawInterests
          .map((raw) => Interest.fromJson(raw as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<Interest>> _readCache() async {
    final rows = await _db.select(_db.cachedInterests).get();
    return rows.map((row) => Interest(id: row.id, slug: row.slug)).toList();
  }

  Future<void> _writeCache(List<Interest> interests) async {
    await _db.batch((batch) {
      batch.deleteAll(_db.cachedInterests);
      batch.insertAll(
        _db.cachedInterests,
        interests.map(
          (i) => CachedInterestsCompanion.insert(id: Value(i.id), slug: i.slug),
        ),
      );
    });
  }
}

final interestRepository = InterestRepository(
  CouplivyApiClient.instance,
  appDatabase,
);
