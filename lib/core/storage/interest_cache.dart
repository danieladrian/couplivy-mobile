import '../models/interest.dart';

/// Kontrak cache lokal Interests — SATU abstraksi dipakai
/// `InterestRepository`, 2 implementasi dipilih via conditional import
/// (lihat `interest_cache_native.dart`/`interest_cache_web.dart`):
/// native pakai SQLite (drift), web pakai in-memory `List` biasa (TIDAK
/// persist antar reload browser — trade-off yang diterima supaya
/// `flutter run -d chrome` bisa dipakai untuk dev cepat tanpa setup
/// drift-wasm, lihat .ai/rules/architecture.md).
abstract class InterestCache {
  Future<List<Interest>> readAll();
  Future<void> writeAll(List<Interest> interests);
}
