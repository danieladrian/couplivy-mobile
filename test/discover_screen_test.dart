import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:couplivy_mobile/features/discover/discover_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  Widget buildApp() {
    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DiscoverScreen(),
    );
  }

  testWidgets('shows 3 dummy candidate cards with compatibility and tags', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('COMPATIBLE'), findsNWidgets(3));
    expect(find.text('Refresh Recommendations'), findsOneWidget);
  });

  testWidgets('tapping Pass (x icon) removes one card from the list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('COMPATIBLE'), findsNWidgets(3));

    await tester.tap(find.byIcon(PhosphorIconsRegular.x).first);
    await tester.pumpAndSettle();

    expect(find.text('COMPATIBLE'), findsNWidgets(2));
  });

  testWidgets('tapping Like (heart icon) removes one card from the list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(PhosphorIconsRegular.heart).first);
    await tester.pumpAndSettle();

    expect(find.text('COMPATIBLE'), findsNWidgets(2));
  });

  testWidgets('tapping Refresh regenerates back to 3 cards', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(PhosphorIconsRegular.x).first);
    await tester.pumpAndSettle();
    expect(find.text('COMPATIBLE'), findsNWidgets(2));

    await tester.tap(find.text('Refresh Recommendations'));
    await tester.pumpAndSettle();

    expect(find.text('COMPATIBLE'), findsNWidgets(3));
  });

  testWidgets('shows empty state after passing all cards away', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(PhosphorIconsRegular.x).first);
      await tester.pumpAndSettle();
    }

    expect(
      find.text('No more profiles right now — check back later or refresh.'),
      findsOneWidget,
    );
  });
}
