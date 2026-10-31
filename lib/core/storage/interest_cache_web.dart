import '../models/interest.dart';
import 'interest_cache.dart';

/// Implementasi web — in-memory `List` biasa, TIDAK persist antar reload
/// browser/tab baru (hilang begitu halaman di-refresh). Trade-off yang
/// DITERIMA supaya `flutter run -d chrome` bisa dipakai untuk dev cepat
/// tanpa setup drift-wasm (butuh file `sqlite3.wasm` + compile drift
/// worker ke JS manual, lihat .ai/rules/architecture.md) — web BUKAN
/// target rilis utama app ini (mobile-first), cuma alat bantu development.
/// `InterestRepository.list()` tetap fallback ke network kalau cache
/// (in-memory ini) kosong, jadi UI tetap berfungsi penuh di web, cuma
/// selalu network call ulang tiap reload browser.
class WebInterestCache implements InterestCache {
  List<Interest> _cached = [];

  @override
  Future<List<Interest>> readAll() async => _cached;

  @override
  Future<void> writeAll(List<Interest> interests) async {
    _cached = interests;
  }
}

InterestCache createInterestCache() => WebInterestCache();
