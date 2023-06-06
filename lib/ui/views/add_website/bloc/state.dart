/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class AddWebsiteFormState with _$AddWebsiteFormState {
  const factory AddWebsiteFormState({
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
    @Default(0.0) double globalFees,
    bool? globalFeesValidated,
    bool? applyGitIgnoreRules,
    @Default(false) bool? controlInProgress,
    @Default('') String errorText,
  }) = _AddWebsiteFormState;
  const AddWebsiteFormState._();

  bool get isControlsOk => errorText == '';

  bool get creationInProgress =>
      (step > 0 && step < 12 && stepError.isEmpty) || controlInProgress == true;

  bool get processFinished => stepError.isNotEmpty || step >= 12;

  bool get canAddWebsite => isControlsOk;
}
