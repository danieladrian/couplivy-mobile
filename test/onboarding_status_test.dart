import 'package:flutter_test/flutter_test.dart';

import 'package:couplivy_mobile/core/models/onboarding_status.dart';

void main() {
  group('OnboardingStatus.resumeRoute', () {
    test('completed -> /discover regardless of step', () {
      const status = OnboardingStatus(
        completed: true,
        currentStep: 'gateway_choice',
        mode: 'discover',
      );

      expect(status.resumeRoute, '/discover');
    });

    test('mode null (never picked Gateway Choice) -> /gateway-choice', () {
      const status = OnboardingStatus(
        completed: false,
        currentStep: null,
        mode: null,
      );

      expect(status.resumeRoute, '/gateway-choice');
    });

    test('mode together (not supported yet) -> /gateway-choice', () {
      const status = OnboardingStatus(
        completed: false,
        currentStep: 'gateway_choice',
        mode: 'together',
      );

      expect(status.resumeRoute, '/gateway-choice');
    });

    test('mode discover, not completed -> /discover placeholder '
        '(step 1 profile form/DOB not built yet)', () {
      const status = OnboardingStatus(
        completed: false,
        currentStep: 'gateway_choice',
        mode: 'discover',
      );

      expect(status.resumeRoute, '/discover');
    });
  });
}
