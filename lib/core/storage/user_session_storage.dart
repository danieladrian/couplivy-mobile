import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

/// Cache data user dasar (full_name, nick_name) di SharedPreferences —
/// diisi begitu Sign Up/Login sukses, dibaca lagi oleh layar mana pun
/// yang butuh personalisasi cepat (mis. GatewayChoiceScreen: "Hello
/// Daniel, ...") TANPA perlu API call tambahan atau nge-drag `User` lewat
/// parameter route/provider lintas screen.
///
/// BUKAN pengganti sumber kebenaran (server tetap otoritatif) — murni
/// cache lokal untuk kenyamanan UI. Dibersihkan saat logout.
abstract final class UserSessionStorage {
  static const _nickNameKey = 'user_session_nick_name';
  static const _fullNameKey = 'user_session_full_name';

  static Future<void> save(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // nickName nullable — akun lama (dibuat sebelum field ini ada) belum
    // punya nilainya. Hapus key lama daripada nyimpen string kosong,
    // supaya readNickName() balikin null (bukan '') buat pemanggil.
    if (user.nickName != null) {
      await prefs.setString(_nickNameKey, user.nickName!);
    } else {
      await prefs.remove(_nickNameKey);
    }
    await prefs.setString(_fullNameKey, user.fullName);
  }

  static Future<String?> readNickName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nickNameKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nickNameKey);
    await prefs.remove(_fullNameKey);
  }
}
