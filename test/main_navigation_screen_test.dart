import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/features/main_nav/main_navigation_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  Widget buildApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainNavigationScreen(),
    );
  }

  testWidgets('shows all 3 tabs, Discover selected by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    final navBar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navBar.currentIndex, 0);
  });

  testWidgets('tapping Connections and Profile switches the selected tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Connections'));
    await tester.pumpAndSettle();
    var navBar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navBar.currentIndex, 1);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    navBar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navBar.currentIndex, 2);
  });

  testWidgets('all 3 tabs stay mounted (IndexedStack keeps tab state)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byType(IndexedStack), findsOneWidget);
    final stack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(stack.children.length, 3);
  });
}
