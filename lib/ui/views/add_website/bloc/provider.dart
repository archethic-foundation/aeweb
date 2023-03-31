/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/create_website.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
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

  void setError(
    String errorText,
  ) {
    state = state.copyWith(
      errorText: errorText,
    );
  }

  void setAddWebsiteProcessStep(int addWebsiteProcessStep) {
    state = state.copyWith(
      addWebsiteProcessStep: addWebsiteProcessStep,
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
    if (state.path.trim().isEmpty) {
      state = state.copyWith(
        errorText: AppLocalizations.of(context)!.addWebsitePathMissing,
      );
      return false;
    }
    return true;
  }

  Future<void> create(BuildContext context, WidgetRef ref) async {
    await CreateWebsiteUseCases().createWebsite(
      ref,
      state.name,
      state.path,
      applyGitIgnoreRules: state.applyGitIgnoreRules ?? false,
    );
  }
}

abstract class AddWebsiteFormProvider {
  static final initialAddWebsiteForm = _initialAddWebsiteFormProvider;
  static final addWebsiteForm = _addWebsiteFormProvider;
}
