/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action.freezed.dart';

enum ActionType {
  addService,
}

@freezed
class Action with _$Action {
  const factory Action({
    required ActionType type,
    required Map<String, Object> content,
  }) = _Action;
}
