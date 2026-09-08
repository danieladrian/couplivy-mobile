# Dependencies — Version Pinning

## SDK Terpasang di Environment Ini

- Flutter `3.38.0` (channel non-standar, `unknown source`), Dart
  `3.10.0-290.4.beta`.
- Beberapa package di `pubspec.yaml` SENGAJA bukan versi terbaru pub.dev,
  karena versi terbarunya butuh Dart/Flutter SDK lebih baru dari yang
  terpasang di sini:
  - `flutter_riverpod: ^3.3.0` (bukan 3.4.x — butuh Dart `^3.12.0`)
  - `go_router: ^17.2.0` (bukan 18.x — butuh Dart `^3.10.0` stabil, environment
    ini masih beta di bawah itu)
  - `flutter_native_splash: ^2.4.7` (bukan 2.4.8 — versi itu butuh `meta
    ^1.18.0`, sedangkan `flutter_test` dari Flutter SDK ini masih pin `meta
    1.17.0`)
  - `intl: ^0.20.2` (persis, bukan range lebih tinggi — di-pin ketat oleh
    `flutter_localizations` dari Flutter SDK ini)
  - `google_fonts: ^8.1.0` (bukan 8.2.x — butuh Dart `^3.10.0` stabil, sama
    kasus dengan go_router di atas)
  - `flutter_secure_storage: ^10.3.1` (bukan 11.x — dependency transitif
    `win32 ^6.0.1` butuh Dart `^3.10.0` stabil)

## Kalau Flutter SDK di-upgrade

Setelah upgrade Flutter/Dart SDK, jalankan `flutter pub outdated` dan coba
naikkan lagi versi-versi di atas — constraint ini murni akibat SDK lama, bukan
keputusan desain yang harus dipertahankan selamanya.
