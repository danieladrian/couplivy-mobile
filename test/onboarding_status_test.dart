import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:couplivy_mobile/core/models/onboarding_status.dart';
import 'package:couplivy_mobile/features/onboarding/discover/discover_onboarding_draft_storage.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('OnboardingStatus.resolveResumeRoute', () {
    test('completed -> /main regardless of step', () async {
      const status = OnboardingStatus(
        completed: true,
        currentStep: 'gateway_choice',
        mode: 'discover',
      );

      expect(await status.resolveResumeRoute(), '/main');
    });

    test(
      'mode null (never picked Gateway Choice) -> /gateway-choice',
      () async {
        const status = OnboardingStatus(
          completed: false,
          currentStep: null,
          mode: null,
        );

        expect(await status.resolveResumeRoute(), '/gateway-choice');
      },
    );

    test('mode together (not supported yet) -> /gateway-choice', () async {
      const status = OnboardingStatus(
        completed: false,
        currentStep: 'gateway_choice',
        mode: 'together',
      );

      expect(await status.resolveResumeRoute(), '/gateway-choice');
    });

    test('mode discover, no draft yet -> step 1 profile form (DOB)', () async {
      const status = OnboardingStatus(
        completed: false,
        currentStep: 'gateway_choice',
        mode: 'discover',
      );

      expect(await status.resolveResumeRoute(), '/onboarding/discover/dob');
    });

    test('mode discover, DOB+Gender+Photos filled -> resume at Lifestyle '
        '(step 7, first unfilled REQUIRED step)', () async {
      await DiscoverOnboardingDraftStorage.saveDob('1996-08-20');
      await DiscoverOnboardingDraftStorage.saveGender('male');
      await DiscoverOnboardingDraftStorage.savePhotoPaths(['/tmp/a.jpg']);

      const status = OnboardingStatus(
        completed: false,
        currentStep: 'gateway_choice',
        mode: 'discover',
      );

      expect(
        await status.resolveResumeRoute(),
        '/onboarding/discover/lifestyle',
      );
    });

    test('mode discover, DOB+Gender+Photos+Lifestyle filled -> resume at '
        'Future (step 8, first unfilled REQUIRED step)', () async {
      await DiscoverOnboardingDraftStorage.saveDob('1996-08-20');
      await DiscoverOnboardingDraftStorage.saveGender('male');
      await DiscoverOnboardingDraftStorage.savePhotoPaths(['/tmp/a.jpg']);
      await DiscoverOnboardingDraftStorage.saveDrinking('never');
      await DiscoverOnboardingDraftStorage.saveSmoking('never');
      await DiscoverOnboardingDraftStorage.savePetPreference('love_pets');

      const status = OnboardingStatus(
        completed: false,
        currentStep: 'gateway_choice',
        mode: 'discover',
      );

      expect(await status.resolveResumeRoute(), '/onboarding/discover/future');
    });

    test(
      'mode discover, all required steps filled -> resume at Preview',
      () async {
        await DiscoverOnboardingDraftStorage.saveDob('1996-08-20');
        await DiscoverOnboardingDraftStorage.saveGender('male');
        await DiscoverOnboardingDraftStorage.savePhotoPaths(['/tmp/a.jpg']);
        await DiscoverOnboardingDraftStorage.saveDrinking('never');
        await DiscoverOnboardingDraftStorage.saveSmoking('never');
        await DiscoverOnboardingDraftStorage.savePetPreference('love_pets');
        await DiscoverOnboardingDraftStorage.saveChildrenPreference('not_sure');
        await DiscoverOnboardingDraftStorage.saveMarriagePreference('not_sure');
        await DiscoverOnboardingDraftStorage.saveRelationshipGoal(
          'serious_relationship',
        );

        const status = OnboardingStatus(
          completed: false,
          currentStep: 'gateway_choice',
          mode: 'discover',
        );

        expect(
          await status.resolveResumeRoute(),
          '/onboarding/discover/preview',
        );
      },
    );
  });
}
