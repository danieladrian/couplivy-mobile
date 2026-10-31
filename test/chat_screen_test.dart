import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:couplivy_mobile/features/connections/chat_screen.dart';
import 'package:couplivy_mobile/features/connections/dummy_match.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

void main() {
  final match = DummyMatch.generateList(1, seed: 42).first;

  Widget buildApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChatScreen(match: match),
    );
  }

  testWidgets('shows match name, online status, and seeded conversation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text(match.name), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('Hi! Thanks for the like 💜'), findsOneWidget);
  });

  testWidgets('typing a message and sending adds it to the conversation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Type a message...'),
      'Hello there!',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Hello there!'), findsOneWidget);
    // Input cleared after sending.
    expect(find.text('Type a message...'), findsOneWidget);
  });

  testWidgets('back button pops the screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ChatScreen(match: match)),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(ChatScreen), findsOneWidget);

    await tester.tap(find.byIcon(PhosphorIconsRegular.arrowLeft).first);
    await tester.pumpAndSettle();

    expect(find.byType(ChatScreen), findsNothing);
  });
}
