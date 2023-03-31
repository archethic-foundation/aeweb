/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class UpdateWebsiteSyncFormState with _$UpdateWebsiteSyncFormState {
  const factory UpdateWebsiteSyncFormState({
    @Default(0) int updateWebsiteSyncProcessStep,
    @Default('') String name,
    @Default('') String genesisAddress,
    @Default('') String path,
    @Default('') String publicCertPath,
    @Default('') String privateKeyPath,
    bool? applyGitIgnoreRules,
    @Default('') String errorText,
    @Default({}) Map<String, HostingRefContentMetaData> localFiles,
    @Default([]) List<HostingContentComparison> comparedFiles,
  }) = _UpdateWebsiteSyncFormState;
  const UpdateWebsiteSyncFormState._();

  bool get isControlsOk => errorText == '';

  bool get canUpdateWebsiteSync => isControlsOk;
}
