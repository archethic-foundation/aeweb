/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/state.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_form_sheet.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncSheet extends ConsumerWidget {
  const UpdateWebsiteSyncSheet({
    super.key,
    required this.websiteName,
    required this.genesisAddress,
    required this.path,
    required this.zipFile,
    required this.localFiles,
    required this.comparedFiles,
  });

  final String websiteName;
  final String genesisAddress;
  final String path;
  final Uint8List zipFile;
  final Map<String, HostingRefContentMetaData> localFiles;
  final List<HostingContentComparison> comparedFiles;

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
            zipFile: zipFile,
            localFiles: localFiles,
            comparedFiles: comparedFiles,
          ),
        ),
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
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              updateWebsiteSync.errorText,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.ok,
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
