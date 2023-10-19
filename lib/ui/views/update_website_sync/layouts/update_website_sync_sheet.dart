/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/domain/usecases/website/sync_website.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/state.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_in_progress_popup.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_comparison_list.dart';
import 'package:aeweb/ui/views/util/content_website_warning_popup.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:busy/packages/synchronized-3.0.1/src/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWebsiteSyncSheet extends ConsumerStatefulWidget {
  const UpdateWebsiteSyncSheet({
    super.key,
    required this.websiteName,
    required this.path,
    required this.zipFile,
    required this.localFiles,
    required this.comparedFiles,
  });

  final String websiteName;
  final String path;
  final Uint8List zipFile;
  final Map<String, HostingRefContentMetaData> localFiles;
  final List<HostingContentComparison> comparedFiles;

  @override
  ConsumerState<UpdateWebsiteSyncSheet> createState() =>
      _UpdateWebsiteSyncSheetState();
}

class _UpdateWebsiteSyncSheetState
    extends ConsumerState<UpdateWebsiteSyncSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          .setName(widget.websiteName);
      ref
          .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          .setPath(widget.path);
      ref
          .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          .setZipFile(widget.zipFile);
      ref
          .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          .setLocalFiles(widget.localFiles);
      ref
          .read(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm.notifier)
          .setComparedFiles(widget.comparedFiles);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);
    final updateWebsiteSync =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);

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

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.updateWebSiteFormTitle,
          ),
        ),
        actions: const [
          ConnectionToWalletStatus(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: const UpdateWebsiteSyncComparisonSheet(),
      floatingActionButton: session.isConnected
          ? FloatingActionButton.extended(
              onPressed: updateWebsiteSync.updateInProgress
                  ? null
                  : () async {
                      final acceptRules =
                          await ContentWebsiteWarningPopup.getDialog(
                        context,
                        AppLocalizations.of(context)!
                            .updateWebsiteContentWarningHeader,
                        AppLocalizations.of(context)!
                            .updateWebsiteContentWarningText,
                      );
                      if (acceptRules == null || acceptRules == false) {
                        return;
                      }
                      final updateWebsiteSyncNotifier = ref.watch(
                        UpdateWebsiteSyncFormProvider
                            .updateWebsiteSyncForm.notifier,
                      );

                      unawaited(
                        updateWebsiteSyncNotifier.update(context, ref),
                      );

                      if (!context.mounted) return;

                      await UpdateWebsiteInProgressPopup.getDialog(
                        context,
                        ref,
                      );
                    },
              icon: const Icon(
                Iconsax.refresh_25,
              ),
              label: Text(
                AppLocalizations.of(context)!.btn_update_website,
              ),
            )
          : null,
    );
  }
}
