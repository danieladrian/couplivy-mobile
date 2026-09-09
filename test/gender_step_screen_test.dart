import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/gender_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/gender',
      routes: [
        GoRoute(
          path: '/onboarding/discover/dob',
          builder: (context, state) => const Scaffold(body: Text('DOB')),
        ),
        GoRoute(
          path: '/onboarding/discover/gender',
          builder: (context, state) => const GenderStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/photos',
          builder: (context, state) => const Scaffold(body: Text('Photos')),
        ),
      ],
    );
  }

  testWidgets('shows only Female and Male options and 2/9 progress', (
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

    expect(find.text("What's your gender?"), findsOneWidget);
    expect(find.text('2/9'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Non-binary'), findsNothing);
  });

  testWidgets('tapping an option navigates to Photos', (
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

    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();

    expect(find.text('Photos'), findsOneWidget);
  });
}
