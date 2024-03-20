/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:typed_data';

import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/domain/usecases/website/update_website_sync.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/state.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _updateWebsiteSyncFormProvider = NotifierProvider.autoDispose<
    UpdateWebsiteSyncFormNotifier, UpdateWebsiteSyncFormState>(
  () {
    return UpdateWebsiteSyncFormNotifier();
  },
);

class UpdateWebsiteSyncFormNotifier
    extends AutoDisposeNotifier<UpdateWebsiteSyncFormState> {
  UpdateWebsiteSyncFormNotifier();

  @override
  UpdateWebsiteSyncFormState build() {
    return const UpdateWebsiteSyncFormState();
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
    return;
  }

  void setLocalFiles(
    Map<String, HostingRefContentMetaData> localFiles,
  ) {
    state = state.copyWith(
      localFiles: localFiles,
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

  void setComparedFiles(
    List<HostingContentComparison> comparedFiles,
  ) {
    state = state.copyWith(
      comparedFiles: comparedFiles,
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

  void setPrivateKeyPath(
    String privateKeyPath,
  ) {
    state = state.copyWith(
      privateKeyPath: privateKeyPath,
    );
  }

  void setPrivateKey(
    Uint8List privateKey,
  ) {
    state = state.copyWith(
      privateKey: privateKey,
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

  Future<void> update(BuildContext context, WidgetRef ref) async {
    await UpdateWebsiteSyncUseCases().run(
      ref,
      context,
    );
  }
}

abstract class UpdateWebsiteSyncFormProvider {
  static final updateWebsiteSyncForm = _updateWebsiteSyncFormProvider;
}
