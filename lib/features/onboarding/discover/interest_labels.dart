import '../../../l10n/generated/app_localizations.dart';

/// Terjemahkan `slug` interest (dari `GET /api/interests`, mis. "travel")
/// jadi label yang ditampilkan (lewat `AppLocalizations`, BUKAN teks
/// langsung dari server — server cuma kirim slug, label per-bahasa ada di
/// ARB, sesuai desain: "slug dipakai sebagai key i18n").
abstract final class InterestLabels {
  static String labelFor(AppLocalizations l10n, String slug) {
    return switch (slug) {
      'travel' => l10n.interestTravel,
      // Label diperluas jadi "Coffee & Tea" — slug tetap 'coffee' (tidak
      // perlu migrasi data), cuma representasi tampilannya mewakili
      // keduanya, konsisten dengan kategori luas lainnya.
      'coffee' => l10n.interestCoffee,
      'hiking' => l10n.interestHiking,
      'food' => l10n.interestFood,
      'music' => l10n.interestMusic,
      'movies' => l10n.interestMovies,
      'sports' => l10n.interestSports,
      'reading' => l10n.interestReading,
      'art' => l10n.interestArt,
      'nature' => l10n.interestNature,
      'gaming' => l10n.interestGaming,
      'photography' => l10n.interestPhotography,
      'fitness' => l10n.interestFitness,
      'cooking' => l10n.interestCooking,
      'dancing' => l10n.interestDancing,
      'pets' => l10n.interestPets,
      'fashion' => l10n.interestFashion,
      'wine' => l10n.interestWine,
      'volunteering' => l10n.interestVolunteering,
      'writing' => l10n.interestWriting,
      'gardening' => l10n.interestGardening,
      'camping' => l10n.interestCamping,
      'yoga' => l10n.interestYoga,
      'technology' => l10n.interestTechnology,
      _ => slug,
    };
  }
}
