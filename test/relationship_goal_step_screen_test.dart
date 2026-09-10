import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/relationship_goal_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/relationship-goal',
      routes: [
        GoRoute(
          path: '/onboarding/discover/interests',
          builder: (context, state) => const Scaffold(body: Text('Interests')),
        ),
        GoRoute(
          path: '/onboarding/discover/relationship-goal',
          builder: (context, state) => const RelationshipGoalStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/preferences',
          builder: (context, state) =>
              const Scaffold(body: Text('Preferences')),
        ),
      ],
    );
  }

  testWidgets('shows all 3 goal options and 7/9 progress', (
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

    expect(find.text('What are you looking for?'), findsOneWidget);
    expect(find.text('7/9'), findsOneWidget);
    expect(find.text('Serious Relationship'), findsOneWidget);
    expect(find.text('Casual Dating'), findsOneWidget);
    expect(find.text('Friendship'), findsOneWidget);
  });

  testWidgets('Continue disabled until an option is picked', (
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
    'selecting an option then tapping Continue navigates to Preferences',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: buildRouter(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Serious Relationship'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Preferences'), findsOneWidget);
    },
  );
}
