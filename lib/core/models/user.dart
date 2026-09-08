/// Representasi user dari response API Laravel (`users` table). Field
/// profil dating (display_name, dob, dst) ADA di tabel `profiles` terpisah
/// di backend — model ini cuma cover kolom `users` (auth inti).
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.locale,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      locale: json['locale'] as String? ?? 'en',
    );
  }

  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String locale;
}
