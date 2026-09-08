import 'package:shared_preferences/shared_preferences.dart';

/// Draft field onboarding Discover (Name, DOB, dst) — disimpan LOKAL di
/// SharedPreferences sepanjang user mengisi step 2-10, TIDAK dikirim ke
/// server sampai step terakhir (lihat DiscoverOnboardingRepository.complete()).
///
/// Bertahan walau app di-kill (SharedPreferences persisten di disk), TAPI
/// hilang kalau app di-uninstall — itu keputusan produk yang diterima
/// (lihat .ai/rules/architecture.md): user yang uninstall/logout sebelum
/// menyelesaikan step terakhir mulai dari step 1 lagi.
///
/// Key di-prefix `onboarding_discover_draft_` supaya tidak bentrok dengan
/// key SharedPreferences lain yang mungkin ditambah nanti.
abstract final class DiscoverOnboardingDraftStorage {
  static const _nameKey = 'onboarding_discover_draft_name';

  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  static Future<String?> readName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  /// Hapus semua draft — dipanggil setelah submit sukses ke server
  /// (`complete()`), supaya draft lama tidak nyangkut kalau user
  /// onboarding lagi nanti (device baru/akun baru login di device sama).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nameKey);
  }
}
