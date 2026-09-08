/// Master data minat dari `GET /api/interests` — dipakai render chip
/// multi-select di step Interests onboarding Discover. `slug` dipakai
/// sebagai key i18n (label ditampilkan lewat `AppLocalizations`, lihat
/// `InterestLabels`), BUKAN teks langsung dari server.
class Interest {
  const Interest({required this.id, required this.slug});

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(id: json['id'] as int, slug: json['slug'] as String);
  }

  final int id;
  final String slug;
}
