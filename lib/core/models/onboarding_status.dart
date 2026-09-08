/// Status onboarding user — dikembalikan backend baik lewat
/// `{user, token, onboarding}` di response `/auth/*` maupun langsung dari
/// `GET /onboarding/status`. Dipakai Splash/SignUp/Login untuk menentukan
/// halaman tujuan redirect tanpa menebak-nebak dari state lokal.
class OnboardingStatus {
  const OnboardingStatus({
    required this.completed,
    required this.currentStep,
    required this.mode,
  });

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) {
    return OnboardingStatus(
      completed: json['completed'] as bool,
      currentStep: json['current_step'] as String?,
      mode: json['mode'] as String?,
    );
  }

  final bool completed;
  final String? currentStep;
  final String? mode;

  /// Route tujuan berdasarkan status ini — dipakai Splash/Login. Terpusat
  /// di sini (bukan diduplikasi di tiap pemanggil) supaya nambah step
  /// baru cuma 1 tempat yang perlu diubah.
  ///
  /// Step 2-9 (DOB, Gender, dst — belum ada satupun yang dibuat, step
  /// "Name" DIHAPUS karena nickname sekarang diisi saat Sign Up) disimpan
  /// LOKAL di device (SharedPreferences) — SERVER TIDAK TAHU user sudah
  /// sampai step berapa di tengah pengisian, cuma tahu 3 kondisi: belum
  /// mulai (`mode == null`), sudah pilih Gateway Choice tapi belum submit
  /// profil lengkap (`current_step == 'gateway_choice'`,
  /// `completed == false`), atau sudah selesai (`completed == true`).
  ///
  /// TODO: kondisi kedua sekarang fallback ke `/discover` (placeholder)
  /// karena step 1 pengisian profil (DOB) belum dibuat — ganti jadi
  /// `/onboarding/discover/dob` (atau step pertama yang aktual) begitu
  /// halamannya ada.
  String get resumeRoute {
    if (completed) return '/discover';
    if (mode != 'discover') return '/gateway-choice';

    return '/discover';
  }
}
