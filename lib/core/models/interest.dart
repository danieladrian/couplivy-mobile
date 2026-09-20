/// Master data minat dari `GET /api/interests` — dipakai render chip
/// multi-select (dikelompokkan per `category`) di step Interests
/// onboarding Discover. `slug`/`category` dipakai sebagai key i18n
/// (label ditampilkan lewat `AppLocalizations`, lihat `InterestLabels`),
/// BUKAN teks langsung dari server.
class Interest {
  const Interest({
    required this.id,
    required this.slug,
    required this.category,
  });

  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      id: json['id'] as int,
      slug: json['slug'] as String,
      category: json['category'] as String,
    );
  }

  final int id;
  final String slug;
  final String category;
}
