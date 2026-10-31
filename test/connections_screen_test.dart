import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/features/connections/chat_screen.dart';
import 'package:couplivy_mobile/features/connections/connections_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  Widget buildApp() {
    return const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ConnectionsScreen(),
    );
  }

  testWidgets('shows title, Matches tab count, and 4 dummy match rows', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('Matches 4'), findsOneWidget);
    expect(find.textContaining('You both like'), findsNWidgets(4));
  });

  testWidgets('tapping a match row opens the Chat screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('You both like').first);
    await tester.pumpAndSettle();

    expect(find.byType(ChatScreen), findsOneWidget);
  });
}
