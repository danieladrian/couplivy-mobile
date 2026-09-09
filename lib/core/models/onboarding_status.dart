import '../../features/onboarding/discover/discover_onboarding_draft_storage.dart';

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
  /// Step 1-8 (DOB, Gender, dst — step "Name" DIHAPUS karena nickname
  /// sekarang diisi saat Sign Up) disimpan LOKAL di device
  /// (SharedPreferences) — SERVER TIDAK TAHU user sudah sampai step
  /// berapa di tengah pengisian, cuma tahu 3 kondisi: belum mulai
  /// (`mode == null`), sudah pilih Gateway Choice tapi belum submit
  /// profil lengkap (`current_step == 'gateway_choice'`,
  /// `completed == false`), atau sudah selesai (`completed == true`).
  ///
  /// Kondisi kedua dulunya SELALU ke `/onboarding/discover/dob` (step 1)
  /// biar sederhana, tapi user melapor itu bikin bingung — sudah sampai
  /// step 3 (Photos), keluar app, masuk lagi malah balik ke step 1 lagi
  /// (meski isian step 1-2 tetap ke-preserve dan tinggal skip cepat).
  /// Sekarang resume LANGSUNG ke step pertama yang belum terisi di draft
  /// lokal — lihat [DiscoverOnboardingDraftStorage.resolveNextStepRoute].
  ///
  /// Async karena draft ada di SharedPreferences (device yang sama tempat
  /// draft dibuat — server tidak tahu progress step 1-8, lihat
  /// .ai/rules/architecture.md backend).
  Future<String> resolveResumeRoute() async {
    if (completed) return '/discover';
    if (mode != 'discover') return '/gateway-choice';

    return DiscoverOnboardingDraftStorage.resolveNextStepRoute();
  }
}
