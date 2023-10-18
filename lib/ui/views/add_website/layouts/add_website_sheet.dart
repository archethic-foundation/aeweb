/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_form_sheet.dart';
import 'package:aeweb/ui/views/util/content_website_warning_popup.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteSheet extends ConsumerWidget {
  const AddWebsiteSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(SessionProviders.session);
    final addWebsite = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    Future<bool> _submitForm() async {
      final addWebsiteNotifier = ref
          .watch(AddWebsiteFormProvider.addWebsiteForm.notifier)
        ..setControlInProgress(true);
      final isNameOk = addWebsiteNotifier.controlName(context);
      final isPathOk = addWebsiteNotifier.controlPath(context);
      final isCertOk = addWebsiteNotifier.controlCert(context);
      var isSiteSizeOk = true;
      if (FeatureFlags.websiteSizeLimit) {
        isSiteSizeOk =
            await addWebsiteNotifier.controlNbOfTransactionFiles(context);
      }
      addWebsiteNotifier.setControlInProgress(false);
      if (isNameOk && isPathOk && isCertOk && isSiteSizeOk) {
        final acceptRules = await ContentWebsiteWarningPopup.getDialog(
          context,
          AppLocalizations.of(context)!.addWebsiteContentWarningHeader,
          AppLocalizations.of(context)!.addWebsiteContentWarningText,
        );
        return acceptRules ?? false;
      }
      return false;
    }

    ref.listen<AddWebsiteFormState>(
      AddWebsiteFormProvider.addWebsiteForm,
      (_, addWebsite) {
        if (addWebsite.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              addWebsite.errorText,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.ok,
              onPressed: () {},
            ),
          ),
        );

        ref.read(AddWebsiteFormProvider.addWebsiteForm.notifier).setError(
              '',
            );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.addWebSiteFormTitle,
          ),
        ),
      ),
      body: const AddWebsiteFormSheet(),
      floatingActionButton: session.isConnected
          ? FloatingActionButton.extended(
              onPressed: addWebsite.creationInProgress
                  ? null
                  : () async {
                      final ctlOk = await _submitForm();
                      if (ctlOk) {
                        final addWebsiteNotifier = ref.watch(
                          AddWebsiteFormProvider.addWebsiteForm.notifier,
                        );

                        await addWebsiteNotifier.addWebsite(context, ref);
                      }
                    },
              icon: const Icon(
                Iconsax.global,
              ),
              label: Text(
                AppLocalizations.of(context)!.btn_add_website,
              ),
            )
          : null,
    );
  }
}
