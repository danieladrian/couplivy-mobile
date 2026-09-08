import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Background splash dengan efek "water" — beberapa blob radial-gradient
/// yang bergerak & membesar-mengecil secara independen, di-blur supaya
/// saling berbaur seperti cairan mengalir. Base warna tetap gelap
/// (deepViolet → darkViolet, §2.1 brand-guideline) supaya kesan tetap
/// premium/elegant, bukan playful.
class WaterGradientBackground extends StatefulWidget {
  const WaterGradientBackground({super.key, this.child});

  final Widget? child;

  @override
  State<WaterGradientBackground> createState() =>
      _WaterGradientBackgroundState();
}

class _WaterGradientBackgroundState extends State<WaterGradientBackground>
    with SingleTickerProviderStateMixin {
  /// Deep violet yang digelapkan — khusus splash, bukan token inti §1.1,
  /// jadi tidak masuk AppColors (lihat splash_screen.dart untuk konteks).
  static const _darkViolet = Color(0xFF3A3155);

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.deepViolet, _darkViolet],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: _WaterBlobPainter(t: _controller.value),
              );
            },
          ),
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _WaterBlobPainter extends CustomPainter {
  _WaterBlobPainter({required this.t});

  final double t;

  static const _blobs = [
    _Blob(color: AppColors.dustyBlue, speed: 1, phase: 0, radiusFactor: 0.55),
    _Blob(
      color: AppColors.deepViolet,
      speed: 1.4,
      phase: math.pi * 0.66,
      radiusFactor: 0.48,
    ),
    _Blob(
      color: Color(0xFF3A3155),
      speed: 0.8,
      phase: math.pi * 1.3,
      radiusFactor: 0.6,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    for (final blob in _blobs) {
      final angle = t * 2 * math.pi * blob.speed + blob.phase;

      // Tiap blob mengorbit pelan di sekitar area berbeda layar, dengan
      // sedikit lissajous (beda frekuensi x/y) supaya lintasannya organik,
      // bukan lingkaran sempurna yang terasa mekanis.
      final cx = size.width * (0.5 + 0.32 * math.cos(angle));
      final cy = size.height * (0.5 + 0.32 * math.sin(angle * 1.3));
      final radius = size.longestSide * blob.radiusFactor;

      final paint = Paint()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80)
        ..shader = RadialGradient(
          colors: [
            blob.color.withValues(alpha: 0.85),
            blob.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius));

      canvas.drawCircle(Offset(cx, cy), radius, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WaterBlobPainter oldDelegate) =>
      oldDelegate.t != t;
}

class _Blob {
  const _Blob({
    required this.color,
    required this.speed,
    required this.phase,
    required this.radiusFactor,
  });

  final Color color;

  /// Kecepatan orbit relatif — blob beda speed supaya pola tidak berulang
  /// serempak (kesan lebih organik/cair).
  final double speed;
  final double phase;
  final double radiusFactor;
}
