import 'interest_cache.dart';
import 'interest_cache_native.dart'
    if (dart.library.js_interop) 'interest_cache_web.dart'
    as impl;

/// Titik masuk TUNGGAL untuk bikin [InterestCache] — pilih implementasi
/// native (drift/SQLite) atau web (in-memory) lewat conditional import,
/// DICEK saat compile time (`dart.library.js_interop` cuma ada di web),
/// BUKAN runtime `kIsWeb`. Ini WAJIB conditional import (bukan if/else
/// `kIsWeb` biasa) — `interest_cache_native.dart` meng-import
/// `package:drift/native.dart` yang transitif meng-import `dart:ffi` via
/// `package:sqlite3`, dan `dart:ffi` GAGAL DI-COMPILE SAMA SEKALI untuk
/// target web (bukan cuma gagal runtime) kalau sampai ter-include di
/// dependency graph — makanya `app_database.dart` TIDAK BOLEH di-import
/// dari kode yang juga dikompail ke web tanpa conditional import ini.
InterestCache createInterestCache() => impl.createInterestCache();
