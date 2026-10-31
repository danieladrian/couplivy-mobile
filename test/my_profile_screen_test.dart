import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/core/models/my_profile.dart';
import 'package:couplivy_mobile/features/profile/edit_profile_screen.dart';
import 'package:couplivy_mobile/features/profile/my_profile_screen.dart';
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
      home: const MyProfileScreen(),
    );
  }

  const seedProfile = MyProfile(
    nickName: 'Jowy',
    fullName: 'Jowy Full Name',
    age: 29,
    bio: 'Coffee lover, weekend hiker.',
    occupation: 'Marketing Manager',
    education: 'bachelor',
    heightCm: 170,
    gender: 'female',
    ethnicity: 'east_asian',
    religion: 'christianity',
    relationshipGoal: 'serious_dating',
    drinking: 'socially',
    smoking: 'never',
    petPreference: 'love_pets',
    childrenPreference: 'open_to_children',
    marriagePreference: 'want_marriage',
    loveLanguages: ['quality_time'],
    interestSlugs: ['coffee_tea'],
    photoPaths: [],
    completenessPercent: 90,
    preferences: null,
  );

  testWidgets(
    'shows name, occupation/education header, fact grid, about, and interests',
    (WidgetTester tester) async {
      await seedProfileDatabase(seedProfile);

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      // Hero photo (AspectRatio 1:1, lebar penuh) di viewport test default
      // (800x600) lebih tinggi dari viewport — konten di bawahnya (nama,
      // fact grid, dst) belum ter-build oleh ListView lazy-loading sampai
      // di-scroll (tidak terjadi di HP sungguhan, layar jauh lebih
      // tinggi dari lebarnya).
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      expect(find.text('Jowy, 29'), findsOneWidget);
      expect(
        find.text("Marketing Manager · Bachelor's Degree"),
        findsOneWidget,
      );
      expect(find.text('Coffee lover, weekend hiker.'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Interests'), findsOneWidget);
      // Fact grid — education/religion/height/relationship goal/children/
      // drinking semuanya muncul sebagai tile.
      expect(find.text("Bachelor's Degree"), findsOneWidget);
      expect(find.text('Christianity'), findsOneWidget);
      expect(find.text('170 cm'), findsOneWidget);
      expect(find.text('Serious Dating'), findsOneWidget);
      expect(find.text('Open to children'), findsOneWidget);
      expect(find.text('Socially'), findsOneWidget);
    },
  );

  testWidgets('shows empty state when the local database is empty', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(
      find.text("This section isn't ready yet — check back later."),
      findsOneWidget,
    );
  });

  testWidgets('tapping Edit button opens EditProfileScreen', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfileScreen), findsOneWidget);
  });

  testWidgets('tapping back button pops the screen', (
    WidgetTester tester,
  ) async {
    await seedProfileDatabase(seedProfile);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MyProfileScreen()),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.byType(MyProfileScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(MyProfileScreen), findsNothing);
  });
}
