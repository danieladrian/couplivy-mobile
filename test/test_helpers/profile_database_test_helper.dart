import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';

import 'package:couplivy_mobile/core/storage/app_database.dart';
import 'package:couplivy_mobile/core/models/my_profile.dart';
import 'package:couplivy_mobile/core/storage/profile_database.dart';

/// Ganti `appDatabase` global dengan instance in-memory — dipanggil di
/// `setUp()` widget test yang menyentuh `ProfileDatabase` (langsung atau
/// tidak langsung lewat `ProfileScreen`/`MyProfileScreen`/
/// `MyPreferencesScreen`), supaya test TIDAK nulis ke file SQLite
/// sungguhan di disk dan TIDAK saling bocor data antar test (instance
/// baru tiap `setUp()`).
///
/// `dontWarnAboutMultipleDatabases = true` — drift biasanya warning kalau
/// `AppDatabase` dibuat berkali-kali (indikasi bug di app sungguhan),
/// tapi di sini MEMANG disengaja (1 instance baru per test case) dan
/// aman — tiap instance pakai `QueryExecutor` in-memory TERPISAH
/// (`NativeDatabase.memory()` baru tiap panggilan), tidak ada race
/// condition nyata seperti yang warning itu peringatkan.
void useInMemoryAppDatabaseForTesting() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  appDatabase = AppDatabase.forTesting(NativeDatabase.memory());
}

/// Helper seed data — isi `ProfileDatabase` langsung (tanpa lewat
/// network/`ProfileRepository`) untuk widget test yang butuh database
/// lokal sudah terisi SEBELUM `pumpWidget()`. Panggil
/// `useInMemoryAppDatabaseForTesting()` dulu di `setUp()`.
Future<void> seedProfileDatabase(MyProfile profile) {
  return ProfileDatabase.save(profile);
}
