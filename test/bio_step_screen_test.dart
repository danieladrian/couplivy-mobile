import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/features/onboarding/discover/bio_step_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: '/onboarding/discover/bio',
      routes: [
        GoRoute(
          path: '/onboarding/discover/photos',
          builder: (context, state) => const Scaffold(body: Text('Photos')),
        ),
        GoRoute(
          path: '/onboarding/discover/bio',
          builder: (context, state) => const BioStepScreen(),
        ),
        GoRoute(
          path: '/onboarding/discover/work-education',
          builder: (context, state) =>
              const Scaffold(body: Text('WorkEducation')),
        ),
      ],
    );
  }

  testWidgets('shows bio field, detail fields, and NO Skip button', (
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

    expect(find.text('Tell us about yourself'), findsOneWidget);
    expect(find.text('4/9'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    expect(find.text('Ethnicity'), findsOneWidget);
    expect(find.text('Select ethnicity'), findsOneWidget);
    expect(find.text('Religion'), findsOneWidget);
    expect(find.text('Select religion'), findsOneWidget);
    expect(find.text('Do you want children?'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    // Unit toggle default cm.
    expect(find.text('cm'), findsOneWidget);
    expect(find.text('ft'), findsOneWidget);
  });

  testWidgets('Continue blocked with error when fields are empty', (
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

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Please fill in all fields to continue.'), findsOneWidget);
    expect(find.text('WorkEducation'), findsNothing);
  });

  testWidgets(
    'filling all fields (incl. ethnicity + religion pickers) navigates to '
    'Work/Education',
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

      // Field 0 = bio, field 1 = height (cm, unit default).
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Hello there');
      await tester.enterText(textFields.at(1), '170');

      await tester.tap(find.text('Select ethnicity'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Asian').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select religion'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Christian').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('WorkEducation'), findsOneWidget);
    },
  );

  testWidgets('ethnicity picker includes Chinese right before Other', (
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

    await tester.tap(find.text('Select ethnicity'));
    await tester.pumpAndSettle();

    expect(find.text('Chinese'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);

    final options = tester.widgetList<ListTile>(find.byType(ListTile));
    final labels = options.map((tile) => (tile.title as Text).data).toList();
    expect(labels.indexOf('Chinese'), labels.indexOf('Other') - 1);
  });
}
