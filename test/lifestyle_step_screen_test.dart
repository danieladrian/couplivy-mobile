import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/lifestyle_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/lifestyle',
      routes: [
        GoRoute(
          path: '/onboarding/discover/interests',
          builder: (context, state) => const Scaffold(body: Text('Interests')),
        ),
        GoRoute(
          path: '/onboarding/discover/lifestyle',
          builder: (context, state) => const LifestyleStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/future',
          builder: (context, state) => const Scaffold(body: Text('Future')),
        ),
      ],
    );
  }

  Future<void> fillAllRequiredFields(WidgetTester tester) async {
    await tester.tap(find.text('Drinking'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Never'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Smoking'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Never'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pets'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Love pets'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows Drinking/Smoking/Pets rows and 7/11 progress', (
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

    expect(find.text('Your lifestyle'), findsOneWidget);
    expect(find.text('7/11'), findsOneWidget);
    expect(find.text('Drinking'), findsOneWidget);
    expect(find.text('Smoking'), findsOneWidget);
    expect(find.text('Pets'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('Continue disabled until all 3 fields are picked', (
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
    'picking Drinking/Smoking/Pets then tapping Continue navigates to Future',
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

      await fillAllRequiredFields(tester);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Future'), findsOneWidget);
    },
  );
}
