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
- **PENTING — `PopScope(canPop: false)` di layar dengan TextField (Sign
  Up, Login):** hardware back Android SEHARUSNYA tutup keyboard dulu
  (kalau ada TextField fokus) sebelum benar-benar pindah halaman —
  behavior standar semua app Android. TAPI `PopScope(canPop: false)`
  intercept SEMUA pop request tanpa pandang bulu, termasuk yang harusnya
  cuma dismiss keyboard, jadi tanpa penanganan manual back PERTAMA
  langsung `context.go('/welcome')` walau user cuma mau tutup keyboard —
  ketemu nyata pas user coba isi form Login manual di device fisik (form
  ke-reset gara-gara balik ke Welcome). Fix: `_backToWelcome()` cek dulu
  ada `EditableText` di ancestor `FocusManager.instance.primaryFocus` —
  kalau ada, `unfocus()` saja (back pertama), baru back berikutnya benar2
  `context.go('/welcome')`. JANGAN cek `FocusScope.of(context).hasFocus`
  atau `primaryFocus?.context != null` — keduanya SELALU `true`/non-null
  walau tidak ada TextField yang fokus secara visual (false positive).
  Lihat `LoginScreen._backToWelcome()`/`SignUpScreen._backToWelcome()` dan
  test `'Back from Sign Up with keyboard open dismisses keyboard first...'`
  di `test/widget_test.dart`.

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
- Sign Up punya 2 field nama TERPISAH — **Full Name** (nama lengkap resmi)
  DAN **Nickname** (nama panggilan, WAJIB diisi di sini, BUKAN step
  onboarding terpisah — keputusan sebelumnya begitu, DIUBAH). Field ini
  urutannya Full Name dulu baru Nickname di bawahnya. `core/models/user.dart`
  (`User.fullName`/`User.nickName`) parse dari `full_name`/`nick_name` di
  response JSON (kolom `users.name` lama di backend sudah di-rename).
  Nickname dipakai personalisasi UI (mis. Gateway Choice: "Hello Daniel,
  ...") dan nanti nama tampilan di Discover.
- `core/storage/user_session_storage.dart` (`UserSessionStorage`) — cache
  `fullName`/`nickName` ke SharedPreferences begitu Sign Up/Login sukses
  (dipanggil dari `AuthRepository._post()`). Dibaca layar mana pun yang
  butuh personalisasi cepat (mis. `GatewayChoiceScreen`) TANPA API call
  tambahan atau nge-drag `User` lewat parameter route/provider lintas
  screen. BUKAN pengganti sumber kebenaran server — murni cache lokal.

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
- **Judul dipersonalisasi pakai nickname** ("Hello Daniel, ...") — baca
  dari `UserSessionStorage.readNickName()` di `initState`
  (`GatewayChoiceScreen` sekarang `ConsumerStatefulWidget`, BUKAN
  `ConsumerWidget` lagi). Fallback ke judul generik (`gatewayChoiceTitleFallback`)
  selama 1 frame sebelum SharedPreferences selesai dibaca — supaya tidak
  ada layout jump begitu nickname muncul.
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
  - Login sukses -> lewat `OnboardingStatus.resolveResumeRoute()` (lihat
    section di bawah).
  - Splash (device baru/reinstall lalu buka app dengan token tersimpan) ->
    sama seperti Login, tapi lewat `GET /onboarding/status` (lihat bagian
    Splash Screen di atas).
- `GatewayOptionCard` (di `shared/widgets/`, bukan `features/onboarding/`
  karena pola "pilih 1 dari beberapa kartu besar" berpotensi dipakai ulang
  di step onboarding lain) — pola "pilih 1 dari beberapa kartu besar"
  berpotensi dipakai ulang di step onboarding lain.
- **Gateway Choice pakai pola pilih+Continue** (SAMA seperti Gender/
  Relationship Goal, TIDAK LAGI beda) — `GatewayOptionCard` sekarang
  punya param `selected` (border+background lilac+checkmark, background
  putih normal kalau belum dipilih), tap kartu Discover cuma
  `setState()` (`_selectDiscover`), submit sesungguhnya
  (`gatewayChoiceProvider.notifier.choose('discover')`) baru terjadi
  saat tap tombol Continue terpisah di bawah (disabled sampai kartu
  Discover dipilih). Dulunya tap kartu LANGSUNG submit tanpa state
  selected sama sekali dan tanpa tombol Continue — diubah karena
  dianggap tidak konsisten dengan pola step lain. `_discoverSelected`
  cukup `bool` (bukan `String? _selectedMode`) karena cuma 1 opsi yang
  bisa dipilih (Together permanen `enabled: false`).
- **Background LAYAR Gateway Choice (bukan kartu) fade putih→cream saat
  Discover dipilih** — `Scaffold.body` dibungkus `AnimatedContainer`
  (duration 350ms, `Curves.easeInOut`), `color: _discoverSelected ?
  AppColors.cream : Colors.white`. Sebelumnya `Scaffold.backgroundColor`
  statis `AppColors.cream` sepanjang waktu — user secara eksplisit minta
  putih polos dulu, baru fade ke cream begitu kartu Discover ditap;
  efek ini KHUSUS kartu Discover, TIDAK relevan untuk Together (disabled
  permanen). Kartu `GatewayOptionCard` sendiri TIDAK ikut fade — warnanya
  tetap putih terus, cuma border+checkmark yang berubah saat selected
  (beda concern dari background layar).
- Route `/discover` (titik akhir alur onboarding/login) sekarang
  `MainNavigationScreen` (`features/main_nav/`) — container 3 tab
  (Discover, Connections, Profile) lewat `BottomNavigationBar` +
  `IndexedStack`, BUKAN 3 route URL terpisah (state tab lokal, bukan
  go_router nested route/`StatefulShellRoute`). Ketiga tab
  (`DiscoverPlaceholderScreen`, `ConnectionsScreen`, `ProfileScreen`)
  MASIH placeholder kosong — belum dibangun, cuma jadi kerangka
  navigasi supaya bottom nav bisa diverifikasi end-to-end.

## Onboarding — Step 1-11 Discover (DOB s.d. Preview) — SELESAI

- **Step "Name" (dulu step 2) DIHAPUS TOTAL** — nickname sekarang diisi
  saat Sign Up (lihat section Auth di atas), BUKAN step onboarding
  terpisah. Onboarding Discover sekarang **11 step, SEMUA SUDAH DIBUAT**:
  1 DOB, 2 Gender, 3 Photos, 4 Bio (+Detail Diri, TERMASUK Love
  Language), 5 Work/Education, 6 Interests (max 5), 7 Lifestyle (BARU),
  8 Future (BARU), 9 Relationship Goal, 10 Preferences, 11 Preview.
  `features/onboarding/discover/*_step_screen.dart` — 1 file per step.
  Lihat section "Onboarding — Step 7 (Lifestyle), Step 8 (Future), Love
  Language & Interests max 5" di bawah untuk detail 3 fitur BARU ini.
- Step 1-10 (spesifik jalur "Mencari koneksi baru") dipisah dari Gateway
  Choice (step 0 alur lama, sekarang gerbang sebelum step 1) — sama pola
  pemisahan di backend (`DiscoverOnboardingController`/`Service`, route
  `/api/onboarding/discover/*`, lihat `.ai/rules/architecture.md` backend).
- **BUKAN per-step ke API** — step 1-10 diisi & disimpan LOKAL di Flutter
  (`features/onboarding/discover/discover_onboarding_draft_storage.dart`,
  `DiscoverOnboardingDraftStorage` — SharedPreferences, 1 key per field,
  method baca/tulis per field DAN `readAllForSubmit()`/`clear()`), TIDAK
  ADA network call sampai step TERAKHIR (Preview, tombol "Let's Go",
  dulu "Looks Good"). Tiap screen baca draft-nya sendiri di `initState`
  (pre-fill kalau user balik ke step yang sama) dan
  `PopScope(canPop: false)` untuk hardware back (pola sama Login/SignUp
  — lihat bagian Routing).
- Selama submit (`_submit()` di Preview), `MatchingLoadingOverlay`
  (`shared/widgets/matching_loading_overlay.dart`) menampilkan modal
  full-screen non-dismissible — barrier `deepViolet` semi-transparan, 2
  heart icon Phosphor putih yang saling mendekat lalu "nempel" (loop,
  animasi murni `AnimationController`/`TweenSequence`, TIDAK ada
  dependency lottie/rive). Ditutup manual (`.hide(context)`) di jalur
  sukses MAUPUN error — WAJIB dipop SEBELUM `context.go('/main')`
  karena `go()` me-reset seluruh stack navigator (lihat bagian
  Routing); dialog yang belum ditutup saat stack di-reset berisiko
  nyangkut.
- **Step Preview memanggil DUA network call sekaligus** (beda bentuk
  request, `discover_onboarding_repository.dart`):
  - `complete(fields)` (JSON) — SEMUA field profil dari
    `readAllForSubmit()`.
  - `uploadPhotos(photoPaths)` (multipart, `Dio.FormData` +
    `MultipartFile.fromFile()`) — path LOKAL hasil copy kamera/galeri→temp
    dir di step Photos (`path_provider`), BUKAN path galeri/kamera asli
    (bisa hilang/berubah kapan saja). Tap slot kosong buka bottom sheet
    pilihan sumber (Kamera via `ImageSource.camera` — butuh
    `android.permission.CAMERA` + `NSCameraUsageDescription`; Galeri via
    `ImageSource.gallery` — Android 13+ pakai Photo Picker system, tidak
    butuh permission runtime).
  - 6 slot foto HARUS diisi BERURUTAN dari kiri-atas (index 0 = foto
    utama) — hanya slot kosong PERTAMA (`index == _photoPaths.length`)
    yang aktif (`onTap` non-null); slot kosong sesudahnya dibuat redup
    (`Opacity` 0.4) dan tidak bisa di-tap. User sempat melapor bingung
    waktu semua slot kosong bisa di-tap bebas: foto yang dipilih selalu
    "nempel" ke slot kosong paling awal (karena render `hasPhoto = index
    < _photoPaths.length`), bukan ke slot yang di-tap — kesannya foto
    "pindah sendiri".
  - **Bug kamera "Take a photo" silent-fail** — pernah terjadi di device
    Samsung One UI (Android 16): tap "Take a photo" menutup bottom sheet
    tanpa membuka kamera ATAU dialog permission, tanpa exception apa pun
    di log. Root cause: Android "Restricted Settings" — APK yang
    di-sideload (`adb install`, bukan dari Play Store) punya permission
    sensitif (kamera, mikrofon) TERKUNCI ke "Don't allow" secara diam-diam
    (`cmd appops get` menunjukkan `CAMERA: ignore` +
    `ACCESS_RESTRICTED_SETTINGS: default; rejectTime=...`), dan App Info →
    Permissions menunjukkan "No permissions allowed" dengan radio button
    yang tidak responsif terhadap tap. Fix di kode: tambah `<queries>`
    block untuk `android.media.action.IMAGE_CAPTURE` di
    `AndroidManifest.xml` (package visibility Android 11+, diperlukan
    `image_picker` untuk resolve app kamera). Fix di device (tidak bisa
    dari kode): buka App Info → menu titik-tiga → "Allow restricted
    setting", baru permission kamera bisa di-grant normal. Ini bug
    device/OS, bukan bug aplikasi — reproduksi ulang di device release
    (bukan sideload) tidak akan mengalami ini.
  - Setelah KEDUANYA sukses: `DiscoverOnboardingDraftStorage.clear()`,
    lalu `context.go('/main')` (GANTI dari `/discover` lama — lihat
    section "Route `/main`" di bawah).
- **Bug kritis: `android.permission.INTERNET` TIDAK ADA di
  `AndroidManifest.xml`** sejak initial commit — ditemukan saat
  `flutter build apk --release` lalu install ke device fisik: SEMUA
  network call gagal dengan `Failed host lookup: 'couplivy.kriukgo.id'`
  meski domain valid (curl langsung dari luar ke `/api/health` sukses
  200) dan device terkoneksi internet normal (WiFi + LTE aktif,
  `ping`/`nslookup` domain dari shell device berhasil). Root cause:
  tanpa permission ini, Android memblokir resolusi DNS untuk app di
  level OS SECARA SENYAP — request tidak pernah sampai ke
  `NetdEventListenerService` sama sekali (dikonfirmasi via `adb logcat`
  — nol baris "DNS Requested by ... com.couplivy.app", padahal app
  lain di device yang sama berhasil resolve). `flutter run` (debug
  mode) entah bagaimana tidak kena bug ini (kemungkinan jalur berbeda
  di debug build) — makanya baru ketahuan setelah `--release` build
  benar-benar dites di device, bukan cuma hot-reload harian. Fix: tambah
  `<uses-permission android:name="android.permission.INTERNET" />` di
  `AndroidManifest.xml`. **PELAJARAN**: kalau ada laporan "network
  error"/"failed host lookup" yang aneh (domain terbukti hidup, device
  online), cek `AndroidManifest.xml` untuk permission INTERNET SEBELUM
  curiga ke DNS/firewall/Private DNS device — App tanpa permission ini
  gagal secara identik dengan gejala DNS rusak.
  - **Jebakan XML tambahan saat menambahkan komentar ke manifest**:
    komentar XML TIDAK BOLEH mengandung `--` (double-hyphen ASCII) di
    tengahnya sama sekali — termasuk dalam contoh command/flag seperti
    `flutter build apk --release` yang ditulis apa adanya di komentar.
    Manifest merger Gradle gagal dengan `SAXParseException: The string
    "--" is not permitted within comments` (bukan error yang jelas
    menunjuk baris penyebab tanpa `--stacktrace`). Em-dash Unicode (—)
    AMAN dipakai, cuma double-hyphen ASCII literal yang dilarang.
## Onboarding — Step 7 (Lifestyle), Step 8 (Future), Love Language & Interests max 5 — SELESAI

- **Interests (step 6) sekarang WAJIB minimal 3, MAKSIMAL 5** (dulu
  tanpa batas atas). Begitu 5 terpilih, chip yang BELUM dipilih jadi
  redup (`Opacity` 0.4) dan tidak bisa di-tap (`onTap: null`) sampai
  user uncheck salah satu dulu — BUKAN diam-diam mengabaikan tap ke-6,
  atau auto-swap pilihan pertama. `_toggle()` di
  `InterestsStepScreen` cuma nambah id baru kalau
  `_selectedIds.length < _maximumInterests`.
- **Step 7 Lifestyle (BARU, TIDAK ADA di desain HTML asli)** —
  `lifestyle_step_screen.dart`. 3 field, SEMUA WAJIB (tanpa Skip,
  konsisten step lain): Drinking (never/occasionally/socially/
  regularly/prefer_not_to_say), Smoking (never/occasionally/regularly/
  prefer_not_to_say — TANPA "socially", beda dari Drinking), Pets
  (love_pets/neutral/not_a_fan). UI 3 `PreferenceRow` (row select, tap
  buka bottom sheet single-select `showSingleSelectSheet` — lihat
  bagian `PreferenceRow` di bawah).
- **Step 8 Future (BARU, TIDAK ADA di desain HTML asli)** —
  `future_step_screen.dart`. 2 field, SEMUA WAJIB: Children
  (`children_preference` — want_children/not_want_children/
  have_children/open_to_children/not_sure/prefer_not_to_say), Marriage
  (`marriage_preference` — want_marriage/open_to_marriage/
  not_want_marriage/not_sure). UI 2 `PreferenceRow`, pola sama
  Lifestyle.
  - **`children_preference` GANTI TOTAL `wants_children` lama** — dulu
    field boolean 3-pilihan (Yes/No/Not sure) di step Bio, SEKARANG
    dihapus total (bukan cuma di-rename) dan diganti 6 opsi di step
    Future ini. Slot pertanyaan di step Bio yang ditinggalkan diisi
    Love Language (lihat poin berikut).
- **Love Language (BARU) — slot pengganti "Do you want children?" di
  step Bio (step 4)**. Multi-select MAKSIMAL 2 dari 6 opsi
  (words_of_affirmation/quality_time/acts_of_service/physical_touch/
  gifts/dont_know_yet), state `Set<String> _loveLanguages` di
  `BioStepScreen`. Sama pola disable/dim seperti Interests max 5 —
  chip yang belum dipilih jadi redup begitu sudah 2 terpilih. Disimpan
  ke draft via `saveLoveLanguages()`/`readLoveLanguages()`
  (`SharedPreferences.setStringList`), dikirim ke backend sebagai
  `love_languages` (array) — backend simpan ke tabel anak terpisah
  `profile_love_languages` (`HasMany` dari `Profile`, BUKAN
  `BelongsToMany` — nilainya enum string tetap, bukan master data;
  lihat `.ai/rules/architecture.md` backend).
- **Urutan step direindex** akibat 2 step baru disisipkan SETELAH
  Interests, SEBELUM Relationship Goal: Relationship Goal 7→9,
  Preferences 8→10, Preview 9→11. `totalSteps` di SEMUA
  `OnboardingStepScaffold`/`OnboardingStepHeader` step Discover jadi
  11 (dulu 9), termasuk step SEBELUM Lifestyle (DOB/Gender/Photos/Bio/
  Work-Education/Interests) yang step number-nya sendiri tidak
  berubah.
- **`DiscoverOnboardingDraftStorage.resolveNextStepRoute()`** — Lifestyle
  dan Future dicek SETELAH Photos, SEBELUM Relationship Goal (KEDUANYA
  wajib semua field, beda dari Bio/Work-Education/Interests/Preferences
  yang tetap dianggap step optional untuk keperluan resume — lihat
  komentar method itu).

## Onboarding — Step 10 (Preferences) redesign: "Open for all" & 6 field baru — SELESAI

- **GANTI TOTAL** — SEMUA opsi "any"/"everyone" di step Preferences
  GANTI jadi "Open for all" (`open_for_all`), SEMUA opsi
  "prefer_not_to_say"/"other"/"neutral" DIHAPUS dari enum preferensi di
  step ini (beda dari field serupa milik profil sendiri di step Bio/
  Lifestyle/Future yang TETAP punya opsi itu — lihat backend
  `.ai/rules/architecture.md` untuk daftar enum pasti tiap field).
  `_openForAllKey` (GANTI `_anyOptionKey` lama) di
  `PreferencesStepScreen`.
- **Gender TETAP single-select** (`showSingleSelectSheet`) — cuma
  "everyone" → "open_for_all". SEMUA field lain (8 total) SEKARANG
  MULTI-select via `_showMultiSelectSheet` (checkbox, "open_for_all"
  exclusive — pilih itu otomatis uncheck opsi lain, sama pola "any"
  lama):
  - **`family_preference` (kolom tunggal) DIHAPUS TOTAL** — digantikan
    2 field terpisah, KEDUANYA multi-select: **Children**
    (`children_preference` — want_children/not_want_children/
    have_children/open_to_children/not_sure/open_for_all, enum SAMA
    dengan `children_preference` step Future MINUS
    "prefer_not_to_say") dan **Marriage** (`marriage_preference` —
    want_marriage/open_to_marriage/not_want_marriage/not_sure/
    open_for_all, enum SAMA dengan step Future).
  - **4 field multi-select BARU**, tidak ada UI-nya sebelumnya di step
    ini:
    - **Ethnicity** (`ethnicity_preference`) — enum SAMA dengan
      `BioStepScreen._ethnicityOptions` MINUS "other"/
      "prefer_not_to_say", PLUS "open_for_all".
    - **Drinking** (`drinking_preference`) — enum SAMA dengan
      `LifestyleStepScreen._drinkingOptions` MINUS
      "prefer_not_to_say", PLUS "open_for_all".
    - **Smoking** (`smoking_preference`) — enum SAMA dengan
      `LifestyleStepScreen._smokingOptions` MINUS
      "prefer_not_to_say", PLUS "open_for_all".
    - **Pets** (`pet_preference` — NAMA FIELD SAMA PERSIS dengan
      `pet_preference` milik profil sendiri di step Lifestyle, TAPI
      beda konteks/tipe: di sini multi-select preferensi pasangan,
      cuma 3 opsi love_pets/not_a_fan/open_for_all, **TANPA "neutral"**
      — keputusan produk: "neutral" dianggap setara "open_for_all"
      untuk preferensi pasangan (BEDA dari `pet_preference` milik
      profil sendiri yang PUNYA opsi neutral).
  - `religion_preference`/`education_preference` (SUDAH ADA
    sebelumnya) — enum-nya berubah: "any" → "open_for_all", "other"
    DIHAPUS dari opsi Religion.
  - `_openForAllKey` SELALU opsi TERAKHIR di tiap Map options (BEDA
    dari "any" lama yang selalu di PALING ATAS — keputusan produk kali
    ini, opsi spesifik didahulukan).
- **9 `PreferenceRow` total** di step ini sekarang: Gender, Children,
  Marriage, Ethnicity, Religion, Education, Drinking, Smoking, Pets
  (urutan tampil di `build()`) — draft disimpan sebagai 1 JSON blob
  `preferences` (`savePreferences()`/`readPreferences()`, TIDAK
  berubah strukturnya), field baru cuma nambah key di Map yang sama.
- **`PreviewStepScreen`** — field state lama `_familyPreference`
  (String tunggal) diganti `_childrenPreferences`/`_marriagePreferences`
  (List), ditambah `_ethnicityPreferences`/`_drinkingPreferences`/
  `_smokingPreferences`/`_petPreferences` (semua List) — section
  "Looking for" tampilkan SEMUA field baru dengan pola summary
  join-koma yang sama (`_childrenOptionLabel`/`_marriageOptionLabel`/
  dst, method baru per field — BUKAN switch tunggal lama
  `_familyPreferenceLabel` yang cuma untuk 1 nilai).
- Backend: migration `replace_family_preference_with_children_and_
  marriage_preference_in_dating_preferences_table` (drop kolom) + 6
  migration `create_dating_preference_{ethnicities,children,marriages,
  drinkings,smokings,pets}_table` (tabel anak baru, pola sama
  `dating_preference_religions`) — lihat `.ai/rules/architecture.md`
  backend untuk detail lengkap model/service. `DiscoverOnboardingService::
  completeProfile()` validasi manual "open_for_all tidak boleh
  digabung opsi lain" per field (pertahanan lapis kedua, Flutter sudah
  mencegah ini di UI).

- `GET /api/interests` — `features/onboarding/discover/interest_repository.dart`
  (`InterestRepository`), model `core/models/interest.dart` (`Interest`,
  `{id, slug, category}`). `interest_labels.dart` punya 2 method: 
  `labelFor()` terjemahkan `slug` → label chip, `categoryLabelFor()`
  terjemahkan `category` → judul section (switch statement manual,
  BUKAN dari server — server cuma kirim slug/category).
  - **26 interest, 5 kategori** (Food, Travel, Sports, Arts,
    Entertainment) — GANTI TOTAL dari daftar lama (20 interest generik
    flat, tanpa kategori: travel/hiking/food/dst), keputusan produk.
    Daftar lengkap & urutan per kategori: lihat
    `couplivy-backend/database/seeders/InterestSeeder.php`. Kolom
    `category` ditambah ke tabel `interests` backend (migration
    `add_category_to_interests_table` + `replace_interests_with_
    categorized_list` yang hapus 20 slug lama, cascade ke
    `user_interests`, lalu re-seed).
  - **UI dikelompokkan per section** (`InterestsStepScreen`) — judul
    kategori (`InterestLabels.categoryLabelFor`) di atas tiap `Wrap`
    chip-nya sendiri, BUKAN 1 `Wrap` flat lagi. Urutan section
    MENGIKUTI urutan kemunculan `category` di response API (`orderBy
    ('id')` di `InterestController`, ikut urutan seed) — `_groupByCategory()`
    pakai `Map` biasa (insertion order), BUKAN `groupBy`+sort ulang.
  - **Di-cache lokal via drift (SQLite)** — `core/storage/app_database.dart`
    (`AppDatabase`, tabel `CachedInterests { id, slug, category }`,
    `schemaVersion` 2 — kolom `category` ditambah lewat `MigrationStrategy.
    onUpgrade` `addColumn`, default `''` untuk baris lama, langsung
    ditimpa `refreshCache()` di login/register berikutnya). Alasan pakai
    SQLite (bukan SharedPreferences+JSON seperti draft onboarding):
    keputusan produk untuk data master yang berpotensi bertambah banyak
    ke depan (bukan cuma 10 baris interests) dan bisa dipakai fitur lain.
    Instance tunggal `appDatabase` (pola sama seperti `interestRepository`
    lain — bukan di-construct manual di widget). `InterestRepository.list()`
    baca cache DULU (instan), fallback network kalau cache kosong (akun
    lama / data lokal terhapus) sambil sekalian isi cache.
    `InterestRepository.refreshCache()` dipanggil (fire-and-forget, lihat
    `unawaited()`) tepat setelah login/register sukses
    (`AuthRepository._post`) — supaya saat user (kalau mode discover)
    sampai step Interests, cache SUDAH terisi, step render instan tanpa
    network round-trip. Kegagalan refresh diabaikan (bukan dilempar) —
    tidak boleh menggagalkan alur login/register, dan `list()` tetap
    punya fallback network.
  - Code generator drift: jalankan
    `dart run build_runner build --delete-conflicting-outputs` setelah
    ubah skema tabel di `app_database.dart` (generate `app_database.g.dart`).
- Step Interests WAJIB minimal 3 dipilih (tombol Skip DIHAPUS — keputusan
  produk, lihat catatan di bawah) — divalidasi di client (pesan instan)
  DAN lagi di server (`DiscoverOnboardingService`, defense-in-depth).
- `height_cm`/`ethnicity`/`wants_children` digabung ke step Bio (jadi
  "Detail Diri") — field ini ADA di skema `profiles` tapi TIDAK ADA di
  desain HTML `05-bio.html` sumber, keputusan produk (lihat
  `.ai/rules/architecture.md` backend untuk detail).
  - **Step 4 (Bio), 5 (Work/Education), 6 (Interests) SEMUA field WAJIB
    diisi** — tombol Skip DIHAPUS dari ketiganya (awalnya optional dengan
    Skip, keputusan produk berubah). Backend
    (`CompleteProfileRequest`) juga diupdate jadi `required` untuk semua
    field ini.
  - **Ethnicity BUKAN teks bebas lagi** — bottom sheet select dengan 10
    kategori luas (asian, black_african_descent, hispanic_latino,
    middle_eastern, native_american, pacific_islander, south_asian,
    white_caucasian, mixed_multiracial, other) — pola sama seperti dating
    app besar (Tinder/Bumble/Hinge), BUKAN per-suku/per-negara granular.
    "other" jadi jaring pengaman.
  - **Height punya unit switcher cm/ft** (`_HeightUnitToggle` di
    `bio_step_screen.dart`) — toggle segmented kecil di samping label.
    Unit `ft` pakai 2 field TERPISAH (Feet + Inches), BUKAN feet desimal
    (mis. "5.7 ft") — feet desimal TIDAK SAMA dengan notasi umum 5'7" (5
    ft 7 in): 5.7 ft sebenarnya ≡ 5'8.4", ambigu dan berisiko salah
    input. Backend/draft SELALU simpan `height_cm` (satu-satunya bentuk
    yang dikirim) — konversi ft+in↔cm terjadi di client
    (`_BioStepScreenState._heightCm` getter, `_applyHeightCm`). Preferensi
    unit tampilan (`'cm'`/`'ft'`) disimpan TERPISAH di draft lokal
    (`saveHeightUnitPreference`/`readHeightUnitPreference`) — MURNI
    preferensi tampilan, tidak dikirim ke server.
  - **Education tambah 2 opsi**: `no_education`, `elementary` (sebelum
    `high_school`) — dipakai di step Work/Education DAN
    `education_preference` di step Preferences. Backend enum di
    `CompleteProfileRequest` diupdate untuk keduanya.
  - **`religion` DITAMBAH ke step Bio** (bottom sheet select, sama pola
    Ethnicity) — kolom `profiles.religion` SUDAH ADA di skema sejak awal
    (bahkan sudah punya cast `encrypted`) tapi TIDAK PERNAH bisa diisi
    lewat onboarding (`CompleteProfileRequest` tidak punya rule untuk
    field ini) sampai ditambahkan sekarang. WAJIB, TANPA opsi "any"
    (beda dari `religion_preference` di step Preferences, yang punya
    "any" karena itu preferensi siapa yang dicari, bukan agama sendiri).
    `religion_preference` di step Preferences JUGA diubah dari teks bebas
    (`TextEditingController` + `AlertDialog`) jadi bottom sheet select —
    sebelumnya tidak konsisten dengan field select lain
    (Ethnicity/Education). Icon row Preferences diganti dari
    `PhosphorIcons.cross()` (simbol salib, spesifik Kristen/Katolik) ke
    `PhosphorIcons.handsPraying()` (netral lintas agama).
  - **`ethnicity`/`religion` daftar opsinya GANTI TOTAL** (bukan cuma
    ditambah) — keputusan produk, dijalankan aman karena 0 baris data
    existing saat perubahan dibuat. Enum SEKARANG (lihat
    `BioStepScreen._ethnicityOptions`/`_religionOptions` dan
    `PreferencesStepScreen._religionOptions` untuk definisi pasti, HARUS
    sinkron dengan `couplivy-backend` `CompleteProfileRequest`):
    - `ethnicity` (18 opsi): east_asian, south_asian, southeast_asian,
      middle_eastern, black_african, hispanic_latino, white_european,
      javanese, sundanese, batak, minangkabau, balinese, madurese,
      betawi, bugis, dayak, papuan, other, prefer_not_to_say — campuran
      kategori regional/rasial umum DAN suku Indonesia spesifik (pasar
      utama app ini).
    - `religion` (13 opsi): islam, christianity, catholic, hinduism,
      buddhism, confucianism, judaism, sikhism, taoism, other,
      agnostic, atheist, prefer_not_to_say. `religion_preference` di
      step Preferences pakai enum SAMA + "any" (12 opsi + any, TANPA
      `prefer_not_to_say` — tidak masuk akal sebagai preferensi siapa
      yang dicari).
  - `_summaryFor` (ringkasan multi-select di step Preferences) urutan
    tampil MENGIKUTI urutan Map `_religionOptions`/`_educationOptions`
    (bukan urutan tap user) — pilih "Christianity" lalu "Islam" tampil
    sebagai "Islam, Christianity" karena Islam duluan di Map.
  - **Bottom sheet select generik** (`_BioStepScreenState._pickFromOptions`
    di `bio_step_screen.dart`, `_showPickerSheet` di
    `preferences_step_screen.dart`) SELALU dibatasi tinggi
    (`maxHeight: 70% layar`) + `ListView` scrollable (BUKAN `Column`
    polos) — daftar opsi yang panjang (Ethnicity 11, Religion 10,
    Education 7) bisa overflow di layar pendek kalau tidak dibatasi.
  - **`religion_preference`/`education_preference` di step Preferences
    MULTI-SELECT (checkbox), BUKAN single-select lagi** — `Set<String>`
    (`_religionPreferences`/`_educationPreferences` di
    `PreferencesStepScreen`), disimpan ke draft sebagai `List<String>`
    JSON (bagian dari blob `preferences`, lihat
    `DiscoverOnboardingDraftStorage.savePreferences`/`readPreferences`),
    dikirim ke backend sebagai array (tabel anak
    `dating_preference_religions`/`_educations`, lihat
    `.ai/rules/architecture.md` backend).
    - Bottom sheet BEDA dari `_showPickerSheet` (`ListTile` + return 1
      value) — pakai `_showMultiSelectSheet` sendiri: `CheckboxListTile`
      per opsi + `StatefulBuilder` (state sheet lokal, terpisah dari
      state screen supaya centang langsung ke-render tanpa nutup sheet),
      tombol Continue eksplisit di bawah (bukan `Navigator.pop` langsung
      per-tap seperti single-select, karena user perlu bisa centang
      BANYAK sebelum konfirmasi).
    - **"any" SELALU opsi PERTAMA** di kedua Map options (`_religionOptions`/
      `_educationOptions` di `PreferencesStepScreen` — beda urutan dari
      `BioStepScreen._religionOptions` yang TIDAK PUNYA "any" sama
      sekali) — permintaan produk supaya opsi paling umum/exclusive
      langsung terlihat duluan, bukan di akhir daftar.
    - **"any" EXCLUSIVE** — pilih "any" otomatis uncheck semua opsi lain
      (karena "any" sudah mencakup semua), pilih opsi spesifik lain
      otomatis uncheck "any". Mencegah kombinasi rancu seperti
      "Any + Christian" yang secara makna sama saja dengan "Any" saja.
      Logic ada di `_showMultiSelectSheet.toggle()`.
    - **Summary row tampilkan SEMUA yang dipilih**, dipisah koma (mis.
      "Christian, Muslim") — `_summaryFor()`, urutan ikut urutan Map
      options (BUKAN urutan `Set`, yang tidak stabil/tidak terjamin
      urutannya) supaya tampilan konsisten tiap kali sheet dibuka ulang.
      `_PreferenceRow.value` dibungkus `Flexible` + `overflow: ellipsis`
      (sebelumnya `Text` polos tanpa constraint) karena ringkasan
      multi-select bisa jauh lebih panjang dari 1 nilai single-select.
    - **`_PreferenceRow` DIEKSTRAK jadi `PreferenceRow`** (shared widget,
      `shared/widgets/preference_row.dart`) + `showSingleSelectSheet()`
      top-level function — dipakai ulang di step Lifestyle & Future
      (lihat section di atas) supaya tidak duplikasi kode. Kontrak sama
      persis dengan implementasi privat lama di sini.
- **Trade-off yang DITERIMA sebagai keputusan produk**: kalau app
  di-uninstall atau user logout SEBELUM sampai step terakhir, draft lokal
  (termasuk foto yang sudah di-copy ke temp dir, belum ter-upload) hilang
  — user mulai dari step 1 (DOB) lagi. SharedPreferences BERTAHAN walau
  app di-kill (bukan cuma minimize) — cuma hilang kalau uninstall.
- `OnboardingStatus.resolveResumeRoute()` (`core/models/`, async) —
  kalau `mode == 'discover'` dan `!completed`, resume LANGSUNG ke step
  pertama yang belum terisi di draft lokal (lihat
  `DiscoverOnboardingDraftStorage.resolveNextStepRoute()`), BUKAN selalu
  ke step 1 (DOB). Awalnya didesain selalu ke step 1 (dengan asumsi user
  cuma tinggal skip cepat lewat step yang sudah terisi), tapi user
  melapor itu membingungkan — sudah sampai step 3 (Photos), keluar app,
  masuk lagi malah balik ke step 1. Cuma cek field WAJIB per step (DOB,
  Gender, Photos minimal 1, Relationship Goal) — step optional (Bio,
  Work/Education, Interests, Preferences) tidak dipakai sebagai penanda
  progress karena boleh kosong selamanya; kalau semua step wajib sudah
  terisi, resume ke Preview. Server tetap tidak tahu progress di tengah
  step 1-8 (data cuma ada di draft lokal device yang bersangkutan) —
  lihat penjelasan detail di `.ai/rules/architecture.md` backend.
- `OnboardingStepHeader` (`shared/widgets/`) — back arrow + progress bar +
  label "x/total", dipakai SEMUA step Discover. Param `step` 1-indexed.
  `SelectableOptionCard` (`shared/widgets/`) — radio card dengan state
  "selected" persisten (border+bg lilac+checkmark), dipakai step Gender
  (icon-only) dan Relationship Goal (icon+deskripsi). `GatewayOptionCard`
  SEKARANG JUGA punya konsep "sedang dipilih" (param `selected`) — lihat
  section "Onboarding — Gateway Choice (Step 1)" di atas — bedanya
  cuma layout (Column besar dengan `ctaLabel` teks, bukan Row kecil).
- **`relationship_goal` (step 7) GANTI TOTAL** dari 3 opsi lama
  (Serious Relationship/Casual Dating/Friendship) jadi 4 opsi baru:
  serious_dating, casual_dating, new_connections, still_figuring_out —
  keputusan produk, "Friendship" DIHAPUS TOTAL bukan di-rename. 4 kartu
  (bukan 3) tetap aman dari overflow karena `OnboardingStepScaffold`
  sudah bungkus body dengan `SingleChildScrollView`.
- `OnboardingStepScaffold` (`shared/widgets/onboarding_step_scaffold.dart`)
  — kerangka WAJIB semua step Discover: `OnboardingStepHeader` di atas,
  body scrollable di tengah, `bottomButton` opsional (biasanya tombol
  "Continue") DI-PIN ke bawah layar (di LUAR `SingleChildScrollView`,
  sibling terpisah dalam `Column` utama) — bukan ikut scroll bersama
  konten. `errorText` opsional tampil tepat di atas `bottomButton`.
  Kontrak: `body` JANGAN kasih padding sendiri (scaffold sudah kasih
  `EdgeInsets.fromLTRB(24, 16, 24, 24)`). Step dengan state
  loading/error yang butuh Scaffold manual (mis. Interests, retry di
  tengah layar) boleh skip `OnboardingStepScaffold` untuk state itu
  saja dan pakai `OnboardingStepHeader` langsung — lihat
  `interests_step_screen.dart` sebagai contoh percabangan.
- Pola pilih-lalu-Continue: Gender, Relationship Goal, DAN
  `GatewayChoiceScreen` (pre-onboarding, bukan step Discover tapi
  polanya diseragamkan juga) semuanya pakai tombol Continue eksplisit
  — tap kartu cuma `setState()` (pilih), aksi sesungguhnya (navigasi
  ATAU submit API, tergantung screen) baru terjadi saat tap "Continue"
  (disabled/`onPressed: null` kalau belum ada pilihan). TIDAK ADA lagi
  step/screen yang auto-navigate/auto-submit langsung dari tap kartu —
  yang terakhir (`GatewayChoiceScreen`) baru diseragamkan belakangan,
  lihat section "Onboarding — Gateway Choice (Step 1)" di atas.
- **Pelajaran (jangan diulang)**: `Padding` dengan `EdgeInsets` NEGATIF
  (mis. `EdgeInsets.only(right: -24)`) SELALU crash — assertion
  `'padding.isNonNegative': is not true`, Flutter tidak mengizinkan
  sama sekali. `LayoutBuilder` + `OverflowBox` di dalam
  `SingleChildScrollView` vertikal RAPUH untuk kasus "full-bleed row
  nempel tepi layar" — `SingleChildScrollView` kasih constraint tinggi
  unbounded (`0..infinity`), `OverflowBox.alignment` butuh ukuran
  finite buat hitung posisi, hasilnya `Offset(NaN, NaN)` (crash saat
  widget test tap). Kalau butuh elemen full-bleed di dalam scroll
  view vertikal, JANGAN pakai kombinasi ini — pertimbangkan
  `Transform.translate` dengan `ClipRect`, atau letakkan elemen di
  LUAR `SingleChildScrollView` sama sekali.
- Kalau jalur Together dibuat nanti, ikuti pola yang sama:
  `together_onboarding_draft_storage.dart`,
  `together_onboarding_repository.dart`, `features/onboarding/together/`,
  JANGAN campur dengan Discover.
- Sumber desain tiap step: `couplivy-docs/flow/01-discover/onboarding/*.html`
  (`02-dob.html` s.d. `10-preview.html` — nomor file MASIH pakai
  penomoran lama basis 10 step, `01-name.html` TIDAK RELEVAN lagi, sudah
  dihapus dari alur; progress bar Flutter pakai basis 9, bukan 10).
- **Widget test**: DOB, Gender, Bio, Work/Education, Relationship Goal,
  Preferences punya test (render + navigasi dasar, tanpa network). Photos,
  Interests, Preview SENGAJA TIDAK punya widget test — butuh mock
  Dio/image_picker yang belum ada infrastrukturnya di project ini; network
  call sungguhan di widget test bikin pending timer/flaky (dicoba, gagal —
  lihat riwayat kalau perlu detail). Verifikasi 3 screen itu via
  `flutter analyze` + manual di device.

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

## Route `/main` (GANTI dari `/discover` lama) — SELESAI

- Route 3-tab container (`MainNavigationScreen` — Discover, Connections,
  Profile) DULU dinamai `/discover` (nama sisa dari sebelum fitur
  Connections/Profile dibangun, waktu halaman ini memang cuma 1 fitur).
  **GANTI TOTAL jadi `/main`** — nama lama MENYESATKAN (seolah halaman
  ini cuma fitur Discover, padahal isinya 3 tab termasuk Profile yang
  sekarang sudah dibangun penuh). Ditemukan user lewat
  `DebugRouteOverlay` (badge path route, lihat section di bawah) yang
  terus menampilkan `/discover` walau sedang di tab Profile/Connections
  — jadi jelas nama route-nya sendiri yang keliru, bukan overlay-nya.
- SEMUA referensi `context.go('/discover')`/`'/discover'` di-ganti jadi
  `/main`: `router.dart` (`GoRoute.path`/`name`),
  `OnboardingStatus.resolveResumeRoute()` (`core/models/`),
  `PreviewStepScreen._submit()` (redirect setelah submit onboarding
  sukses). Path `/onboarding/discover/*` (step onboarding) TIDAK
  berubah — itu namespace terpisah, tetap "discover" karena memang
  spesifik jalur onboarding mode Discover.

## Development di Chrome (`flutter run -d chrome`) — SELESAI

- **App sekarang bisa dijalankan di web** (`flutter run -d chrome` atau
  `flutter build web`) untuk iterasi UI cepat TANPA install APK ke
  device fisik tiap kali — dipakai sebagai alat bantu DEVELOPMENT, BUKAN
  target rilis (app ini mobile-first, web TIDAK di-maintain untuk
  production).
- **Blocker yang DIPERBAIKI**: `AppDatabase` (drift, cache Interests,
  lihat `core/storage/app_database.dart`) pakai `package:drift/native.dart`
  → transitif import `package:sqlite3` → `dart:ffi`, yang GAGAL DI-COMPILE
  SAMA SEKALI untuk target web (bukan cuma gagal runtime) — error
  `"Pointer isn't a type"` dkk muncul begitu `app_database.dart` ikut
  ter-include di dependency graph kompail web, TERLEPAS apakah kode itu
  benar-benar dipanggil saat runtime atau tidak.
- **Fix: abstraksi `InterestCache` + conditional import** — BUKAN setup
  drift-wasm penuh (butuh download manual `sqlite3.wasm` dari GitHub +
  compile drift worker ke JS + taruh di folder `web/`, dipertimbangkan
  tapi ditolak karena terlalu rumit untuk tujuan "dev cepat di browser"):
  - `core/storage/interest_cache.dart` — interface `InterestCache`
    (`readAll()`/`writeAll()`), SATU kontrak dipakai `InterestRepository`.
  - `core/storage/interest_cache_native.dart` — `NativeInterestCache`,
    isinya PERSIS logic drift yang dulu ada langsung di
    `InterestRepository` (tidak berubah perilaku, cuma dipindah).
  - `core/storage/interest_cache_web.dart` — `WebInterestCache`,
    in-memory `List` biasa. **TIDAK PERSIST antar reload browser**
    (hilang tiap refresh tab) — trade-off yang DITERIMA, `InterestRepository.
    list()` tetap fallback ke network kalau cache kosong, jadi fitur
    Interests tetap berfungsi penuh di web, cuma selalu network call
    ulang setelah reload (beda dari native yang persist di SQLite).
  - `core/storage/interest_cache_factory.dart` — titik masuk tunggal,
    pilih implementasi lewat **conditional import**
    (`if (dart.library.js_interop) 'interest_cache_web.dart'`), DICEK
    SAAT COMPILE TIME — BUKAN `kIsWeb` runtime biasa. Ini WAJIB
    conditional import (bukan if/else runtime) karena masalahnya ada di
    tahap COMPILE, bukan tahap pemanggilan method.
  - `InterestRepository` diubah construktornya dari `(Dio, AppDatabase)`
    jadi `(Dio, InterestCache)` — `interestRepository` singleton pakai
    `createInterestCache()` dari factory, BUKAN `appDatabase` langsung
    lagi. `AppDatabase`/`appDatabase` (drift) sendiri TIDAK diubah/
    dihapus — tetap dipakai penuh di native, cuma TIDAK PERNAH di-import
    dari kode yang ikut compile ke web.
  - **PELAJARAN untuk dependency native lain ke depan** (`flutter_secure_
    storage`, `path_provider`, dst) — kalau ada paket baru yang transitif
    pakai `dart:ffi`/`dart:io` dan perlu tetap berfungsi (bukan cuma
    tidak crash compile) di web, pola yang SAMA (interface + 2
    implementasi + conditional import factory) yang harus diikuti,
    BUKAN coba cari workaround runtime (`kIsWeb` check) karena itu TIDAK
    MENYELESAIKAN masalah compile-time.
- **`flutter_secure_storage` (TokenStorage) BELUM diverifikasi penuh di
  web** saat fitur ini pertama dibuat — kemungkinan fallback ke
  `localStorage` browser (kurang aman, tapi biasanya tetap fungsional
  untuk testing). Kalau ditemukan blocker serupa drift di atas, fix-nya
  kemungkinan pola yang sama (abstraksi + conditional import).
- **Cara jalankan**: `flutter run -d chrome` (device `chrome`/`Chrome
  (web)` otomatis terdeteksi kalau Chrome terinstall, lihat `flutter
  devices`). Di lingkungan TANPA TTY interaktif (mis. dijalankan background
  oleh automation), proses CLI `flutter run` akan keluar begitu
  attach/compile selesai (tidak ada sesi `r`/`R`/`q` hot-reload interaktif)
  — TAPI dev server Dart VM-nya (`dartvm` process, default port 9100-an
  atau sesuai `--web-port`) TETAP HIDUP dan bisa diakses via browser/curl
  selama proses background itu tidak di-kill — cek `lsof -i :<port>`
  atau `curl localhost:<port>` untuk konfirmasi server masih serve,
  JANGAN asumsikan app gagal jalan hanya karena command exit code-nya
  balik ke shell.

## Profile/Account — Tab "Profile" — SEBAGIAN SELESAI

- Sumber desain: `couplivy-docs/flow/03-shared/profile-account.html`
  (§6.10, satu halaman menu vertikal — BUKAN tab/section yang bisa
  di-swipe, tiap menu item link ke halaman TERPISAH). `ProfileScreen`
  (`features/profile/profile_screen.dart`) DULU cuma placeholder kosong
  (`Scaffold(backgroundColor: AppColors.lightGray)`), sekarang dibangun
  penuh: header (avatar/nama+umur/occupation · education), completeness
  box, upgrade banner (gradient `AppColors.peach` → `AppColors.lilac`,
  sama hex dengan CSS `linear-gradient(135deg,#FFD5B5,#A788FA)` di HTML
  sumber), 8 menu item.

### Database lokal profil — prinsip "local-first", BUKAN cache

- **Keputusan arsitektur eksplisit (bukan istilah teknis semata)**: data
  profil milik user sendiri di HP (My Profile, My Preferences, nanti
  Privacy) disimpan di **database lokal** (`ProfileDatabase`, SQLite via
  drift) yang dianggap SUMBER UTAMA yang dibaca UI — BUKAN sekadar
  "cache" (salinan sementara/sekunder dari server). Server (`GET /me`)
  dipakai HANYA untuk SYNC (tarik data terbaru masuk, dorong perubahan
  edit keluar), bukan sumber yang langsung dibaca UI tiap saat. Istilah
  "cache" SENGAJA DIHINDARI di penamaan kelas/tabel/komentar bagian ini
  (beda dari `CachedInterests` yang MEMANG cache beneran — master data
  publik, bukan data user, boleh hilang & refetch kapan saja) — kalau
  menulis kode baru di area ini dan tergoda menamai sesuatu "cache",
  berhenti dan pakai istilah "local database"/"sync" sebagai gantinya.
- **Lingkup keputusan ini**: KHUSUS Profile (My Profile, My Preferences,
  Privacy). Draft onboarding (`DiscoverOnboardingDraftStorage`,
  SharedPreferences) dan cache Interests (`CachedInterests`, drift)
  TIDAK ikut diubah — keduanya sudah punya pola sendiri yang berjalan,
  di luar scope ini.
- **Riwayat singkat (supaya tidak bingung kalau nemu sisa istilah lama)**:
  versi PERTAMA fitur ini (dalam sesi yang sama) sempat dibangun sebagai
  `MyProfileStorage` (SharedPreferences, JSON blob tunggal) lalu
  `ProfileCache` (drift, tapi masih dinamai "cache") — KEDUANYA
  DIGANTI TOTAL ke `ProfileDatabase` setelah user secara eksplisit
  mengoreksi arah desainnya: bukan cache, tapi database lokal yang
  sah. Kalau nemu nama lama itu di komentar/riwayat percakapan lama,
  itu sudah usang — `ProfileDatabase` adalah nama final.
- **4 ATURAN BACA/TULIS tegas** (lihat docstring `ProfileDatabase` untuk
  versi lengkap):
  1. **Baca**: SEMUA layar Profile baca dari `ProfileDatabase.read()` —
     TIDAK ADA logic tersembunyi lain. Kalau local DB kosong, itu SINYAL
     "belum pernah sync", bukan alasan diam-diam fetch terus-menerus di
     background.
  2. **Sync masuk (download)** — titik-titik EKSPLISIT saja, TIDAK ADA
     background sync/polling:
     - Setelah login/register sukses (`AuthRepository._post()`, HANYA
       kalau `onboarding.completed == true` — percuma fetch `GET /me`
       kalau profil belum pernah dibuat di server).
     - Setelah onboarding submit sukses (`PreviewStepScreen._submit()`).
     - Fallback DI DALAM `ProfileScreen._loadProfile()` kalau local DB
       MASIH kosong di titik itu (device baru/reinstall yang somehow
       belum sempat sync di titik 1/2 — mis. app di-kill di tengah).
  3. **Edit (tulis)** — MENYUSUL, belum dibangun. WAJIB online: submit
     ke server dulu, SUKSES baru panggil `ProfileDatabase.save()` dengan
     response server. TIDAK ADA optimistic write (local DB tidak boleh
     berubah sebelum server confirm) — gagal network = tidak ada yang
     berubah di mana pun, user lihat pesan error.
  4. **Tidak ada background sync/polling** sama sekali — cuma 3 titik
     eksplisit di atas.
- **`ProfileDatabase` (`core/storage/profile_database.dart`)** — static
  methods `save()`/`read()`/`clear()`, backing SQLite via drift
  (`appDatabase`, `core/storage/app_database.dart`). Tabel: `Profiles`
  (1 baris, `id` selalu 0 — field scalar: bio, occupation, education,
  ethnicity, dst, PLUS field scalar dating-preference seperti
  `preferenceAgeMin`/`preferenceGenderPreference`) + 9 tabel anak field
  array (`LoveLanguages`, `ProfileInterests`, `Photos` — punya
  `position`/`isMain`, bukan cuma `value` — dan 7 tabel `Preference*`
  untuk tiap kategori dating preference). Tabel anak SEMUA 1 kolom
  `value` string (kecuali `Photos`), replace-total (`delete` lalu
  `insertAll`) tiap `save()`, BUKAN update parsial — pola sama
  `dating_preference_religions` dkk di backend.
  - **`appDatabase` SENGAJA bukan `final`** (`AppDatabase appDatabase =
    AppDatabase();`) — widget test ganti instance ini dengan
    `AppDatabase.forTesting(NativeDatabase.memory())` lewat
    `test/test_helpers/profile_database_test_helper.dart`
    (`useInMemoryAppDatabaseForTesting()` di `setUp()`,
    `seedProfileDatabase(MyProfile)` untuk isi data sebelum
    `pumpWidget()`) — production code TIDAK PERNAH reassign ini.
  - `driftRuntimeOptions.dontWarnAboutMultipleDatabases = true` di-set
    di helper test itu — drift biasanya warning kalau `AppDatabase`
    dibuat berkali-kali (indikasi bug di app beneran), tapi di test
    MEMANG disengaja (instance baru per test case, `QueryExecutor`
    in-memory terpisah tiap kali, tidak ada race condition nyata).
- **`ProfileRepository.syncMyProfile()` (`features/profile/profile_repository.dart`,
  dulu `fetchAndCacheMyProfile()`)** — panggil `GET /me`, lalu
  `ProfileDatabase.save()` dengan hasilnya. SATU-SATUNYA jalur masuk
  data profil dari server ke local DB. Kegagalan di titik pemanggilan
  manapun (login, submit onboarding, fallback ProfileScreen) DIABAIKAN
  (tidak dilempar ulang ke pemanggil) — tidak boleh menggagalkan
  login/submit onboarding, dan ProfileScreen tetap render dengan data
  kosong daripada stuck loading.
- **8 menu di `ProfileScreen`, status per menu**:
  - **My Profile** (`my_profile_screen.dart`) — READ-ONLY dari
    `ProfileDatabase.read()`, BISA DIBUKA OFFLINE. TIDAK ADA editing
    (menyusul sesi terpisah). Semua field detail (height, gender,
    ethnicity, religion, education, relationship goal, love language,
    drinking, smoking, pets, children/marriage preference) via
    `ProfileLabels` (label mapping generik, lihat di bawah).
  - **My Preferences** (`my_preferences_screen.dart`) — READ-ONLY dari
    `ProfileDatabase.read()` (field `preferences`), BISA DIBUKA OFFLINE.
    Dulu SELALU fetch `GET /me` tiap dibuka — diubah supaya konsisten
    aturan baca #1 di atas.
  - **Privacy & Visibility** (`privacy_settings_screen.dart`) — 7
    `Switch`, `GET`/`PATCH /privacy-settings`. BELUM migrasi ke local DB
    (TIDAK dalam scope sesi yang membangun `ProfileDatabase` — masih
    fetch fresh tiap dibuka, datanya kecil & jarang diakses). Kalau
    nanti disatukan prinsip local-first-nya, ini kandidat berikutnya.
    Optimistic update (`_toggle()`): UI berubah dulu, PATCH di
    background, rollback + tampilkan error kalau gagal.
  - **App Settings** (`app_settings_screen.dart`) & **Terms & Privacy**
    (`terms_screen.dart`) — UI STATIS, TANPA backend baru (keputusan
    produk). Bahasa app cuma DITAMPILKAN (`Localizations.localeOf`),
    TIDAK bisa diganti dari dalam app (`CouplivyApp` belum punya toggle
    locale manual, lihat `app.dart`). Versi app HARDCODE
    (`AppSettingsScreen._appVersion`) — project belum pakai
    `package_info_plus` untuk baca versi runtime, WAJIB update manual
    kalau `pubspec.yaml` `version:` naik, sampai package itu ditambahkan.
    Terms of Service/Privacy Policy row di `TermsScreen` SENGAJA
    `onTap: () {}` (no-op) — konten legal belum ditulis, di luar scope
    frontend/backend.
  - **Notifications & Safety & Reporting** — BELUM ADA tabel/model/
    controller SAMA SEKALI di backend (beda dari Privacy yang tabelnya
    sudah ada sejak awal) — route `/profile/notifications` dan
    `/profile/safety` render `ComingSoonScreen` (`widgets/
    coming_soon_screen.dart`, placeholder generik dipakai lintas menu
    yang belum dibangun). **Upgrade to Couplivy Plus** banner juga
    push ke `/profile/upgrade` yang SAMA-SAMA `ComingSoonScreen` — fitur
    Plus itu sendiri belum ada scope-nya sama sekali.
- **`ProfileLabels` (`features/profile/profile_labels.dart`)** — SATU
  sumber kebenaran translate enum → label tampil untuk MyProfileScreen
  DAN MyPreferencesScreen. SENGAJA method static terpisah, BUKAN reuse
  langsung dari method privat `BioStepScreen`/`LifestyleStepScreen`/
  `FutureStepScreen`/`PreferencesStepScreen` (screen ONBOARDING itu
  tetap simpan switch-case sendiri) — helper ini murni untuk fitur BARU
  read-only di luar alur onboarding, supaya tidak menambah shared-state
  lintas fitur yang tidak perlu. `ProfileLabels.joinAll()` mengikuti
  URUTAN LIST INPUT apa adanya (BUKAN urutan kemunculan di Map options)
  — beda dari `_summaryFor()` di `PreferencesStepScreen` (onboarding)
  yang sengaja urut berdasar Map options demi tampilan konsisten; di
  sini tidak ada requirement itu.
- **`AuthRepository.logout()`** — panggil `POST /auth/logout` (revoke
  token Sanctum server-side) SEBELUM hapus `TokenStorage`/
  `UserSessionStorage`/`ProfileDatabase`/`DiscoverOnboardingDraftStorage`
  lokal. Kegagalan network SENGAJA DIABAIKAN (tidak dilempar ulang) —
  user harus tetap bisa "logout" dari device ini meski offline; token/
  database lokal tetap dihapus di jalur manapun. Dipanggil dari
  `ProfileScreen._confirmLogOut()` (dialog konfirmasi dulu, `AlertDialog`
  — bukan aksi 1-tap langsung), redirect ke `/welcome` setelah selesai.
- **`ProfileMenuRow` (`features/profile/widgets/profile_menu_row.dart`)**
  — row menu generik (icon+label+chevron, opsional badge dot merah untuk
  Notifications, `isDestructive` untuk Log Out yang teksnya merah TANPA
  chevron) — pola row terpisah dari `PreferenceRow` (`shared/widgets/`)
  karena kontraknya beda (menu navigasi murni, bukan pick-a-value).
