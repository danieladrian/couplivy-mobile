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

  // Gender/Family/Religion/Education preference WAJIB diisi — dipakai
  // beberapa test buat mem-fill semuanya via UI sebelum tap Continue.
  Future<void> fillAllRequiredPreferences(WidgetTester tester) async {
    await tester.tap(find.text('Gender'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Everyone'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Family preference'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Any').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Religion'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Any').last);
    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Any').last);
    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();
  }

  testWidgets('shows age range and preference rows, 8/9 progress', (
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
    expect(find.text('8/9'), findsOneWidget);
    expect(find.text('25 – 35 years old'), findsOneWidget);
    expect(find.text('Gender'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Save Preferences'), findsNothing);
  });

  testWidgets('Continue disabled until all 4 preferences are picked', (
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
    'picking all 4 preferences then tapping Continue navigates to Preview',
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
      expect(find.text('Christian'), findsOneWidget);
      expect(find.text('Muslim'), findsOneWidget);
      expect(find.text('Any'), findsOneWidget);

      // Pilih 2 opsi sekaligus — summary harus tampilkan keduanya.
      await tester.tap(find.text('Christian'));
      await tester.tap(find.text('Muslim'));
      // `.last` — tombol "Continue" halaman utama tetap ada di tree di
      // belakang sheet (cuma tertutup visual), jadi ada 2 widget dengan
      // teks yang sama; tombol Continue di dalam sheet-nya sendiri
      // dirender belakangan.
      await tester.tap(find.text('Continue').last);
      await tester.pumpAndSettle();

      expect(find.text('Christian, Muslim'), findsOneWidget);
    },
  );

  testWidgets('Religion "Any" is exclusive with specific options', (
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

    // Pilih Christian dulu, lalu pilih Any — Christian harus ke-uncheck.
    await tester.tap(find.text('Christian'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Any'));
    await tester.pumpAndSettle();

    final christianCheckbox = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Christian'),
    );
    final anyCheckbox = tester.widget<CheckboxListTile>(
      find.widgetWithText(CheckboxListTile, 'Any'),
    );
    expect(christianCheckbox.value, isFalse);
    expect(anyCheckbox.value, isTrue);

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    expect(find.text('Any'), findsOneWidget);
  });
}
