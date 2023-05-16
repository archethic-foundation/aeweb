/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/add_website.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
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

class AddWebsiteFormNotifier extends AutoDisposeNotifier<AddWebsiteFormState> {
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
    Uint8List publicCert,
  ) {
    state = state.copyWith(
      publicCert: publicCert,
    );
  }

  void setPrivateKey(
    Uint8List privateKey,
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

  Future<void> addWebsite(BuildContext context, WidgetRef ref) async {
    await AddWebsiteUseCases().run(
      ref,
    );
  }
}

abstract class AddWebsiteFormProvider {
  static final initialAddWebsiteForm = _initialAddWebsiteFormProvider;
  static final addWebsiteForm = _addWebsiteFormProvider;
}
