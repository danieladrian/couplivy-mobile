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
      nickName: json['nick_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      locale: json['locale'] as String? ?? 'en',
    );
  }

  final int id;
  final String fullName;

  /// Nama panggilan — diisi WAJIB saat Sign Up (bukan step onboarding
  /// terpisah). Dipakai untuk personalisasi UI (mis. Gateway Choice:
  /// "Hello Daniel, ...") dan (nanti) nama tampilan di Discover.
  final String nickName;
  final String? email;
  final String? phone;
  final String locale;
}
