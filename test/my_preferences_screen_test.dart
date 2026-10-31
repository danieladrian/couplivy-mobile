import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/core/models/my_profile.dart';
import 'package:couplivy_mobile/features/profile/my_preferences_screen.dart';
import 'package:couplivy_mobile/l10n/generated/app_localizations.dart';

import 'test_helpers/profile_database_test_helper.dart';

void main() {
  setUp(() {
    useInMemoryAppDatabaseForTesting();
  });

  Widget buildApp() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyPreferencesScreen(),
    );
  }

  const seedProfile = MyProfile(
    nickName: 'Jowy',
    fullName: 'Jowy Full Name',
    age: 29,
    bio: null,
    occupation: null,
    education: null,
    heightCm: null,
    gender: null,
    ethnicity: null,
    religion: null,
    relationshipGoal: null,
    drinking: null,
    smoking: null,
    petPreference: null,
    childrenPreference: null,
    marriagePreference: null,
    loveLanguages: [],
    interestSlugs: [],
    photoPaths: [],
    completenessPercent: 90,
    preferences: MyDatingPreferences(
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
    ),
  );

  testWidgets('shows all preference rows from the local database, offline', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text('My Preferences'), findsOneWidget);
    expect(find.text('25 – 35 years old'), findsOneWidget);
    expect(find.text('Open for all'), findsWidgets);
    expect(find.text('Christianity, Islam'), findsOneWidget);
    expect(find.text('Love pets'), findsOneWidget);
  });

  testWidgets('shows empty state when there are no saved preferences', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(
      const MyProfile(
        nickName: 'Jowy',
        fullName: 'Jowy Full Name',
        age: 29,
        bio: null,
        occupation: null,
        education: null,
        heightCm: null,
        gender: null,
        ethnicity: null,
        religion: null,
        relationshipGoal: null,
        drinking: null,
        smoking: null,
        petPreference: null,
        childrenPreference: null,
        marriagePreference: null,
        loveLanguages: [],
        interestSlugs: [],
        photoPaths: [],
        completenessPercent: 90,
        preferences: null,
      ),
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.text("You haven't set your preferences yet."), findsOneWidget);
  });

  testWidgets(
    'shows empty state when the local database has no profile at all',
    (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      expect(
        find.text("You haven't set your preferences yet."),
        findsOneWidget,
      );
    },
  );
}
