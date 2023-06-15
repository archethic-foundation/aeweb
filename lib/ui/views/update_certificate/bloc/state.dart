/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UpdateCertificateFormState with _$UpdateCertificateFormState {
  const factory UpdateCertificateFormState({
    @Default(0) int step,
    @Default('') String stepError,
    @Default('') String name,
    @Default('') String publicCertPath,
    Uint8List? publicCert,
    @Default('') String privateKeyPath,
    Uint8List? privateKey,
    @Default(0.0) double globalFeesUCO,
    @Default(0.0) double globalFeesFiat,
    bool? globalFeesValidated,
    @Default(false) bool? controlInProgress,
    @Default('') String errorText,
  }) = _UpdateCertificateFormState;
  const UpdateCertificateFormState._();

  bool get isControlsOk => errorText == '';

  bool get creationInProgress =>
      (step > 0 && step < 10 && stepError.isEmpty) || controlInProgress == true;

  bool get processFinished => stepError.isNotEmpty || step >= 10;

  bool get canUpdateCertificate => isControlsOk;
}
