import '../../../l10n/generated/app_localizations.dart';

/// Terjemahkan `slug` interest (dari `GET /api/interests`, mis. "travel")
/// jadi label yang ditampilkan (lewat `AppLocalizations`, BUKAN teks
/// langsung dari server — server cuma kirim slug, label per-bahasa ada di
/// ARB, sesuai desain: "slug dipakai sebagai key i18n").
abstract final class InterestLabels {
  static String labelFor(AppLocalizations l10n, String slug) {
    return switch (slug) {
      'travel' => l10n.interestTravel,
      'coffee' => l10n.interestCoffee,
      'hiking' => l10n.interestHiking,
      'food' => l10n.interestFood,
      'music' => l10n.interestMusic,
      'movies' => l10n.interestMovies,
      'sports' => l10n.interestSports,
      'reading' => l10n.interestReading,
      'art' => l10n.interestArt,
      'nature' => l10n.interestNature,
      _ => slug,
    };
  }
}
