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
}
