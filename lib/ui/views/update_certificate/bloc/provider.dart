/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/update_certificate.usecase.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/state.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _updateCertificateFormProvider = NotifierProvider.autoDispose<
    UpdateCertificateFormNotifier, UpdateCertificateFormState>(() {
  return UpdateCertificateFormNotifier();
});

class UpdateCertificateFormNotifier
    extends AutoDisposeNotifier<UpdateCertificateFormState>
    with CertificateMixin {
  UpdateCertificateFormNotifier();

  @override
  UpdateCertificateFormState build() {
    return const UpdateCertificateFormState();
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

  void setPublicCertPath(
    String publicCertPath,
  ) {
    state = state.copyWith(
      publicCertPath: publicCertPath,
    );
  }

  void setPrivateKeyPath(
    String privateKeyPath,
  ) {
    state = state.copyWith(
      privateKeyPath: privateKeyPath,
    );
  }

  void setPublicCert(
    Uint8List? publicCert,
  ) {
    state = state.copyWith(
      publicCert: publicCert,
    );
  }

  void setPrivateKey(
    Uint8List? privateKey,
  ) {
    state = state.copyWith(
      privateKey: privateKey,
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

  void setControlInProgress(bool controlInProgress) {
    state = state.copyWith(
      controlInProgress: controlInProgress,
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

  bool controlCert(BuildContext context) {
    if (state.publicCert == null || state.privateKey == null) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!
            .updateCertificateStepErrorSSLCertKeyEmpty,
      );
      return false;
    }

    final (bool controlCert, String errorCert) =
        CertificateMixin.validCertificatFromFile(state.publicCert!);
    if (controlCert == false) {
      state = state.copyWith(
        errorText:
            '${AppLocalizations.of(context)!.updateCertificateStepErrorSSLCertInvalid}($errorCert)',
      );
      return false;
    }

    final (bool controlKey, String errorKey) =
        CertificateMixin.validPrivateKeyFromFile(state.privateKey!);

    if (controlKey == false) {
      state = state.copyWith(
        errorText:
            '${AppLocalizations.of(context)!.updateCertificateStepErrorPrivateKeyInvalid} ($errorKey)',
      );
      return false;
    }

    return true;
  }

  Future<void> updateCertificate(BuildContext context, WidgetRef ref) async {
    await UpdateCertificateUseCase().run(
      ref,
      context,
    );
  }
}

abstract class UpdateCertificateFormProvider {
  static final updateCertificateForm = _updateCertificateFormProvider;
}
