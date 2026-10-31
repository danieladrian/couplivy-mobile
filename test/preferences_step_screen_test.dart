import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/preferences_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/preferences',
      routes: [
        GoRoute(
          path: '/onboarding/discover/relationship-goal',
          builder: (context, state) => const Scaffold(body: Text('Goal')),
        ),
        GoRoute(
          path: '/onboarding/discover/preferences',
          builder: (context, state) => const PreferencesStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/preview',
          builder: (context, state) => const Scaffold(body: Text('Preview')),
        ),
      ],
    );
  }

  // Gender (single-select) + 8 field multi-select (semuanya punya "Open
  // for all") WAJIB diisi — dipakai beberapa test buat mem-fill semuanya
  // via UI sebelum tap Continue. Pakai "Open for all" untuk semua field
  // multi-select supaya cukup 1 tap per sheet.
  Future<void> fillAllRequiredPreferences(WidgetTester tester) async {
    await tester.tap(find.text('Gender'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open for all'));
    await tester.pumpAndSettle();

    for (final label in [
      'Children',
      'Marriage',
      'Ethnicity',
      'Religion',
      'Education',
      'Drinking',
      'Smoking',
      'Pets',
    ]) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(CheckboxListTile, 'Open for all'));
      await tester.tap(find.text('Continue').last);
      await tester.pumpAndSettle();
    }
  }

  testWidgets('shows age range and all preference rows, 10/11 progress', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: buildRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text("Tell us what you're looking for"), findsOneWidget);
    expect(find.text('10/11'), findsOneWidget);
    expect(find.text('25 – 35 years old'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Children'), findsOneWidget);
    expect(find.text('Marriage'), findsOneWidget);
    expect(find.text('Ethnicity'), findsOneWidget);
    expect(find.text('Religion'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Drinking'), findsOneWidget);
    expect(find.text('Smoking'), findsOneWidget);
    expect(find.text('Pets'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('Continue disabled until all 9 preferences are picked', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: buildRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Continue'),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets(
    'picking all 9 preferences then tapping Continue navigates to Preview',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      await fillAllRequiredPreferences(tester);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Preview'), findsOneWidget);
    },
  );

  testWidgets(
    'Religion row opens a checkbox multi-select sheet (not a free-text '
    'dialog), summary shows all picked',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Religion'));
      await tester.pumpAndSettle();

      // Checkbox multi-select sheet, bukan AlertDialog dengan TextField
      // bebas, dan bukan radio single-select (ListTile check icon).
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(CheckboxListTile), findsWidgets);
      expect(find.text('Christianity'), findsOneWidget);
      expect(find.text('Islam'), findsOneWidget);
      expect(find.text('Open for all'), findsOneWidget);
      // "other"/"prefer_not_to_say" DIHAPUS dari opsi preferensi ini.
      expect(find.text('Other'), findsNothing);
      expect(find.text('Prefer not to say'), findsNothing);

      // Pilih 2 opsi sekaligus — summary harus tampilkan keduanya, urutan
      // ikut urutan Map `_religionOptions` (Islam sebelum Christianity),
      // BUKAN urutan tap.
      await tester.tap(find.text('Christianity'));
      await tester.tap(find.text('Islam'));
      // `.last` — tombol "Continue" halaman utama tetap ada di tree di
      // belakang sheet (cuma tertutup visual), jadi ada 2 widget dengan
      // teks yang sama; tombol Continue di dalam sheet-nya sendiri
      // dirender belakangan.
      await tester.tap(find.text('Continue').last);
      await tester.pumpAndSettle();

      expect(find.text('Islam, Christianity'), findsOneWidget);
    },
  );

  testWidgets('Religion "Open for all" is exclusive with specific options', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: buildRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Religion'));
    await tester.pumpAndSettle();

    // Pilih Christianity dulu, lalu pilih Open for all — Christianity
    // harus ke-uncheck.
    await tester.tap(find.text('Christianity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open for all'));
    await tester.pumpAndSettle();

    final christianCheckbox = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Christianity'),
    );
    final openForAllCheckbox = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Open for all'),
    );
    expect(christianCheckbox.value, isFalse);
    expect(openForAllCheckbox.value, isTrue);

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    expect(find.text('Open for all'), findsOneWidget);
  });

  testWidgets('Pets row has exactly 3 options (love pets, not a fan, open for '
      'all) — no neutral', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: buildRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pets'));
    await tester.pumpAndSettle();

    expect(find.text('Love pets'), findsOneWidget);
    expect(find.text('Not a fan'), findsOneWidget);
    expect(find.text('Open for all'), findsOneWidget);
    expect(find.text('Neutral'), findsNothing);
  });
}
