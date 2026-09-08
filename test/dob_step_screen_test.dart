import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/dob_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/dob',
      routes: [
        GoRoute(
          path: '/gateway-choice',
          builder: (context, state) => const Scaffold(body: Text('Gateway')),
        ),
        GoRoute(
          path: '/onboarding/discover/dob',
          builder: (context, state) => const DobStepScreen(),
        ),
      ],
    );
  }

  testWidgets('shows title, subtitle, and 1/9 progress label', (
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

    expect(find.text('When were you born?'), findsOneWidget);
    expect(find.text('1/9'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('back button returns to Gateway Choice', (
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

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();

    expect(find.text('Gateway'), findsOneWidget);
  });
}
