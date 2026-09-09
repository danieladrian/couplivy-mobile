/// Representasi user dari response API Laravel (`users` table). Field
/// profil dating (dob, gender, dst) ADA di tabel `profiles` terpisah di
/// backend — model ini cuma cover kolom `users` (auth inti).
class User {
  const User({
    required this.id,
    required this.fullName,
    required this.nickName,
    required this.email,
    required this.phone,
    required this.locale,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      // Nullable — akun yang dibuat SEBELUM field ini diwajibkan (lihat
      // migration rename_name_to_full_name_and_add_nick_name_on_users_table)
      // masih punya nick_name = null di database. Kalau di-cast paksa
      // `as String`, TypeError ini bukan DioException dan LOLOS dari
      // try/catch di AuthRepository/AuthFormController — user macet di
      // state loading selamanya tanpa pesan error apapun (bug nyata yang
      // pernah kejadian, jangan ulangi cast paksa di sini).
      nickName: json['nick_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      locale: json['locale'] as String? ?? 'en',
    );
  }

  final int id;
  final String fullName;

  /// Nama panggilan — diisi WAJIB saat Sign Up (bukan step onboarding
  /// terpisah) UNTUK AKUN BARU. Nullable karena akun lama (dibuat sebelum
  /// field ini ada) belum punya nilainya. Dipakai untuk personalisasi UI
  /// (mis. Gateway Choice: "Hello Daniel, ...") dan (nanti) nama tampilan
  /// di Discover — pemanggil WAJIB tangani kasus null (lihat
  /// GatewayChoiceScreen fallback title).
  final String? nickName;
  final String? email;
  final String? phone;
  final String locale;
}
