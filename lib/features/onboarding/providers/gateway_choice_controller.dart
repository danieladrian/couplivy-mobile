import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/models/onboarding_status.dart';
import '../onboarding_repository.dart';

/// State loading/error untuk submit Gateway Choice — pola sama dengan
/// AuthFormController (idle/loading/error/success).
sealed class GatewayChoiceState {
  const GatewayChoiceState();
}

class GatewayChoiceIdle extends GatewayChoiceState {
  const GatewayChoiceIdle();
}

class GatewayChoiceLoading extends GatewayChoiceState {
  const GatewayChoiceLoading();
}

class GatewayChoiceError extends GatewayChoiceState {
  const GatewayChoiceError(this.error);

  final ApiException error;
}

class GatewayChoiceSuccess extends GatewayChoiceState {
  const GatewayChoiceSuccess(this.onboarding);

  final OnboardingStatus onboarding;
}

class GatewayChoiceController extends Notifier<GatewayChoiceState> {
  @override
  GatewayChoiceState build() => const GatewayChoiceIdle();

  Future<void> choose(String mode) async {
    state = const GatewayChoiceLoading();
    try {
      final onboarding = await onboardingRepository.saveGatewayChoice(
        mode: mode,
      );
      state = GatewayChoiceSuccess(onboarding);
    } on ApiException catch (e) {
      state = GatewayChoiceError(e);
    }
  }
}

final gatewayChoiceProvider =
    NotifierProvider.autoDispose<GatewayChoiceController, GatewayChoiceState>(
      GatewayChoiceController.new,
    );
