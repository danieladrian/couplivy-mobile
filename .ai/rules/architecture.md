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
  di step onboarding lain) dan `DiscoverPlaceholderScreen`
  (`features/discover/`) — placeholder sementara, Discover (feed utama)
  belum dibangun; jadi titik akhir alur onboarding/login supaya bisa
  diverifikasi end-to-end tanpa nyangkut di halaman yang belum ada.

## Onboarding — Step 1-9 Discover (DOB s.d. Preview) — SELESAI

- **Step "Name" (dulu step 2) DIHAPUS TOTAL** — nickname sekarang diisi
  saat Sign Up (lihat section Auth di atas), BUKAN step onboarding
  terpisah. Onboarding Discover sekarang **9 step, SEMUA SUDAH DIBUAT**:
  1 DOB, 2 Gender, 3 Photos, 4 Bio (+Detail Diri), 5 Work/Education,
  6 Interests, 7 Relationship Goal, 8 Preferences, 9 Preview.
  `features/onboarding/discover/*_step_screen.dart` — 1 file per step.
- Step 1-8 (spesifik jalur "Mencari koneksi baru") dipisah dari Gateway
  Choice (step 0 alur lama, sekarang gerbang sebelum step 1) — sama pola
  pemisahan di backend (`DiscoverOnboardingController`/`Service`, route
  `/api/onboarding/discover/*`, lihat `.ai/rules/architecture.md` backend).
- **BUKAN per-step ke API** — step 1-8 diisi & disimpan LOKAL di Flutter
  (`features/onboarding/discover/discover_onboarding_draft_storage.dart`,
  `DiscoverOnboardingDraftStorage` — SharedPreferences, 1 key per field,
  method baca/tulis per field DAN `readAllForSubmit()`/`clear()`), TIDAK
  ADA network call sampai step TERAKHIR (Preview, tombol "Looks Good").
  Tiap screen baca draft-nya sendiri di `initState` (pre-fill kalau user
  balik ke step yang sama) dan `PopScope(canPop: false)` untuk hardware
  back (pola sama Login/SignUp — lihat bagian Routing).
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
    lalu `context.go('/discover')`.
- `GET /api/interests` — `features/onboarding/discover/interest_repository.dart`
  (`InterestRepository`), model `core/models/interest.dart` (`Interest`,
  cuma `{id, slug}`). `interest_labels.dart` (`InterestLabels.labelFor()`)
  terjemahkan `slug` → label i18n (switch statement manual, BUKAN dari
  server — server cuma kirim slug).
  - **Di-cache lokal via drift (SQLite)** — `core/storage/app_database.dart`
    (`AppDatabase`, tabel `CachedInterests { id, slug }`). Alasan pakai
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
    Daftar sama dipakai keduanya: christian, catholic, muslim, buddhist,
    hindu, jewish, sikh, atheist_agnostic, spiritual, other.
    `religion_preference` di step Preferences JUGA diubah dari teks bebas
    (`TextEditingController` + `AlertDialog`) jadi bottom sheet select —
    sebelumnya tidak konsisten dengan field select lain
    (Ethnicity/Education). Icon row Preferences diganti dari
    `PhosphorIcons.cross()` (simbol salib, spesifik Kristen/Katolik) ke
    `PhosphorIcons.handsPraying()` (netral lintas agama).
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
  (icon-only) dan Relationship Goal (icon+deskripsi) — BEDA dari
  `GatewayOptionCard` (murni navigasi, tanpa konsep "sedang dipilih").
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
