/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';

import 'package:aeweb/domain/usecases/website/add_website.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _initialAddWebsiteFormProvider = Provider<AddWebsiteFormState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _addWebsiteFormProvider =
    NotifierProvider.autoDispose<AddWebsiteFormNotifier, AddWebsiteFormState>(
  () {
    return AddWebsiteFormNotifier();
  },
  dependencies: [
    AddWebsiteFormProvider.initialAddWebsiteForm,
  ],
);

class AddWebsiteFormNotifier extends AutoDisposeNotifier<AddWebsiteFormState>
    with CertificateMixin, FileMixin {
  AddWebsiteFormNotifier();

  @override
  AddWebsiteFormState build() => ref.watch(
        AddWebsiteFormProvider.initialAddWebsiteForm,
      );

  void setName(
    String name,
  ) {
    state = state.copyWith(
      name: name,
    );
    return;
  }

  void setPath(
    String path,
  ) {
    state = state.copyWith(
      path: path,
    );
  }

  void setApplyGitIgnoreRules(
    bool? applyGitIgnoreRules,
  ) {
    state = state.copyWith(
      applyGitIgnoreRules: applyGitIgnoreRules,
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

  void setZipFilePath(
    String zipFilePath,
  ) {
    state = state.copyWith(
      zipFilePath: zipFilePath,
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

  void setZipFile(
    Uint8List zipFile,
  ) {
    state = state.copyWith(
      zipFile: zipFile,
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

  bool controlName(
    BuildContext context,
  ) {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!.addWebsiteNameMissing,
      );
      return false;
    }
    return true;
  }

  bool controlPath(
    BuildContext context,
  ) {
    if (kIsWeb) {
      if (state.zipFilePath.isEmpty) {
        state = state.copyWith(
          errorText: AppLocalizations.of(context)!.addWebsiteZipFileMissing,
        );
        return false;
      }
    } else {
      if (state.path.trim().isEmpty) {
        state = state.copyWith(
          errorText: AppLocalizations.of(context)!.addWebsitePathMissing,
        );
        return false;
      }
    }

    return true;
  }

  bool controlCert(BuildContext context) {
    if (state.publicCert == null && state.privateKey == null) {
      return true;
    }
    if ((state.publicCert == null && state.privateKey != null) ||
        (state.publicCert != null && state.privateKey == null)) {
      state = state.copyWith(
        errorText:
            AppLocalizations.of(context)!.addWebsiteStepErrorSSLCertKeyEmpty,
      );
      return false;
    }
    if (CertificateMixin.validCertificatFromFile(state.publicCert!) == false) {
      state = state.copyWith(
        errorText:
            AppLocalizations.of(context)!.addWebsiteStepErrorSSLCertInvalid,
      );
      return false;
    }
    if (CertificateMixin.validPrivateKeyFromFile(state.privateKey!) == false) {
      state = state.copyWith(
        errorText:
            AppLocalizations.of(context)!.addWebsiteStepErrorPrivateKeyInvalid,
      );
      return false;
    }

    return true;
  }

  Future<bool> controlNbOfTransactionFiles(BuildContext context) async {
    late final List<Map<String, dynamic>> contents;
    late final Map<String, HostingRefContentMetaData>? files;

    if (kIsWeb) {
      files = await FileMixin.listFilesFromZip(
        state.zipFile!,
        applyGitIgnoreRules: state.applyGitIgnoreRules ?? false,
      );
      if (files == null) {
        return true;
      }
      contents = setContentsFromZip(
        state.zipFile!,
        files.keys.toList(),
      );
    } else {
      files = await FileMixin.listFilesFromPath(
        state.path,
        applyGitIgnoreRules: state.applyGitIgnoreRules ?? false,
      );
      if (files == null) {
        return true;
      }
      contents = setContentsFromPath(
        state.path,
        files.keys.toList(),
      );
    }
    log('Nb of files transaction: ${contents.length}');
    if (contents.length > 1) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!.addWebsiteTooManyFiles,
      );
      return false;
    }
    return true;
  }

  Future<void> addWebsite(BuildContext context, WidgetRef ref) async {
    await AddWebsiteUseCases().run(
      ref,
      context,
    );
  }
}

abstract class AddWebsiteFormProvider {
  static final initialAddWebsiteForm = _initialAddWebsiteFormProvider;
  static final addWebsiteForm = _addWebsiteFormProvider;
}
