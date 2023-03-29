import 'package:aeweb/ui/views/util/components/stepper/bloc/provider.dart';
import 'package:aeweb/ui/views/util/scrollbar.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AEStepper extends ConsumerWidget {
  const AEStepper({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aeStepperProvider = ref.watch(AEStepperProvider.aeStepper);
    if (aeStepperProvider.stepperList.isEmpty) {
      return const SizedBox();
    }
    return Expanded(
      child: ArchethicScrollbar(
        child: AnotherStepper(
          stepperList: aeStepperProvider.stepperList,
          activeIndex: aeStepperProvider.activeIndex,
          verticalGap: 10,
          stepperDirection: aeStepperProvider.axis!,
          iconWidth: 40,
          iconHeight: 40,
        ),
      ),
    );
  }
}
