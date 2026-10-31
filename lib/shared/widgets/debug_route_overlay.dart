import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Badge kecil di pojok kiri atas menampilkan path route AKTIF — alat
/// bantu development supaya tahu sedang di halaman/route mana tanpa
/// perlu baca kode. HANYA tampil di debug mode (`kDebugMode`) — otomatis
/// hilang di `flutter build apk --release` tanpa perlu dicopot manual.
///
/// Dipasang lewat `MaterialApp.router(builder: ...)` di `app.dart` — jadi
/// muncul di SEMUA halaman otomatis (1 tempat, bukan ditempel manual di
/// tiap screen). `router` diterima LANGSUNG sebagai parameter (instance
/// `_router` yang sama dipakai `routerConfig:`), BUKAN `GoRouter.of(context)`
/// — `context` yang diterima `builder:` MaterialApp.router ada DI ATAS
/// `Router` widget (belum ada `GoRouter` di context pada level itu),
/// jadi `GoRouter.of(context)` lempar "No GoRouter found in context".
/// `AnimatedBuilder` dengar `router.routerDelegate` supaya re-render
/// tiap kali route berubah (navigasi `.go()`/`.push()` dkk).
///
/// Badge juga BISA DITAP — shortcut ke `/debug/profile-db` (dump mentah
/// isi database lokal profil), supaya tidak perlu nambah menu/tombol
/// terpisah lagi untuk keperluan debug semacam ini di masa depan.
class DebugRouteOverlay extends StatelessWidget {
  const DebugRouteOverlay({
    super.key,
    required this.router,
    required this.child,
  });

  final GoRouter router;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;

    return Stack(
      children: [
        child,
        AnimatedBuilder(
          animation: router.routerDelegate,
          builder: (context, _) {
            final path = router.routerDelegate.currentConfiguration.uri
                .toString();
            return Positioned(
              top: MediaQuery.of(context).padding.top + 4,
              left: 8,
              child: GestureDetector(
                onTap: () => router.push('/debug/profile-db'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    path,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
