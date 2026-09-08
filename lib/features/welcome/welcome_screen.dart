import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../shared/widgets/app_button.dart';

/// Welcome — halaman gateway sebelum sign up/log in. Sumber:
/// couplivy-docs/flow/00-auth/02-welcome.html.
///
/// VERSI SAAT INI: minimal — foto full-background (parallax mengikuti
/// kemiringan device via accelerometer) + logo + tagline, TANPA headline/
/// subtitle/pillar (dihapus atas permintaan eksplisit).
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  /// Offset parallax saat ini (sudah di-smooth), -1..1 tiap sumbu.
  double _tiltX = 0;
  double _tiltY = 0;

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  /// "Tekan sekali lagi untuk keluar" — Welcome adalah root screen (tidak
  /// ada halaman sebelumnya untuk di-pop), jadi back sekali harus tidak
  /// langsung keluar app supaya tidak ketutup tanpa sengaja.
  bool _readyToExit = false;
  Timer? _exitResetTimer;

  @override
  void initState() {
    super.initState();
    // accelerometerEventStream (BUKAN gyroscopeEventStream) — nilainya
    // langsung proporsional ke sudut kemiringan device relatif gravitasi,
    // tidak drift seperti integrasi gyroscope mentah.
    _accelerometerSubscription = accelerometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(_onAccelerometerEvent);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    // x: miring kiri/kanan (~-9.8..9.8), y: miring depan/belakang.
    // Clamp ke rentang wajar orang pegang HP (jarang sampai flat 90°),
    // lalu normalisasi ke -1..1.
    final normalizedX = (event.x / 6).clamp(-1.0, 1.0);
    final normalizedY = (event.y / 6).clamp(-1.0, 1.0);

    setState(() {
      // Exponential smoothing — halus, tidak "jitter" ikut getaran kecil.
      _tiltX = _tiltX + (normalizedX - _tiltX) * 0.15;
      _tiltY = _tiltY + (normalizedY - _tiltY) * 0.15;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _exitResetTimer?.cancel();
    super.dispose();
  }

  void _handleBackAttempt() {
    if (_readyToExit) {
      // Tap kedua dalam batas waktu — beneran keluar app.
      SystemNavigator.pop();
      return;
    }

    setState(() => _readyToExit = true);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).welcomeTapBackAgainToExit),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    _exitResetTimer?.cancel();
    _exitResetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _readyToExit = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      // Welcome adalah root screen — jangan biarkan pop pertama langsung
      // keluar app, harus tap 2x dalam 2 detik.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackAttempt();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              // Foto diperbesar (scale tetap 1.1) supaya ada "ruang" buat
              // digeser tanpa nyisain tepi kosong — offset digeser proporsi
              // kemiringan device (parallax).
              offset: Offset(-_tiltX * 14, -_tiltY * 10),
              child: Transform.scale(
                scale: 1.1,
                child: Image.asset(
                  'assets/images/welcome_hero_4.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Overlay gelap tipis supaya logo putih & tombol tetap kebaca
            // jelas di atas foto (bukan cuma dekorasi kosong).
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                  stops: const [0, 0.4, 1],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'app-logo',
                            child: Image.asset(
                              'assets/icons/app_icon_with_title_vertical.png',
                              width: 180,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Hero(
                            tag: 'app-tagline',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                l10n.splashTagline,
                                style: const TextStyle(
                                  color: Colors.white,
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
                    const Spacer(),
                    AppButton(
                      label: l10n.welcomeGetStarted,
                      // push (BUKAN go) — supaya ada history untuk di-pop
                      // balik ke Welcome via tombol back/header, alih-alih
                      // keluar app (go() replace lokasi, tidak nyisain
                      // stack).
                      onPressed: () => context.push('/signup'),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: l10n.welcomeLogIn,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => context.push('/login'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
