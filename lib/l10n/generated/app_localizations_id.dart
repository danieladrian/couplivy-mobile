// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Couplivy';

  @override
  String get splashTagline => 'Dibuat untuk Cinta yang Bermakna';

  @override
  String get welcomeGetStarted => 'Daftar';

  @override
  String get welcomeLogIn => 'Masuk';

  @override
  String get welcomeTapBackAgainToExit => 'Tekan sekali lagi untuk keluar';

  @override
  String get authContinueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get authContinueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get authOr => 'atau';

  @override
  String get authFullNameLabel => 'Nama Lengkap';

  @override
  String get authFullNameHint => 'Nama lengkapmu';

  @override
  String get authNickNameLabel => 'Nama Panggilan';

  @override
  String get authNickNameHint => 'Mau dipanggil apa?';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'nama@email.com';

  @override
  String get authPhoneLabel => 'Nomor HP';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHintSignUp => 'Buat password';

  @override
  String get authPasswordHelperSignUp =>
      'Min 8 karakter, ada huruf besar, kecil & angka';

  @override
  String get authPasswordHintLogin => 'Password kamu';

  @override
  String get authForgotPassword => 'Lupa password?';

  @override
  String get authComingSoon =>
      'Segera hadir — perlu setup kredensial Google/Apple Developer dulu.';

  @override
  String get signUpTitle => 'Buat Akun';

  @override
  String get signUpSubmit => 'Buat Akun';

  @override
  String get signUpFooterQuestion => 'Sudah punya akun?';

  @override
  String get signUpFooterAction => 'Masuk';

  @override
  String get loginTitle => 'Masuk Kembali';

  @override
  String get loginIdentifierLabel => 'Email / Nomor HP';

  @override
  String get loginSubmit => 'Masuk';

  @override
  String get loginFooterQuestion => 'Belum punya akun?';

  @override
  String get loginFooterAction => 'Daftar';

  @override
  String gatewayChoiceTitle(String nickName) {
    return 'Hai $nickName,';
  }

  @override
  String get gatewayChoiceTitleFallback => 'Hai,';

  @override
  String get gatewayChoiceSubtitle =>
      'Kamu di Couplivy untuk apa? Ini akan menentukan pengalaman yang kamu dapat — bisa diubah nanti dari Profile.';

  @override
  String get gatewayChoiceDiscoverTitle => 'Mencari koneksi baru';

  @override
  String get gatewayChoiceDiscoverDescription =>
      'Kamu akan melalui pengisian profil lengkap — bio, minat, tujuan hubungan — lalu masuk ke Discover untuk bertemu orang baru.';

  @override
  String get gatewayChoiceDiscoverCta => 'Mulai isi profil';

  @override
  String get gatewayChoiceTogetherTitle => 'Sudah punya pasangan';

  @override
  String get gatewayChoiceTogetherDescription =>
      'Sudah pacaran serius atau menikah? Hubungkan akun kalian berdua dan langsung masuk ke ruang \"Growing Together\" — tanpa perlu isi preferensi kencan.';

  @override
  String get gatewayChoiceTogetherCta => 'Segera hadir';

  @override
  String get onboardingContinue => 'Lanjut';

  @override
  String get onboardingSkip => 'Lewati';

  @override
  String get dobTitle => 'Kapan kamu lahir?';

  @override
  String get dobSubtitle => 'Usiamu akan dihitung otomatis.';

  @override
  String get dobFieldLabel => 'Tanggal lahir';

  @override
  String get dobAgeResultLabel => 'Usiamu';

  @override
  String dobAgeResultUnit(int age) {
    return '$age tahun';
  }

  @override
  String get dobUnderageError =>
      'Kamu harus berusia minimal 18 tahun untuk memakai Couplivy.';

  @override
  String get genderTitle => 'Apa jenis kelaminmu?';

  @override
  String get genderSubtitle =>
      'Ini membantu kami menunjukkan kecocokan yang lebih baik.';

  @override
  String get genderFemale => 'Perempuan';

  @override
  String get genderMale => 'Laki-laki';

  @override
  String get genderPreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get photosTitle => 'Tambahkan fotomu';

  @override
  String get photosSubtitle =>
      'Beberapa foto jelas membantu kamu dapat kecocokan lebih baik.';

  @override
  String get photosMainPhotoLabel => 'Foto Utama';

  @override
  String get photosMinimumError =>
      'Tambahkan minimal 1 foto untuk melanjutkan.';

  @override
  String get photosSourceCamera => 'Ambil foto';

  @override
  String get photosSourceGallery => 'Pilih dari galeri';

  @override
  String get bioTitle => 'Ceritakan tentang dirimu';

  @override
  String get bioSubtitle =>
      'Beberapa kalimat tentang kamu, plus beberapa detail untuk kecocokan lebih baik.';

  @override
  String get bioFieldHint =>
      'mis. Aku suka kopi enak, hiking akhir pekan, dan obrolan yang bermakna.';

  @override
  String bioCharCount(int current, int max) {
    return '$current/$max';
  }

  @override
  String get bioHeightLabel => 'Tinggi';

  @override
  String get bioHeightHintCm => 'mis. 170';

  @override
  String get bioHeightHintFeet => 'Kaki';

  @override
  String get bioHeightHintInch => 'Inci';

  @override
  String get bioEthnicityLabel => 'Etnis';

  @override
  String get bioEthnicityHint => 'Pilih etnis';

  @override
  String get bioReligionLabel => 'Agama';

  @override
  String get bioReligionHint => 'Pilih agama';

  @override
  String get ethnicityEastAsian => 'Asia Timur';

  @override
  String get ethnicitySouthAsian => 'Asia Selatan';

  @override
  String get ethnicitySoutheastAsian => 'Asia Tenggara';

  @override
  String get ethnicityMiddleEastern => 'Timur Tengah';

  @override
  String get ethnicityBlackAfrican => 'Kulit Hitam / Afrika';

  @override
  String get ethnicityHispanicLatino => 'Hispanik / Latino';

  @override
  String get ethnicityWhiteEuropean => 'Kulit Putih / Eropa';

  @override
  String get ethnicityJavanese => 'Jawa';

  @override
  String get ethnicitySundanese => 'Sunda';

  @override
  String get ethnicityBatak => 'Batak';

  @override
  String get ethnicityMinangkabau => 'Minangkabau';

  @override
  String get ethnicityBalinese => 'Bali';

  @override
  String get ethnicityMadurese => 'Madura';

  @override
  String get ethnicityBetawi => 'Betawi';

  @override
  String get ethnicityBugis => 'Bugis';

  @override
  String get ethnicityDayak => 'Dayak';

  @override
  String get ethnicityPapuan => 'Papua';

  @override
  String get ethnicityOther => 'Lainnya';

  @override
  String get ethnicityPreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get bioLoveLanguageLabel => 'Apa bahasa cintamu? (maks 2)';

  @override
  String get loveLanguageWordsOfAffirmation => 'Kata-kata Penegasan';

  @override
  String get loveLanguageQualityTime => 'Waktu Berkualitas';

  @override
  String get loveLanguageActsOfService => 'Tindakan Pelayanan';

  @override
  String get loveLanguagePhysicalTouch => 'Sentuhan Fisik';

  @override
  String get loveLanguageGifts => 'Hadiah';

  @override
  String get loveLanguageDontKnowYet => 'Belum tahu';

  @override
  String get bioAllFieldsRequiredError => 'Isi semua field untuk melanjutkan.';

  @override
  String get workEducationTitle => 'Kamu kerja apa?';

  @override
  String get workEducationSubtitle => 'Karier dan pendidikanmu.';

  @override
  String get workEducationOccupationLabel => 'Pekerjaan';

  @override
  String get workEducationOccupationHint => 'Pekerjaanmu';

  @override
  String get workEducationEducationLabel => 'Pendidikan';

  @override
  String get workEducationEducationHint => 'Pilih pendidikan';

  @override
  String get educationNoEducation => 'Tidak Sekolah';

  @override
  String get educationElementary => 'SD';

  @override
  String get educationHighSchool => 'SMA';

  @override
  String get educationBachelor => 'S1';

  @override
  String get educationMaster => 'S2';

  @override
  String get educationDoctorate => 'S3';

  @override
  String get workEducationAllFieldsRequiredError =>
      'Isi pekerjaan dan pendidikan untuk melanjutkan.';

  @override
  String get interestsTitle => 'Apa minatmu?';

  @override
  String get interestsSubtitle => 'Pilih beberapa hal yang kamu suka.';

  @override
  String interestsSelectedCount(int count) {
    return '$count/5 dipilih · pilih minimal 3';
  }

  @override
  String get interestsMinimumError =>
      'Pilih minimal 3 minat untuk melanjutkan.';

  @override
  String get interestsMaximumError => 'Pilih maksimal 5 minat.';

  @override
  String get lifestyleTitle => 'Gaya hidupmu';

  @override
  String get lifestyleSubtitle =>
      'Bantu orang lain mengenal kebiasaan sehari-harimu.';

  @override
  String get lifestyleDrinkingLabel => 'Minum Alkohol';

  @override
  String get lifestyleSmokingLabel => 'Merokok';

  @override
  String get lifestylePetsLabel => 'Hewan Peliharaan';

  @override
  String get drinkingNever => 'Tidak Pernah';

  @override
  String get drinkingOccasionally => 'Sesekali';

  @override
  String get drinkingSocially => 'Saat Bersosialisasi';

  @override
  String get drinkingRegularly => 'Rutin';

  @override
  String get drinkingPreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get smokingNever => 'Tidak Pernah';

  @override
  String get smokingOccasionally => 'Sesekali';

  @override
  String get smokingRegularly => 'Rutin';

  @override
  String get smokingPreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get petPreferenceLovePets => 'Suka hewan peliharaan';

  @override
  String get petPreferenceNeutral => 'Biasa saja';

  @override
  String get petPreferenceNotAFan => 'Kurang suka';

  @override
  String get lifestyleAllFieldsRequiredError =>
      'Isi semua field untuk melanjutkan.';

  @override
  String get futureTitle => 'Rencana ke depan';

  @override
  String get futureSubtitle => 'Pandanganmu soal anak dan pernikahan.';

  @override
  String get futureChildrenLabel => 'Anak';

  @override
  String get futureMarriageLabel => 'Pernikahan';

  @override
  String get childrenPreferenceWantChildren => 'Ingin punya anak';

  @override
  String get childrenPreferenceNotWantChildren => 'Tidak ingin punya anak';

  @override
  String get childrenPreferenceHaveChildren => 'Sudah punya anak';

  @override
  String get childrenPreferenceOpenToChildren => 'Terbuka untuk punya anak';

  @override
  String get childrenPreferenceNotSure => 'Belum yakin';

  @override
  String get childrenPreferencePreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get marriagePreferenceWantMarriage => 'Ingin menikah';

  @override
  String get marriagePreferenceOpenToMarriage => 'Terbuka untuk menikah';

  @override
  String get marriagePreferenceNotWantMarriage => 'Tidak ingin menikah';

  @override
  String get marriagePreferenceNotSure => 'Belum yakin';

  @override
  String get futureAllFieldsRequiredError =>
      'Isi semua field untuk melanjutkan.';

  @override
  String get interestCategoryFood => 'Kuliner';

  @override
  String get interestCategoryTravel => 'Traveling';

  @override
  String get interestCategorySports => 'Olahraga';

  @override
  String get interestCategoryArts => 'Seni';

  @override
  String get interestCategoryEntertainment => 'Hiburan';

  @override
  String get interestCoffeeTea => 'Kopi / Teh';

  @override
  String get interestStreetFood => 'Kuliner Kaki Lima';

  @override
  String get interestGeneralFood => 'Kuliner';

  @override
  String get interestBeachTrips => 'Wisata Pantai';

  @override
  String get interestMountainTrips => 'Wisata Gunung';

  @override
  String get interestCulturalTrips => 'Wisata Budaya';

  @override
  String get interestCityTrips => 'Wisata Kota';

  @override
  String get interestGym => 'Gym';

  @override
  String get interestBallSport => 'Olahraga Bola';

  @override
  String get interestRacketSport => 'Olahraga Raket';

  @override
  String get interestRunning => 'Lari';

  @override
  String get interestMindBodyExercise => 'Olahraga Mind & Body';

  @override
  String get interestCardio => 'Kardio';

  @override
  String get interestArt => 'Seni';

  @override
  String get interestMusic => 'Musik';

  @override
  String get interestSinging => 'Bernyanyi';

  @override
  String get interestDancing => 'Menari';

  @override
  String get interestPlayingMusic => 'Main Alat Musik';

  @override
  String get interestTvSeries => 'Serial TV';

  @override
  String get interestMovies => 'Film';

  @override
  String get interestAnime => 'Anime';

  @override
  String get interestKDrama => 'Drama Korea';

  @override
  String get interestGaming => 'Gaming';

  @override
  String get interestStandUpComedy => 'Stand-up Comedy';

  @override
  String get interestPodcast => 'Podcast';

  @override
  String get interestBooks => 'Buku';

  @override
  String get relationshipGoalTitle => 'Kamu mencari apa?';

  @override
  String get relationshipGoalSubtitle =>
      'Ini membantu kami menunjukkan orang dengan niat yang sama.';

  @override
  String get relationshipGoalSeriousTitle => 'Kencan Serius';

  @override
  String get relationshipGoalSeriousDescription =>
      'Mencari hubungan jangka panjang';

  @override
  String get relationshipGoalCasualTitle => 'Kencan Santai';

  @override
  String get relationshipGoalCasualDescription =>
      'Kenalan santai, lihat kelanjutannya';

  @override
  String get relationshipGoalNewConnectionsTitle => 'Kenalan Baru';

  @override
  String get relationshipGoalNewConnectionsDescription =>
      'Terbuka kenal orang baru, tanpa tekanan';

  @override
  String get relationshipGoalStillFiguringOutTitle => 'Masih Mencari Tahu';

  @override
  String get relationshipGoalStillFiguringOutDescription =>
      'Belum yakin, masih eksplorasi dulu';

  @override
  String get preferencesTitle => 'Ceritakan siapa yang kamu cari';

  @override
  String preferencesAgeRangeLabel(int min, int max) {
    return '$min – $max tahun';
  }

  @override
  String get preferencesOpenForAll => 'Terbuka untuk semua';

  @override
  String get preferencesGenderLabel => 'Jenis Kelamin';

  @override
  String get preferencesChildrenLabel => 'Anak';

  @override
  String get preferencesMarriageLabel => 'Pernikahan';

  @override
  String get preferencesEthnicityLabel => 'Etnis';

  @override
  String get preferencesReligionLabel => 'Agama';

  @override
  String get preferencesEducationLabel => 'Pendidikan';

  @override
  String get preferencesDrinkingLabel => 'Minum Alkohol';

  @override
  String get preferencesSmokingLabel => 'Merokok';

  @override
  String get preferencesPetsLabel => 'Hewan Peliharaan';

  @override
  String get religionIslam => 'Islam';

  @override
  String get religionChristianity => 'Kristen';

  @override
  String get religionCatholic => 'Katolik';

  @override
  String get religionHinduism => 'Hindu';

  @override
  String get religionBuddhism => 'Buddha';

  @override
  String get religionConfucianism => 'Konghucu';

  @override
  String get religionJudaism => 'Yahudi';

  @override
  String get religionSikhism => 'Sikh';

  @override
  String get religionTaoism => 'Tao';

  @override
  String get religionOther => 'Lainnya';

  @override
  String get religionAgnostic => 'Agnostik';

  @override
  String get religionAtheist => 'Atheis';

  @override
  String get religionPreferNotToSay => 'Tidak ingin menyebutkan';

  @override
  String get previewTitle => 'Hampir selesai!';

  @override
  String get previewSubtitle => 'Cek dulu profilmu sebelum lanjut.';

  @override
  String previewNameAge(String nickName, int age) {
    return '$nickName, $age';
  }

  @override
  String get previewLookingForTitle => 'Sedang mencari';

  @override
  String get previewSubmit => 'Ayo Mulai';

  @override
  String get previewSubmitError =>
      'Ada masalah saat menyimpan profilmu. Coba lagi.';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navConnections => 'Connections';

  @override
  String get navProfile => 'Profil';

  @override
  String get discoverEmptyMessage =>
      'Belum ada profil lagi untuk sekarang — cek lagi nanti atau refresh.';

  @override
  String get discoverRefreshLabel => 'Refresh Rekomendasi';

  @override
  String discoverDistanceLabel(String occupation, int distanceKm) {
    return '$occupation · $distanceKm km';
  }

  @override
  String get discoverCompatibleLabel => 'COMPATIBLE';

  @override
  String get connectionsTitle => 'Connections';

  @override
  String get connectionsMatchesTab => 'Matches';

  @override
  String get connectionsEmptyMessage =>
      'Belum ada match — terus jelajahi Discover!';

  @override
  String connectionsSharedInterestsLabel(String interests) {
    return 'Kalian berdua suka $interests';
  }

  @override
  String get chatTypeMessageHint => 'Ketik pesan...';

  @override
  String get chatOnlineStatus => 'Online';

  @override
  String get profileCompletenessLabel => 'Kelengkapan profil';

  @override
  String get profileUpgradeTitle => 'Upgrade ke Couplivy Plus';

  @override
  String get profileUpgradeSubtitle => 'Buka lebih banyak cara untuk terhubung';

  @override
  String get profileMenuMyProfile => 'Profil Saya';

  @override
  String get profileMenuMyPreferences => 'Preferensi Saya';

  @override
  String get profileMenuNotifications => 'Notifikasi';

  @override
  String get profileMenuPrivacy => 'Privasi & Visibilitas';

  @override
  String get profileMenuSafety => 'Keamanan & Laporan';

  @override
  String get profileMenuAppSettings => 'Pengaturan Aplikasi';

  @override
  String get profileMenuTerms => 'Ketentuan & Privasi';

  @override
  String get profileMenuLogOut => 'Keluar';

  @override
  String get profileLogOutConfirmTitle => 'Keluar?';

  @override
  String get profileLogOutConfirmMessage =>
      'Kamu perlu login lagi untuk mengakses akunmu.';

  @override
  String get profileLogOutConfirmCancel => 'Batal';

  @override
  String get profileLogOutConfirmConfirm => 'Keluar';

  @override
  String get profileComingSoonTitle => 'Segera hadir';

  @override
  String get profileComingSoonMessage =>
      'Bagian ini belum siap — cek lagi nanti.';

  @override
  String get myProfileLoveLanguageLabel => 'Bahasa cinta';

  @override
  String get myProfileRelationshipGoalLabel => 'Tujuan hubungan';

  @override
  String get myPreferencesTitle => 'Preferensi Saya';

  @override
  String get myPreferencesAgeRangeLabel => 'Rentang usia';

  @override
  String get myPreferencesEmptyMessage => 'Kamu belum mengatur preferensimu.';

  @override
  String get myProfileAboutTitle => 'Tentang';

  @override
  String get myProfileInterestsTitle => 'Minat';

  @override
  String get editLabel => 'Ubah';

  @override
  String get editProfileSaveLabel => 'Simpan';

  @override
  String get appSettingsTitle => 'Pengaturan Aplikasi';

  @override
  String get appSettingsLanguageLabel => 'Bahasa';

  @override
  String get appSettingsLanguageEnglish => 'Inggris';

  @override
  String get appSettingsLanguageIndonesian => 'Indonesia';

  @override
  String get appSettingsVersionLabel => 'Versi aplikasi';

  @override
  String get termsTitle => 'Ketentuan & Privasi';

  @override
  String get termsOfServiceLabel => 'Ketentuan Layanan';

  @override
  String get termsPrivacyPolicyLabel => 'Kebijakan Privasi';

  @override
  String get privacyTitle => 'Privasi & Visibilitas';

  @override
  String get privacyHideProfileLabel => 'Sembunyikan profil saya';

  @override
  String get privacyHideProfileDescription =>
      'Profilmu tidak akan muncul di Discover untuk siapa pun.';

  @override
  String get privacyShowReligionLabel => 'Tampilkan agama';

  @override
  String get privacyShowReligionDescription =>
      'Izinkan orang lain melihat agamamu di profil.';

  @override
  String get privacyShowEthnicityLabel => 'Tampilkan etnis';

  @override
  String get privacyShowEthnicityDescription =>
      'Izinkan orang lain melihat etnismu di profil.';

  @override
  String get privacyShowHeightWeightLabel => 'Tampilkan tinggi badan';

  @override
  String get privacyShowHeightWeightDescription =>
      'Izinkan orang lain melihat tinggi badanmu di profil.';

  @override
  String get privacyAllowDirectAddLabel => 'Izinkan tambah langsung';

  @override
  String get privacyAllowDirectAddDescription =>
      'Izinkan orang lain menambahkanmu langsung tanpa match dulu.';

  @override
  String get privacyShowOnlineStatusLabel => 'Tampilkan status online';

  @override
  String get privacyShowOnlineStatusDescription =>
      'Izinkan orang lain melihat kapan kamu aktif.';

  @override
  String get privacyAiConversationAssistantLabel => 'Asisten percakapan AI';

  @override
  String get privacyAiConversationAssistantDescription =>
      'Dapatkan saran pembuka obrolan dan balasan dari AI di chat.';

  @override
  String get privacySaveError => 'Gagal menyimpan perubahanmu. Coba lagi.';
}
