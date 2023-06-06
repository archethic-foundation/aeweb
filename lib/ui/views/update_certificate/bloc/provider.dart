/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/update_certificate.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/state.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _initialUpdateCertificateFormProvider =
    Provider<UpdateCertificateFormState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _updateCertificateFormProvider = NotifierProvider.autoDispose<
    UpdateCertificateFormNotifier, UpdateCertificateFormState>(
  () {
    return UpdateCertificateFormNotifier();
  },
  dependencies: [
    UpdateCertificateFormProvider.initialUpdateCertificateForm,
  ],
);

class UpdateCertificateFormNotifier
    extends AutoDisposeNotifier<UpdateCertificateFormState>
    with CertificateMixin {
  UpdateCertificateFormNotifier();

  @override
  UpdateCertificateFormState build() => ref.watch(
        UpdateCertificateFormProvider.initialUpdateCertificateForm,
      );

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

  bool controlCert(BuildContext context) {
    if (state.publicCert == null || state.privateKey == null) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!
            .updateCertificateStepErrorSSLCertKeyEmpty,
      );
      return false;
    }
    if (CertificateMixin.validCertificatFromFile(state.publicCert!) == false) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!
            .updateCertificateStepErrorSSLCertInvalid,
      );
      return false;
    }
    if (CertificateMixin.validPrivateKeyFromFile(state.privateKey!) == false) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!
            .updateCertificateStepErrorPrivateKeyInvalid,
      );
      return false;
    }
    return true;
  }

  Future<void> updateCertificate(BuildContext context, WidgetRef ref) async {
    await UpdateCertificateUseCases().run(
      ref,
      context,
    );
  }
}

abstract class UpdateCertificateFormProvider {
  static final initialUpdateCertificateForm =
      _initialUpdateCertificateFormProvider;
  static final updateCertificateForm = _updateCertificateFormProvider;
}
