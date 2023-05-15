/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/unpublish_website.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _initialUnpublishWebsiteFormProvider =
    Provider<UnpublishWebsiteFormState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _unpublishWebsiteFormProvider = NotifierProvider.autoDispose<
    UnpublishWebsiteFormNotifier, UnpublishWebsiteFormState>(
  () {
    return UnpublishWebsiteFormNotifier();
  },
  dependencies: [
    UnpublishWebsiteFormProvider.initialUnpublishWebsiteForm,
  ],
);

class UnpublishWebsiteFormNotifier
    extends AutoDisposeNotifier<UnpublishWebsiteFormState> {
  UnpublishWebsiteFormNotifier();

  @override
  UnpublishWebsiteFormState build() => ref.watch(
        UnpublishWebsiteFormProvider.initialUnpublishWebsiteForm,
      );

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

  void setGlobalFees(double globalFees) {
    state = state.copyWith(
      globalFees: globalFees,
    );
  }

  void setGlobalFeesValidated(bool? globalFeesValidated) {
    state = state.copyWith(
      globalFeesValidated: globalFeesValidated,
    );
  }

  Future<void> unpublishWebsite(BuildContext context, WidgetRef ref) async {
    await UnpublishWebsiteUseCases().run(
      ref,
    );
  }
}

abstract class UnpublishWebsiteFormProvider {
  static final initialUnpublishWebsiteForm =
      _initialUnpublishWebsiteFormProvider;
  static final unpublishWebsiteForm = _unpublishWebsiteFormProvider;
}
