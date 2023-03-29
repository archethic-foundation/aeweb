import 'package:aeweb/ui/views/util/components/stepper/bloc/state.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final _initialAEStepperProvider = Provider<AEStepperState>(
  (ref) {
    throw UnimplementedError();
  },
);

final _aeStepperProvider =
    NotifierProvider.autoDispose<AEStepperNotifier, AEStepperState>(
  () {
    return AEStepperNotifier();
  },
  dependencies: [
    AEStepperProvider.initialAEStepper,
  ],
);

class AEStepperNotifier extends AutoDisposeNotifier<AEStepperState> {
  AEStepperNotifier();

  @override
  AEStepperState build() => ref.watch(
        AEStepperProvider.initialAEStepper,
      );

  Future<void> setStepperList(
    List<StepperData> stepperList,
  ) async {
    state = state.copyWith(
      stepperList: stepperList,
    );
    return;
  }

  void setActiveIndex(
    int activeIndex,
  ) {
    state = state.copyWith(
      activeIndex: activeIndex,
    );
  }

  void setAxis(
    Axis axis,
  ) {
    state = state.copyWith(
      axis: axis,
    );
  }
}

abstract class AEStepperProvider {
  static final initialAEStepper = _initialAEStepperProvider;
  static final aeStepper = _aeStepperProvider;
}
