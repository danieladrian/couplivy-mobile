import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/app/app.dart';
import 'package:couplivy_mobile/shared/widgets/auth_footer_link.dart';

void main() {
  // flutter_secure_storage tidak punya plugin implementation di widget test
  // (tidak ada platform asli) — tanpa mock ini, Future dari `.read()` tidak
  // pernah resolve/reject sama sekali, bikin SplashScreen (yang sekarang
  // baca token sebelum redirect) macet permanen di layar splash. Mock
  // method channel-nya supaya selalu balikin null (skenario "belum pernah
  // login"), sama seperti kalau app baru pertama diinstall.
  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, (call) async {
          if (call.method == 'read') return null;
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(secureStorageChannel, null);
  });

  testWidgets('Splash screen shows logo and tagline', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));

    // Splash punya AnimationController yang repeat() terus-menerus
    // (gradient bergeser), jadi tidak pernah "settle" — pump durasi tetap,
    // bukan pumpAndSettle().
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Made for Meaningful Love'), findsOneWidget);

    // Habiskan timer auto-advance (1.5s) supaya tidak jadi "pending timer"
    // yang bikin test berikutnya gagal.
    await tester.pump(const Duration(milliseconds: 1100));
  });

  testWidgets('Splash auto-advances to welcome screen after ~1.5s', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));

    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });

  testWidgets('Welcome screen navigates to Sign Up and back to Login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsNWidgets(2));

    // Footer "Already have an account? Log In" adalah RichText dengan
    // TapGestureRecognizer HANYA di span "Log In" — tap() berbasis posisi
    // bisa jatuh di span lain yang tidak clickable ("Already have an
    // account? "). Panggil onTap langsung supaya test tidak bergantung
    // pada hit-testing posisi span di dalam 1 RichText.
    await tester.ensureVisible(find.byType(AuthFooterLink));
    await tester.pumpAndSettle();
    tester.widget<AuthFooterLink>(find.byType(AuthFooterLink)).onTap();
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
  });

  testWidgets('Back from Sign Up returns to Welcome, not out of the app', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Create Account'), findsNWidgets(2));

    // Simulasikan tombol back Android (bukan tombol header) — sebelumnya
    // Welcome -> Sign Up pakai context.go() (replace, tanpa history), jadi
    // pop di sini akan gagal dan Android fallback keluar app.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Create Account'), findsNothing);
  });

  testWidgets(
    'Back from Sign Up with keyboard open dismisses keyboard first, second back returns to Welcome',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pump();

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Fokus field Name — keyboard "terbuka" (ada TextField aktif).
      await tester.tap(find.text('Your name'));
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);

      // Back PERTAMA — dulu pernah langsung ke Welcome tanpa tutup
      // keyboard dulu (PopScope intercept semua pop, termasuk yang
      // seharusnya cuma dismiss keyboard). Sekarang harus CUMA unfocus,
      // tetap di Sign Up.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsNWidgets(2));
      expect(
        FocusManager.instance.primaryFocus?.context
            ?.findAncestorWidgetOfExactType<EditableText>(),
        isNull,
        reason: 'First back should only dismiss the keyboard',
      );

      // Back KEDUA (keyboard sudah tertutup) — baru pindah ke Welcome.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Create Account'), findsNothing);
    },
  );

  testWidgets(
    'Back from Login (reached via Sign Up footer link) returns to Welcome, not out of the app',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pump();

      // Welcome -> Sign Up (push).
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();
      expect(find.text('Create Account'), findsNWidgets(2));

      // Sign Up -> Login lewat footer link (push juga — sebelumnya go(),
      // yang me-reset SELURUH stack ke [Login] doang, bukan cuma replace
      // Sign Up, itu penyebab back dari Login langsung keluar app).
      await tester.ensureVisible(find.byType(AuthFooterLink));
      await tester.pumpAndSettle();
      tester.widget<AuthFooterLink>(find.byType(AuthFooterLink)).onTap();
      await tester.pumpAndSettle();
      expect(find.text('Welcome Back'), findsOneWidget);

      // Back dari Login (hardware back, bukan tombol header) harus ke
      // Welcome — BUKAN keluar app.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Welcome Back'), findsNothing);
    },
  );

  testWidgets('Pressing back once on Welcome does not exit, twice does', (
    WidgetTester tester,
  ) async {
    final exitCalls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'SystemNavigator.pop') exitCalls.add(call);
          return null;
        });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    await tester.pumpWidget(const ProviderScope(child: CouplivyApp()));
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump();

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(
      exitCalls,
      isEmpty,
      reason: 'First back press must not exit the app immediately',
    );

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(
      exitCalls,
      isNotEmpty,
      reason: 'Second back press (within the window) must exit the app',
    );
  });
}
