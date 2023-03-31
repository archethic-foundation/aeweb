/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class AddWebsiteFormState with _$AddWebsiteFormState {
  const factory AddWebsiteFormState({
    @Default(0) int addWebsiteProcessStep,
    @Default('') String name,
    @Default('') String path,
    @Default('') String publicCertPath,
    @Default('') String privateKeyPath,
    bool? applyGitIgnoreRules,
    @Default('') String errorText,
  }) = _AddWebsiteFormState;
  const AddWebsiteFormState._();

  bool get isControlsOk => errorText == '';

  bool get canAddWebsite => isControlsOk;
}
