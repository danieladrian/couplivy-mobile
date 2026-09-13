import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/app_colors.dart';

/// Modal loading overlay — dipakai saat submit final onboarding
/// (`PreviewStepScreen`). Barrier ungu tua semi-transparan (`deepViolet`),
/// isi 2 heart icon putih yang saling mendekat dari sisi berlawanan lalu
/// "nempel" jadi 1 di tengah (kesan "matching" 2 orang), loop terus
/// selama loading berlangsung.
///
/// Pakai lewat helper static `show()`/`hide()` — TIDAK ada dependency
/// baru (lottie/rive), animasinya murni `AnimationController` + `Tween`
/// bawaan Flutter, konsisten dengan project yang cuma pakai
/// `phosphor_flutter` untuk semua icon.
class MatchingLoadingOverlay {
  MatchingLoadingOverlay._();

  /// Tampilkan modal, non-dismissible (barrier tap TIDAK menutup —
  /// loading harus selesai/dibatalkan lewat kode, bukan user).
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.deepViolet.withValues(alpha: 0.85),
      builder: (context) => const _MatchingHeartsAnimation(),
    );
  }

  /// Tutup modal — dipanggil setelah request selesai (sukses ATAU
  /// gagal), supaya modal tidak macet menutupi error message.
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

class _MatchingHeartsAnimation extends StatefulWidget {
  const _MatchingHeartsAnimation();

  @override
  State<_MatchingHeartsAnimation> createState() =>
      _MatchingHeartsAnimationState();
}

class _MatchingHeartsAnimationState extends State<_MatchingHeartsAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Jarak heart dari titik tengah. 0.0 = nempel jadi 1 (fase "matched"),
  // 1.0 = paling jauh terpisah (fase awal siklus).
  late final Animation<double> _separation;

  // Sedikit membesar sesaat pas ketemu di tengah — kesan "spark"/nempel,
  // bukan cuma berhenti diam.
  late final Animation<double> _matchScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _separation = TweenSequence<double>([
      // Mendekat dari terpisah -> nempel.
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55,
      ),
      // Tahan sebentar saat nempel (fase "matched").
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
      // Balik menjauh lagi buat mulai siklus berikutnya.
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(_controller);

    _matchScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 55),
      // Flash membesar tepat saat 2 heart baru nempel.
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.25,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 6,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.25,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 14,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Non-dismissible — hardware back TIDAK menutup modal ini,
      // konsisten dengan `barrierDismissible: false`.
      canPop: false,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Jarak maks tiap heart dari pusat, dalam px.
            const maxOffset = 22.0;
            final offset = _separation.value * maxOffset;
            final scale = _matchScale.value;

            return SizedBox(
              width: 120,
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(-offset, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: Icon(
                        PhosphorIcons.heart(PhosphorIconsStyle.fill),
                        size: 40,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(offset, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: Icon(
                        PhosphorIcons.heart(PhosphorIconsStyle.fill),
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
