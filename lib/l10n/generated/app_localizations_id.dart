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
  String get authPasswordHintSignUp => 'Minimal 8 karakter';

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
  String get genderNonBinary => 'Non-biner';

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
  String get bioHeightLabel => 'Tinggi (cm)';

  @override
  String get bioHeightHint => 'mis. 170';

  @override
  String get bioEthnicityLabel => 'Etnis';

  @override
  String get bioEthnicityHint => 'mis. Jawa';

  @override
  String get bioWantsChildrenLabel => 'Kamu mau punya anak?';

  @override
  String get bioWantsChildrenYes => 'Ya';

  @override
  String get bioWantsChildrenNo => 'Tidak';

  @override
  String get bioWantsChildrenNotSure => 'Belum yakin';

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
  String get educationHighSchool => 'SMA';

  @override
  String get educationBachelor => 'S1';

  @override
  String get educationMaster => 'S2';

  @override
  String get educationDoctorate => 'S3';

  @override
  String get educationAny => 'Semua';

  @override
  String get interestsTitle => 'Apa minatmu?';

  @override
  String get interestsSubtitle => 'Pilih beberapa hal yang kamu suka.';

  @override
  String interestsSelectedCount(int count) {
    return '$count dipilih · pilih minimal 3';
  }

  @override
  String get interestsMinimumError =>
      'Pilih minimal 3 minat, atau lewati step ini.';

  @override
  String get interestTravel => 'Traveling';

  @override
  String get interestCoffee => 'Kopi';

  @override
  String get interestHiking => 'Hiking';

  @override
  String get interestFood => 'Kuliner';

  @override
  String get interestMusic => 'Musik';

  @override
  String get interestMovies => 'Film';

  @override
  String get interestSports => 'Olahraga';

  @override
  String get interestReading => 'Membaca';

  @override
  String get interestArt => 'Seni';

  @override
  String get interestNature => 'Alam';

  @override
  String get relationshipGoalTitle => 'Kamu mencari apa?';

  @override
  String get relationshipGoalSubtitle =>
      'Ini membantu kami menunjukkan orang dengan niat yang sama.';

  @override
  String get relationshipGoalSeriousTitle => 'Hubungan Serius';

  @override
  String get relationshipGoalSeriousDescription =>
      'Mencari hubungan jangka panjang';

  @override
  String get relationshipGoalCasualTitle => 'Kencan Santai';

  @override
  String get relationshipGoalCasualDescription =>
      'Kenalan santai, lihat kelanjutannya';

  @override
  String get relationshipGoalFriendshipTitle => 'Pertemanan';

  @override
  String get relationshipGoalFriendshipDescription => 'Cari teman baru dulu';

  @override
  String get preferencesTitle => 'Ceritakan siapa yang kamu cari';

  @override
  String preferencesAgeRangeLabel(int min, int max) {
    return '$min – $max tahun';
  }

  @override
  String get preferencesGenderLabel => 'Jenis Kelamin';

  @override
  String get preferencesGenderAny => 'Semua';

  @override
  String get preferencesFamilyLabel => 'Preferensi keluarga';

  @override
  String get preferencesFamilyWantsChildren => 'Mau punya anak';

  @override
  String get preferencesFamilyNotWantsChildren => 'Tidak mau punya anak';

  @override
  String get preferencesFamilyOpenToChildren => 'Terbuka soal anak';

  @override
  String get preferencesFamilyAny => 'Semua';

  @override
  String get preferencesReligionLabel => 'Agama';

  @override
  String get preferencesReligionAny => 'Semua';

  @override
  String get preferencesEducationLabel => 'Pendidikan';

  @override
  String get preferencesSubmit => 'Simpan Preferensi';

  @override
  String get previewTitle => 'Hampir selesai!';

  @override
  String get previewSubtitle => 'Cek dulu profilmu sebelum lanjut.';

  @override
  String previewNameAge(String nickName, int age) {
    return '$nickName, $age';
  }

  @override
  String get previewSubmit => 'Sudah Sip';

  @override
  String get previewSubmitError =>
      'Ada masalah saat menyimpan profilmu. Coba lagi.';
}
