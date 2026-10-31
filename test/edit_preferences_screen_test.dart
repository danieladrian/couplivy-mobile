import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/core/models/my_profile.dart';
import 'package:couplivy_mobile/features/profile/edit_preferences_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

/// Widget test murni UI — tidak menyentuh network (belum ada
/// infrastruktur mocking Dio di project ini, sama catatan
/// gateway_choice_screen_test.dart) — jadi TIDAK menekan tombol Save
/// sampai submit sungguhan (itu akan memanggil API beneran). Cakupannya:
/// nilai awal terisi dari `initialPreferences`, Save disabled kalau ada
/// field yang belum lengkap, dan Save ENABLED begitu semua terisi
/// (termasuk kasus initialPreferences null, field kosong semua).
void main() {
  Widget buildApp(MyDatingPreferences? initial) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: EditPreferencesScreen(initialPreferences: initial),
    );
  }

  const seedPreferences = MyDatingPreferences(
    ageMin: 25,
    ageMax: 35,
    genderPreference: 'open_for_all',
    childrenPreference: ['open_for_all'],
    marriagePreference: ['open_for_all'],
    ethnicityPreference: ['open_for_all'],
    religionPreference: ['christianity', 'islam'],
    educationPreference: ['open_for_all'],
    drinkingPreference: ['open_for_all'],
    smokingPreference: ['open_for_all'],
    petPreference: ['love_pets'],
  );

  testWidgets(
    'pre-fills all rows from initialPreferences and Save is enabled',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp(seedPreferences));
      await tester.pumpAndSettle();

      expect(find.text('25 – 35 years old'), findsOneWidget);
      expect(find.text('Open for all'), findsWidgets);
      expect(find.text('Islam, Christianity'), findsOneWidget);
      expect(find.text('Love pets'), findsOneWidget);

      final saveButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Save'),
      );
      expect(saveButton.onPressed, isNotNull);
    },
  );

  testWidgets('Save disabled when starting from no preferences at all', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp(null));
    await tester.pumpAndSettle();

    final saveButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Save'),
    );
    expect(saveButton.onPressed, isNull);
  });

  testWidgets(
    'picking Gender preference (only missing field) enables Save',
    (WidgetTester tester) async {
      final incomplete = MyDatingPreferences(
        ageMin: seedPreferences.ageMin,
        ageMax: seedPreferences.ageMax,
        genderPreference: null,
        childrenPreference: seedPreferences.childrenPreference,
        marriagePreference: seedPreferences.marriagePreference,
        ethnicityPreference: seedPreferences.ethnicityPreference,
        religionPreference: seedPreferences.religionPreference,
        educationPreference: seedPreferences.educationPreference,
        drinkingPreference: seedPreferences.drinkingPreference,
        smokingPreference: seedPreferences.smokingPreference,
        petPreference: seedPreferences.petPreference,
      );

      await tester.pumpWidget(buildApp(incomplete));
      await tester.pumpAndSettle();

      var saveButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Save'),
      );
      expect(saveButton.onPressed, isNull);

      await tester.tap(find.text('Gender'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open for all').last);
      await tester.pumpAndSettle();

      saveButton = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Save'),
      );
      expect(saveButton.onPressed, isNotNull);
    },
  );
}
