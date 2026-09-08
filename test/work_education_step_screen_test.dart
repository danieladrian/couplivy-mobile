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

  testWidgets('shows occupation and education fields with Skip button', (
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
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('Skip navigates to Interests', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: buildRouter(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Interests'), findsOneWidget);
  });
}
