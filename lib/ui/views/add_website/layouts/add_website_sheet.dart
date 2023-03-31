/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_form_sheet.dart';
import 'package:aeweb/ui/views/util/components/stepper/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/stepper/bloc/state.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteSheet extends ConsumerWidget {
  const AddWebsiteSheet({
    super.key,
  });

  List<StepperData> getStepperDatas(BuildContext context) {
    return <StepperData>[
      StepperData(
        title: StepperText(
          'Creation of website in the keychain',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: StepperText("This step doesn't require any fees"),
      ),
      StepperData(
        title: StepperText(
          'Creation of transactions containing the content of the files',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      StepperData(
        title: StepperText(
          'Signature of transactions containing the content of the files',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: StepperText('Operation performed by the wallet'),
      ),
      StepperData(
        title: StepperText(
          'Creation of the reference transaction',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      StepperData(
        title: StepperText(
          'Signature of the reference transaction',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: StepperText('Operation performed by the wallet'),
      ),
      StepperData(
        title: StepperText(
          'Fees calculation',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      StepperData(
        title: StepperText(
          'Creation of the transfer transaction',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: StepperText('To manage fees from your current account'),
      ),
      StepperData(
        title: StepperText(
          'Signature of the transfer transaction',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: StepperText('Operation performed by the wallet'),
      ),
      StepperData(
        title: StepperText(
          'Send transactions to the blockchain',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      StepperData(
        title: StepperText(
          'Your website is deployed',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        AddWebsiteFormProvider.initialAddWebsiteForm.overrideWithValue(
          const AddWebsiteFormState(),
        ),
        AEStepperProvider.initialAEStepper.overrideWithValue(
          AEStepperState(
            stepperList: getStepperDatas(context),
            activeIndex: 0,
            axis: Axis.vertical,
          ),
        )
      ],
      child: const AddWebsiteSheetBody(),
    );
  }
}

class AddWebsiteSheetBody extends ConsumerWidget {
  const AddWebsiteSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddWebsiteFormState>(
      AddWebsiteFormProvider.addWebsiteForm,
      (_, addWebsite) {
        if (addWebsite.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addWebsite.errorText,
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );

        ref.read(AddWebsiteFormProvider.addWebsiteForm.notifier).setError(
              '',
            );
      },
    );

    return const AddWebsiteFormSheet();
  }
}
