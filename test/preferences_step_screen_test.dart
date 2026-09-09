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
    expect(find.text('Save Preferences'), findsOneWidget);
  });

  testWidgets('Save Preferences navigates to Preview', (
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

    await tester.tap(find.text('Save Preferences'));
    await tester.pumpAndSettle();

    expect(find.text('Preview'), findsOneWidget);
  });

  testWidgets(
    'Religion row opens a select bottom sheet (not a free-text dialog)',
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

      // Select bottom sheet, bukan AlertDialog dengan TextField bebas.
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Christian'), findsOneWidget);
      expect(find.text('Muslim'), findsOneWidget);
      expect(find.text('Any'), findsWidgets);

      await tester.tap(find.text('Muslim'));
      await tester.pumpAndSettle();

      expect(find.text('Muslim'), findsOneWidget);
    },
  );
}
