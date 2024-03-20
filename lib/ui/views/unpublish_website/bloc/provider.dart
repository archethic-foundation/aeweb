/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/unpublish_website.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
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
    final oracleUcoPrice =
        await aedappfm.sl.get<OracleService>().getOracleData();
    state = state.copyWith(
      globalFeesUCO: globalFeesUCO,
      globalFeesFiat: globalFeesUCO * (oracleUcoPrice.uco?.usd ?? 0),
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
      context,
    );
  }
}

abstract class UnpublishWebsiteFormProvider {
  static final unpublishWebsiteForm = _unpublishWebsiteFormProvider;
}
