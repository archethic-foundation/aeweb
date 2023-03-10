/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/action.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_pool.freezed.dart';

@freezed
class ActionPool with _$ActionPool {
  const factory ActionPool({
    required List<Action> actions,
  }) = _ActionPool;
}
