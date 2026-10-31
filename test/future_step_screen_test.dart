import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/future_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/future',
      routes: [
        GoRoute(
          path: '/onboarding/discover/lifestyle',
          builder: (context, state) => const Scaffold(body: Text('Lifestyle')),
        ),
        GoRoute(
          path: '/onboarding/discover/future',
          builder: (context, state) => const FutureStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/relationship-goal',
          builder: (context, state) => const Scaffold(body: Text('Goal')),
        ),
      ],
    );
  }

  Future<void> fillAllRequiredFields(WidgetTester tester) async {
    await tester.tap(find.text('Children'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Not sure'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Marriage'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, 'Not sure'));
    await tester.pumpAndSettle();
  }

  testWidgets('shows Children/Marriage rows and 8/11 progress', (
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

    expect(find.text('Looking ahead'), findsOneWidget);
    expect(find.text('8/11'), findsOneWidget);
    expect(find.text('Children'), findsOneWidget);
    expect(find.text('Marriage'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('Continue disabled until both fields are picked', (
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

  testWidgets('picking Children/Marriage then tapping Continue navigates to '
      'Relationship Goal', (WidgetTester tester) async {
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

    expect(find.text('Goal'), findsOneWidget);
  });
}
