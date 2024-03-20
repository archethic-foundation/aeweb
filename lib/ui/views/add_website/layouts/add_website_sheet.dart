/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:ui';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/domain/repositories/features_flags.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_form_sheet.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_in_progress_popup.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/util/content_website_warning_popup.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: AppBar(
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: ArchethicThemeBase.neutral0.withOpacity(0.2),
                    height: 1,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.addWebSiteFormTitle,
                ),
                actions: const [
                  ConnectionToWalletStatus(),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
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

                        unawaited(
                          addWebsiteNotifier.addWebsite(context, ref),
                        );

                        if (!context.mounted) return;

                        await AddWebsiteInProgressPopup.getDialog(
                          context,
                          ref,
                        );
                      }
                    },
              icon: const Icon(
                aedappfm.Iconsax.global,
              ),
              label: Text(
                AppLocalizations.of(context)!.btn_add_website,
              ),
            )
          : null,
    );
  }
}
