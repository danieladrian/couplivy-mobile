import '../../../l10n/generated/app_localizations.dart';

/// Terjemahkan `slug`/`category` interest (dari `GET /api/interests`,
/// mis. slug "coffee_tea", category "food") jadi label yang ditampilkan
/// (lewat `AppLocalizations`, BUKAN teks langsung dari server — server
/// cuma kirim slug/category, label per-bahasa ada di ARB).
///
/// GANTI TOTAL dari daftar lama (20 interest generik flat) — 26 interest
/// baru, dikelompokkan 5 kategori (Food, Travel, Sports, Arts,
/// Entertainment), keputusan produk (lihat couplivy-backend
/// InterestSeeder).
abstract final class InterestLabels {
  static String labelFor(AppLocalizations l10n, String slug) {
    return switch (slug) {
      'coffee_tea' => l10n.interestCoffeeTea,
      'street_food' => l10n.interestStreetFood,
      'general_food' => l10n.interestGeneralFood,
      'beach_trips' => l10n.interestBeachTrips,
      'mountain_trips' => l10n.interestMountainTrips,
      'cultural_trips' => l10n.interestCulturalTrips,
      'city_trips' => l10n.interestCityTrips,
      'gym' => l10n.interestGym,
      'ball_sport' => l10n.interestBallSport,
      'racket_sport' => l10n.interestRacketSport,
      'running' => l10n.interestRunning,
      'mind_body_exercise' => l10n.interestMindBodyExercise,
      'cardio' => l10n.interestCardio,
      'art' => l10n.interestArt,
      'music' => l10n.interestMusic,
      'singing' => l10n.interestSinging,
      'dancing' => l10n.interestDancing,
      'playing_music' => l10n.interestPlayingMusic,
      'tv_series' => l10n.interestTvSeries,
      'movies' => l10n.interestMovies,
      'anime' => l10n.interestAnime,
      'k_drama' => l10n.interestKDrama,
      'gaming' => l10n.interestGaming,
      'stand_up_comedy' => l10n.interestStandUpComedy,
      'podcast' => l10n.interestPodcast,
      'books' => l10n.interestBooks,
      _ => slug,
    };
  }

  /// Judul section per kategori di step Interests (lihat
  /// `InterestsStepScreen`) — urutan section HARUS ikut urutan
  /// `category` yang dikembalikan API (Food, Travel, Sports, Arts,
  /// Entertainment berturut-turut, lihat `InterestController`), bukan
  /// diurutkan ulang di sini.
  static String categoryLabelFor(AppLocalizations l10n, String category) {
    return switch (category) {
      'food' => l10n.interestCategoryFood,
      'travel' => l10n.interestCategoryTravel,
      'sports' => l10n.interestCategorySports,
      'arts' => l10n.interestCategoryArts,
      'entertainment' => l10n.interestCategoryEntertainment,
      _ => category,
    };
  }
}
