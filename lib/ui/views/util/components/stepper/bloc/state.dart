/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class AEStepperState with _$AEStepperState {
  const factory AEStepperState({
    @Default([]) List<StepperData> stepperList,
    @Default(0) int activeIndex,
    Axis? axis,
  }) = _AEStepperState;
  const AEStepperState._();
}
