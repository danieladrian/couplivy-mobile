import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/token_storage.dart';
import '../../l10n/generated/app_localizations.dart';
import '../onboarding/onboarding_repository.dart';
import '_water_gradient_background.dart';

/// Splash Flutter — muncul SETELAH native splash (lihat
/// flutter_native_splash.yaml) selesai menutup jeda loading engine.
///
/// Auto-advance setelah ±1.5 detik (sesuai catatan prototype,
/// couplivy-docs/flow/00-auth/01-splash.html) ke salah satu dari 3 tempat:
/// - Tidak ada token tersimpan -> /welcome (belum pernah login).
/// - Ada token, tapi onboarding belum selesai -> step yang BELUM
///   diselesaikan (lihat OnboardingStatus.resumeRoute — BUKAN selalu ke
///   Gateway Choice dari awal). Ini yang menangani kasus uninstall+install
///   ulang lalu login, atau app ditutup di tengah onboarding lalu dibuka
///   lagi.
/// - Ada token, onboarding sudah selesai -> /discover.
///
/// Kalau panggilan status onboarding gagal (network error dst), fallback
/// ke /welcome — user tetap bisa lanjut manual lewat Login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _resolveDestination();
  }

  Future<void> _resolveDestination() async {
    // Delay minimum splash tetap dijalankan penuh (bukan cuma "paling
    // cepat 1.5s") supaya logo tidak kedip kalau network-nya cepat.
    final minSplashDelay = Future.delayed(const Duration(milliseconds: 1500));

    // Baca token maupun panggil status onboarding sama-sama boleh gagal
    // (secure storage tidak tersedia, network error, dst) — fallback aman
    // selalu /welcome, user tetap bisa lanjut manual lewat Login.
    var destination = '/welcome';
    try {
      final token = await TokenStorage.readToken();
      if (token != null) {
        final onboarding = await onboardingRepository.status();
        destination = onboarding.resumeRoute;
      }
    } catch (_) {
      destination = '/welcome';
    }

    await minSplashDelay;
    if (mounted) context.go(destination);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: WaterGradientBackground(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'app-logo',
                child: Image.asset(
                  'assets/icons/app_icon_with_title_vertical.png',
                  width: 200,
                ),
              ),
              const SizedBox(height: 16),
              Hero(
                tag: 'app-tagline',
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    l10n.splashTagline,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11.5,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
