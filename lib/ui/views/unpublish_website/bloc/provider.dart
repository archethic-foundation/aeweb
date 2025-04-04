/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/usecases.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _unpublishWebsiteFormProvider = NotifierProvider.autoDispose<
    UnpublishWebsiteFormNotifier, UnpublishWebsiteFormState>(
  () {
    return UnpublishWebsiteFormNotifier();
  },
);

class UnpublishWebsiteFormNotifier
    extends AutoDisposeNotifier<UnpublishWebsiteFormState> {
  UnpublishWebsiteFormNotifier();

  @override
  UnpublishWebsiteFormState build() {
    return const UnpublishWebsiteFormState();
  }

  void resetStep() {
    setStep(0);
    setError('');
  }

  void setName(
    String name,
  ) {
    state = state.copyWith(
      name: name,
    );
  }

  void setError(
    String errorText,
  ) {
    state = state.copyWith(
      errorText: errorText,
    );
  }

  void setStep(int step) {
    state = state.copyWith(
      step: step,
    );
  }

  void setStepError(String stepError) {
    state = state.copyWith(
      stepError: stepError,
    );
  }

  Future<void> setGlobalFeesUCO(double globalFeesUCO) async {
    final archethicOracleUCO = await ref.read(
      aedappfm.ArchethicOracleUCOProviders.archethicOracleUCO.future,
    );
    state = state.copyWith(
      globalFeesUCO: globalFeesUCO,
      globalFeesFiat: globalFeesUCO * archethicOracleUCO.usd,
    );
  }

  void setGlobalFeesValidated(bool? globalFeesValidated) {
    state = state.copyWith(
      globalFeesValidated: globalFeesValidated,
    );
  }

  Future<void> unpublishWebsite(BuildContext context, WidgetRef ref) async {
    await ref.read(unpublishWebsiteUseCaseProvider).run(
          ref,
          context,
        );
  }
}

abstract class UnpublishWebsiteFormProvider {
  static final unpublishWebsiteForm = _unpublishWebsiteFormProvider;
}
