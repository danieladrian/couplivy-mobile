import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/work_education_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/work-education',
      routes: [
        GoRoute(
          path: '/onboarding/discover/bio',
          builder: (context, state) => const Scaffold(body: Text('Bio')),
        ),
        GoRoute(
          path: '/onboarding/discover/work-education',
          builder: (context, state) => const WorkEducationStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/interests',
          builder: (context, state) => const Scaffold(body: Text('Interests')),
        ),
      ],
    );
  }

  testWidgets('shows occupation and education fields, and NO Skip button', (
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

    expect(find.text('What do you do?'), findsOneWidget);
    expect(find.text('5/9'), findsOneWidget);
    expect(find.text('Occupation'), findsOneWidget);
    expect(find.text('Education'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('Continue blocked with error when fields are empty', (
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

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(
      find.text('Please fill in occupation and education to continue.'),
      findsOneWidget,
    );
    expect(find.text('Interests'), findsNothing);
  });

  testWidgets(
    'filling occupation and picking education navigates to Interests',
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

      await tester.enterText(find.byType(TextField), 'Engineer');

      await tester.tap(find.text('Select education'));
      await tester.pumpAndSettle();
      // Options now include No Education/Elementary — Bachelor's still
      // present, pick it explicitly.
      await tester.tap(find.text("Bachelor's Degree"));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Interests'), findsOneWidget);
    },
  );

  testWidgets('education picker includes No Education and Elementary School', (
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

    await tester.tap(find.text('Select education'));
    await tester.pumpAndSettle();

    expect(find.text('No Education'), findsOneWidget);
    expect(find.text('Elementary School'), findsOneWidget);
  });
}
