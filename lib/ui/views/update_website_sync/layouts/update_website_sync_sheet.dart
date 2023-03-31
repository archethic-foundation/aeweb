/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/state.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_form_sheet.dart';
import 'package:aeweb/ui/views/util/components/stepper/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/stepper/bloc/state.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncSheet extends ConsumerWidget {
  const UpdateWebsiteSyncSheet({
    super.key,
    required this.websiteName,
    required this.genesisAddress,
    required this.path,
    required this.localFiles,
    required this.comparedFiles,
  });

  final String websiteName;
  final String genesisAddress;
  final String path;
  final Map<String, HostingRefContentMetaData> localFiles;
  final List<HostingContentComparison> comparedFiles;

  List<StepperData> getStepperDatas(BuildContext context) {
    return <StepperData>[
      StepperData(
        title: StepperText(
          'Creation of transactions containing the content of the files updated',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      StepperData(
        title: StepperText(
          'Signature of transactions containing the content of the files updated',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        subtitle: StepperText('Operation performed by the wallet'),
      ),
      StepperData(
        title: StepperText(
          'Creation of the new reference transaction',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
      StepperData(
        title: StepperText(
          'Signature of the new reference transaction',
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
          'Your website is updated',
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        UpdateWebsiteSyncFormProvider.initialUpdateWebsiteSyncForm
            .overrideWithValue(
          UpdateWebsiteSyncFormState(
            name: websiteName,
            genesisAddress: genesisAddress,
            path: path,
            localFiles: localFiles,
            comparedFiles: comparedFiles,
          ),
        ),
        AEStepperProvider.initialAEStepper.overrideWithValue(
          AEStepperState(
            stepperList: getStepperDatas(context),
            activeIndex: 0,
            axis: Axis.vertical,
          ),
        )
      ],
      child: const UpdateWebsiteSyncSheetBody(),
    );
  }
}

class UpdateWebsiteSyncSheetBody extends ConsumerWidget {
  const UpdateWebsiteSyncSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UpdateWebsiteSyncFormState>(
      UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm,
      (_, updateWebsiteSync) {
        if (updateWebsiteSync.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              updateWebsiteSync.errorText,
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );

        ref
            .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
            .setError(
              '',
            );
      },
    );

    return const UpdateWebsiteSyncFormSheet();
  }
}
