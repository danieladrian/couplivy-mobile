import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'onboarding_step_header.dart';

/// Kerangka umum SEMUA step onboarding Discover — `OnboardingStepHeader`
/// di atas, konten scrollable di tengah, tombol utama (biasanya
/// "Continue") DI-PIN ke bawah layar (di LUAR area scroll), bukan ikut
/// scroll bersama konten seperti sebelumnya.
///
/// Sebelum widget ini ada, `AppButton` diletakkan sebagai child terakhir
/// `Column` di DALAM `SingleChildScrollView` — kalau konten pendek,
/// tombol menempel tepat di bawah konten (posisinya naik-turun
/// tergantung tinggi konten); kalau konten panjang/keyboard terbuka,
/// tombol ikut ter-scroll ke bawah dan bisa tidak terlihat tanpa scroll
/// manual dulu. User minta tombol SELALU terlihat di posisi tetap di
/// bawah layar, terlepas dari panjang konten.
///
/// `bottomButton` OPSIONAL — step yang polanya "tap kartu langsung
/// lanjut" (kalau ada) tetap bisa pakai widget ini tanpa tombol.
class OnboardingStepScaffold extends StatelessWidget {
  const OnboardingStepScaffold({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.body,
    this.bottomButton,
    this.errorText,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onBack;

  /// Konten scrollable — TANPA padding sendiri, `OnboardingStepScaffold`
  /// yang menerapkan padding standar (24 kiri-kanan, 16 atas, 24 bawah
  /// KALAU tidak ada `bottomButton`/`errorText` — kalau ada, bottom
  /// padding konten dikecilkan karena area tombol sudah punya padding
  /// sendiri).
  final Widget body;

  /// Tombol utama (biasanya `AppButton` dengan label Continue) — DI-PIN
  /// di bawah layar, di luar area scroll. null kalau step ini tidak
  /// punya tombol (pola "tap kartu langsung lanjut").
  final Widget? bottomButton;

  /// Pesan error validasi (mis. "Please fill in all fields to
  /// continue.") — ditampilkan tepat DI ATAS `bottomButton`, di luar
  /// area scroll juga, supaya selalu terlihat bersama tombolnya tanpa
  /// perlu scroll ke bawah dulu.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingStepHeader(
              step: step,
              totalSteps: totalSteps,
              onBack: onBack,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: body,
              ),
            ),
            if (bottomButton != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (errorText != null) ...[
                      Text(
                        errorText!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    bottomButton!,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
