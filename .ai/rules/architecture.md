# Arsitektur — Couplivy Mobile

## Struktur Folder — Feature-First

```
lib/
├── main.dart            ← bootstrap only, jangan taruh logic di sini
├── app/
│   ├── app.dart          ← root widget (MaterialApp.router, theme, l10n)
│   └── router.dart       ← go_router, semua GoRoute didaftarkan di sini
├── core/                 ← shared lintas fitur
│   ├── theme/            ← token warna/radius brand (AppColors, AppRadius)
│   ├── api/              ← HTTP client ke backend Laravel
│   └── storage/          ← local storage (token auth, dst)
├── features/             ← 1 folder per fitur/halaman
│   └── splash/
│       └── splash_screen.dart
└── l10n/
    ├── app_en.arb        ← template/fallback — SUMBER key i18n
    ├── app_id.arb
    └── generated/        ← hasil `flutter gen-l10n`, jangan edit manual
```

Tiap fitur baru = folder baru di `features/`, isinya widget+provider miliknya
sendiri. Jangan taruh screen di `core/` atau sebaliknya.

## Assets — Gambar (assets/images/)

- Semua asset gambar (bukan icon app) didaftarkan sebagai folder
  `assets/images/` di `pubspec.yaml` (bukan file satu-satu) — cukup taruh
  file baru di folder itu.

## Welcome Screen — Parallax Berbasis Sensor

- Background 1 foto statis (`assets/images/welcome_hero_4.png`), TANPA
  headline/subtitle/pillar (dihapus atas permintaan — kalau mau
  dikembalikan, lihat git history sebelum commit yang menghapus
  `_welcome_hero.dart`/`_welcome_pillar.dart` dan string `welcomeHeadline*`/
  `welcomeSubtitle`/`welcomePillar*` di ARB).
- Parallax pakai `sensors_plus` — `accelerometerEventStream()`, BUKAN
  `gyroscopeEventStream()`. Accelerometer baca sudut kemiringan device
  relatif gravitasi secara langsung (tidak drift); gyroscope baca
  KECEPATAN rotasi, perlu diintegrasi manual dan bisa drift kalau dipakai
  untuk baca posisi/sudut. Nilai di-smooth (exponential smoothing) supaya
  tidak "jitter" ikut getaran kecil tangan.
- Foto di-scale 1.1x tetap (statis) supaya ada ruang overscan untuk
  translate tanpa nyisain tepi kosong saat digeser ikut tilt device.

## Routing — Push vs Go, Back Selalu Eksplisit, Router Bukan Singleton

- `context.push('/path')` (nambah ke history stack, bisa di-`pop()` balik)
  vs `context.go('/path')` (RESET SELURUH stack ke path itu — bukan cuma
  replace 1 level, common misconception). `go()` yang dipanggil dari route
  yang sudah di-`push` (bukan root) akan menghapus SEMUA history di
  bawahnya juga, bukan cuma level sebelumnya — pernah jadi bug nyata:
  Welcome --push--> SignUp --go('/login')--> stack jadi `[Login]` doang
  (Welcome ikut hilang), back dari Login pun langsung keluar app.
- Pola final yang dipakai sekarang (Welcome/SignUp/Login):
  - Welcome -> SignUp, Welcome -> Login: `push` (ada history untuk back).
  - Footer link SignUp <-> Login: `push` juga (BUKAN go — supaya stack di
    bawahnya, termasuk Welcome, tidak ikut ke-reset).
  - Tombol back (header ATAU hardware, lewat `PopScope`) di SignUp & Login:
    SELALU `context.go('/welcome')` eksplisit, TIDAK PERNAH `context.pop()`.
    History stack ke SignUp/Login bisa datang dari jalur berbeda-beda
    (langsung dari Welcome, atau dari Login/SignUp lain via footer link),
    jadi `pop()` tidak reliable memprediksi ke mana ujungnya — `go()`
    eksplisit ke tujuan yang pasti jauh lebih aman daripada mengandalkan
    urutan push yang bisa berubah kombinasi.
- Welcome adalah root screen (tidak ada halaman sebelumnya) — pakai
  `PopScope(canPop: false, onPopInvokedWithResult: ...)` untuk pola "tekan
  sekali lagi untuk keluar" (`SystemNavigator.pop()` di tap kedua dalam
  jendela waktu, `Timer` reset state kalau timeout). Jangan biarkan back
  pertama di root screen langsung keluar app.
- `GoRouter` HARUS dibuat lewat function (`createAppRouter()`), BUKAN
  `final appRouter = GoRouter(...)` singleton top-level — singleton bikin
  history/lokasi router bocor antar `pumpWidget()` di widget test (test
  berikutnya mewarisi state navigasi dari test sebelumnya, false
  positive/negative yang membingungkan). `CouplivyApp` (StatefulWidget)
  bikin instance baru tiap kali di-construct via `late final _router =
  createAppRouter()`.

## Auth — API Layer & Shared Widgets

- `core/api/api_client.dart` — Dio instance tunggal (`CouplivyApiClient.instance`),
  interceptor otomatis attach `Authorization: Bearer <token>` dari
  `TokenStorage`. Base URL diarahkan ke domain production
  (`couplivy.kriukgo.id`) — override lewat `--dart-define=API_BASE_URL=...`
  untuk dev lokal.
- `core/storage/token_storage.dart` — token Sanctum di `flutter_secure_storage`
  (Keychain/Keystore), BUKAN SharedPreferences.
- `core/api/api_exception.dart` — error Laravel (422 validation, dst)
  di-parse jadi `ApiException` dengan `errorFor(field)` untuk tampilkan
  error per-field di form.
- `features/auth/` — `AuthRepository` (HTTP layer, panggil `/auth/*`),
  `providers/auth_form_controller.dart` (state loading/error via Riverpod
  `Notifier`, 1 provider per screen dengan `.autoDispose`).
- Widget form auth reusable ada di `shared/widgets/`, BUKAN duplikat per
  screen: `AuthScreenHeader`, `LabeledDivider`, `AuthFooterLink`,
  `PhoneNumberField` (dengan country code picker — TIDAK hardcode +62,
  app multi-negara), `OAuthButton` (Apple/Google — belum fungsional,
  menunggu kredensial `GOOGLE_CLIENT_ID`/`APPLE_*` diisi di backend).
- `PhoneNumberField`: default country code ikut BAHASA device (bukan
  region/GPS/IP) — `id` -> ID (+62), selain itu -> US (+1). Sinkron pakai
  `onInit` bawaan `CountryCodePicker` supaya dial code yang disimpan
  parent selalu sesuai yang ditampilkan walau user tidak sentuh dropdown.
  PENTING: `onInit` dipanggil dari `didChangeDependencies` SAAT widget itu
  sendiri pertama kali di-build — memanggil `setState()` parent langsung
  dari situ akan error "setState() called during build". Wajib bungkus
  dengan `WidgetsBinding.instance.addPostFrameCallback(...)`. Pola yang
  sama berlaku untuk callback child widget lain yang bisa terpicu selama
  fase build induknya.
- Sign Up mewajibkan email DAN nomor HP sekaligus — nomor HP digabung jadi
  format E.164 di Flutter (`$dialCode$nomorLokal`) sebelum dikirim, backend
  validasi format itu (lihat `RegisterRequest` di couplivy-backend).

## Routing — URL Path = ID Halaman

- Pakai `go_router`. Path tiap `GoRoute` adalah identitas permanen halaman
  itu (dipakai juga sebagai basis deep link) — hindari mengubah path yang
  sudah dipakai, kalau perlu ganti nama, tambah redirect.
- Semua route didaftarkan di `lib/app/router.dart`, tidak tersebar.

## State Management — Riverpod

- `flutter_riverpod`, provider ditaruh di folder fitur masing-masing
  (`features/<nama>/providers/`) kecuali dipakai lintas fitur → taruh di
  `core/`.

## i18n

- Bahasa default ikut locale HP, fallback ke English — ditangani otomatis
  oleh `AppLocalizations.supportedLocales` + `MaterialApp.router`, tidak
  perlu logic manual tambahan untuk deteksi awal.
- String UI baru: tambah key di `lib/l10n/app_en.arb` (template) DULU, baru
  tambah terjemahan yang sama di `app_id.arb` dan bahasa lain. Jalankan
  `flutter gen-l10n` setelah edit ARB.
- String UI statis SELALU lewat `AppLocalizations`, jangan hardcode teks
  Indonesia/Inggris langsung di widget.
- Locale preferensi user yang tersimpan di server (`users.locale` di
  Laravel) dikirim saat login/register dan saat user ganti bahasa manual di
  Settings — dipakai backend untuk notifikasi/email, BUKAN untuk render UI
  (itu tugas locale aktif di HP/state lokal).

## Splash Screen

- Native splash (`flutter_native_splash.yaml`) tampil instant menutup jeda
  loading engine → lanjut ke route `/` (`SplashScreen` widget Flutter) yang
  menjalankan logic startup (cek token, locale, dst) sebelum navigasi ke
  halaman berikutnya.
- Config native splash & launcher icon ada di root (`flutter_native_splash.yaml`,
  `flutter_launcher_icons.yaml`). Jalankan ulang generator-nya
  (`dart run flutter_native_splash:create` / `dart run flutter_launcher_icons`)
  tiap kali source icon di `assets/icons/app_icon.png` berubah.
- Logic redirect (delay minimum 1.5s + baca token + `GET /onboarding/status`
  kalau ada token) ada di `SplashScreen._resolveDestination()` — 3 tujuan:
  tidak ada token -> `/welcome`; ada token tapi onboarding belum selesai ->
  `/gateway-choice`; onboarding selesai -> `/discover`. Kegagalan apapun
  (secure storage, network) di-`try/catch` dan fallback ke `/welcome` — user
  tetap bisa lanjut manual lewat Login.
- **PENTING — widget test & `flutter_secure_storage`:** di widget test
  (`testWidgets`), `FlutterSecureStorage().read()` TIDAK melempar exception
  seperti di `test()` biasa (yang dapat `MissingPluginException` instan) —
  Future-nya malah tidak pernah resolve/reject SAMA SEKALI (macet permanen,
  tidak ada `pump()` sebanyak apa pun yang menyelesaikannya). Root cause:
  tidak ada mock method channel untuk `plugins.it_nomads.com/flutter_secure_storage`
  di test environment. WAJIB mock channel itu di `setUp()` (balikin `null`
  untuk method `read`, dst) di setiap test file yang memuat `CouplivyApp`/
  `SplashScreen` — lihat `test/widget_test.dart`. Tanpa mock ini, SplashScreen
  akan macet selamanya di layar splash saat widget test.

## Onboarding — Gateway Choice (Step 1)

- Sumber: couplivy-docs/flow/00-auth/05-gateway-choice.html. Muncul SEKALI
  setelah Sign Up/Login pertama kali (bukan tiap login) — pencabangan antara
  "Mencari koneksi baru" (mode=`discover`) vs "Sudah punya pasangan"
  (mode=`together`).
- **`mode=together` DI-DISABLE dulu** — backend (`GatewayChoiceRequest`)
  menolak mode itu (422), fitur pairing belum ada. `GatewayOptionCard` kedua
  di `GatewayChoiceScreen` ditampilkan non-aktif (`enabled: false`), BUKAN
  disembunyikan — supaya user tahu fitur itu akan ada.
- `features/onboarding/onboarding_repository.dart` — `GET /onboarding/status`
  dan `POST /onboarding/gateway-choice`, pola sama `AuthRepository`.
  `core/models/onboarding_status.dart` — model `{completed, currentStep,
  mode}`, manual (bukan freezed), sama pola `User`.
- `AuthResult` (hasil register/login) SEKARANG bawa `onboarding` juga —
  backend menyertakan status onboarding di response `/auth/*` yang sama
  (lihat `AuthService::issueToken()` backend) supaya SignUp/Login tidak perlu
  API call terpisah tepat setelah auth sukses untuk tahu ke mana redirect.
  `AuthFormState.AuthFormSuccess` juga bawa `onboarding` untuk alasan sama.
- Redirect setelah auth sukses:
  - Sign Up sukses -> SELALU `/gateway-choice` (user baru pasti belum
    onboard, tidak perlu cek `completed`).
  - Login sukses -> `/gateway-choice` kalau `!onboarding.completed`, else
    `/discover`.
  - Splash (device baru/reinstall lalu buka app dengan token tersimpan) ->
    sama seperti Login, tapi lewat `GET /onboarding/status` (lihat bagian
    Splash Screen di atas).
- `GatewayOptionCard` (di `shared/widgets/`, bukan `features/onboarding/`
  karena pola "pilih 1 dari beberapa kartu besar" berpotensi dipakai ulang
  di step onboarding lain) dan `DiscoverPlaceholderScreen`
  (`features/discover/`) — placeholder sementara, Discover (feed utama)
  belum dibangun; jadi titik akhir alur onboarding/login supaya bisa
  diverifikasi end-to-end tanpa nyangkut di halaman yang belum ada.

## Safe Area — Notch, Punch-Hole, Status Bar, Gesture Nav

- SEMUA halaman dengan konten interaktif (form, tombol, teks penting dekat
  tepi layar) WAJIB dibungkus `SafeArea` — HP modern punya notch/punch-hole
  kamera depan (memotong area atas) dan gesture navigation bar (memotong
  area bawah), variasinya beda-beda tiap device (lihat device test kita:
  Samsung SM-A736B punya punch-hole).
- Pengecualian: `SplashScreen` SENGAJA tidak pakai `SafeArea` — kontennya
  di-`Center()` dan background gradient boleh full-bleed sampai tepi layar,
  tidak ada elemen yang berisiko tertutup notch/punch-hole.
- Pola: `Scaffold(body: SafeArea(child: ...))` — lihat
  `features/welcome/welcome_screen.dart` sebagai contoh referensi.
- Untuk form (Login/Sign Up, dst) yang juga butuh scroll saat keyboard
  muncul: `SafeArea` + `SingleChildScrollView`, JANGAN cuma andalkan
  `resizeToAvoidBottomInset` bawaan Scaffold tanpaScrollView — supaya field
  paling bawah tidak ketutup keyboard.

## Copywriting — Produk Dual-Mode (Discover + Together)

- Couplivy melayani DUA audiens: yang masih mencari pasangan (Discover mode)
  DAN yang sudah berpasangan/menikah dan ingin menumbuhkan hubungan mereka
  (Together mode) — lihat couplivy-docs/flow/map.html untuk konsep mode.
- Copy marketing/onboarding sebelum titik pencabangan eksplisit (Gateway
  Choice — "Kamu di Couplivy untuk apa?", couplivy-docs/flow/00-auth/
  05-gateway-choice.html) WAJIB netral untuk kedua audiens. Hindari kata
  yang menyiratkan "masih single/mencari" seperti "find someone",
  "meet people" — pakai framing yang berlaku untuk keduanya (contoh:
  "grows with you", bukan "helps you find").
- Ini SENGAJA menyimpang dari copy asli di prototype
  couplivy-docs/flow/00-auth/02-welcome.html (yang single-audience,
  "Find someone worth growing with") — prototype adalah referensi UI/layout,
  bukan copy final yang mengikat.
- Tagline resmi netral yang aman dipakai di mana saja: "Made for Meaningful
  Love" (splash) dan "Tumbuh. Hangat. Bermakna." (pilar brand).

## App Icon — Adaptive Icon Android

- Source `assets/icons/app_icon.png` (update ketiga, 2000x2000) SUDAH punya
  safe-zone padding — logo ~42-50% dari kanvas, masih di bawah batas aman
  ~66% rekomendasi Google. Adaptive icon Android SUDAH diaktifkan di
  `flutter_launcher_icons.yaml` (`adaptive_icon_background: "#6D5BA6"`,
  `adaptive_icon_foreground`). Kalau logo diperbesar lagi ke depan dan
  mendekati/lewat 66%, cek ulang sebelum asumsikan masih aman.
- Versi PERTAMA icon ini (sebelum update) full-bleed tanpa padding — waktu
  itu adaptive icon sengaja di-skip untuk hindari logo terpotong saat
  di-mask launcher jadi lingkaran/rounded-square. Kalau source diganti lagi
  ke depan, cek dulu proporsi logo:vs-kanvas sebelum asumsikan adaptive icon
  masih aman.
- Setelah ganti `assets/icons/app_icon.png`, WAJIB jalankan ulang:
  `dart run flutter_launcher_icons` DAN `dart run flutter_native_splash:create`
  (splash juga pakai source yang sama).
