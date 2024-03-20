/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UnpublishWebsiteFormState with _$UnpublishWebsiteFormState {
  const factory UnpublishWebsiteFormState({
    @Default('') String name,
    @Default(0) int step,
    @Default('') String stepError,
    @Default(0.0) double globalFeesUCO,
    @Default(0.0) double globalFeesFiat,
    bool? globalFeesValidated,
    @Default('') String errorText,
    Failure? failure,
  }) = _UnpublishWebsiteFormState;
  const UnpublishWebsiteFormState._();

  bool get isControlsOk => errorText == '';

  bool get unpublishInProgress => step > 0 && step < 10 && stepError.isEmpty;

  bool get processFinished => stepError.isNotEmpty || step >= 10;

  bool get canUnpublishWebsite => isControlsOk;
}
