/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:typed_data';

import 'package:aeweb/domain/usecases/sync_website.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UpdateWebsiteSyncFormState with _$UpdateWebsiteSyncFormState {
  const factory UpdateWebsiteSyncFormState({
    @Default(0) int step,
    @Default('') String stepError,
    @Default('') String name,
    @Default('') String path,
    @Default('') String publicCertPath,
    Uint8List? publicCert,
    @Default('') String privateKeyPath,
    Uint8List? privateKey,
    @Default('') String zipFilePath,
    Uint8List? zipFile,
    @Default(0.0) double globalFeesUCO,
    @Default(0.0) double globalFeesFiat,
    bool? globalFeesValidated,
    bool? applyGitIgnoreRules,
    @Default('') String errorText,
    @Default({}) Map<String, HostingRefContentMetaData> localFiles,
    @Default([]) List<HostingContentComparison> comparedFiles,
  }) = _UpdateWebsiteSyncFormState;
  const UpdateWebsiteSyncFormState._();

  bool get isControlsOk => errorText == '';

  bool get updateInProgress => step > 0 && step < 13 && stepError.isEmpty;

  bool get processFinished => stepError.isNotEmpty || step >= 13;

  bool get canUpdateWebsiteSync => isControlsOk;
}
