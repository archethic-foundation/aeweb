/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:ui';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/state.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/components/unpublish_website_form_sheet.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/components/unpublish_website_in_progress_popup.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnpublishWebsiteSheet extends ConsumerStatefulWidget {
  const UnpublishWebsiteSheet({
    super.key,
    required this.websiteName,
  });

  final String websiteName;

  static const routerPage = '/unpublishwebsite';

  @override
  ConsumerState<UnpublishWebsiteSheet> createState() =>
      _UnpublishWebsiteSheetState();
}

class _UnpublishWebsiteSheetState extends ConsumerState<UnpublishWebsiteSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm.notifier)
          .setName(widget.websiteName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);
    final unpublishWebsite =
        ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm);

    Future<bool> _submitForm() async {
      return true;
    }

    ref.listen<UnpublishWebsiteFormState>(
      UnpublishWebsiteFormProvider.unpublishWebsiteForm,
      (_, unpublishWebsite) {
        if (unpublishWebsite.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              unpublishWebsite.errorText,
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
            .read(UnpublishWebsiteFormProvider.unpublishWebsiteForm.notifier)
            .setError(
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
                    color:
                        aedappfm.ArchethicThemeBase.neutral0.withOpacity(0.2),
                    height: 1,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  AppLocalizations.of(context)!.unpublishWebSiteFormTitle,
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
      body: const UnpublishWebsiteFormSheet(),
      floatingActionButton: session.isConnected
          ? FloatingActionButton.extended(
              onPressed: unpublishWebsite.unpublishInProgress
                  ? null
                  : () async {
                      final ctlOk = await _submitForm();
                      if (ctlOk) {
                        final unpublishWebsiteNotifier = ref.watch(
                          UnpublishWebsiteFormProvider
                              .unpublishWebsiteForm.notifier,
                        );

                        unawaited(
                          unpublishWebsiteNotifier.unpublishWebsite(
                            context,
                            ref,
                          ),
                        );

                        if (!context.mounted) return;

                        await UnpublishWebsiteInProgressPopup.getDialog(
                          context,
                          ref,
                        );
                      }
                    },
              icon: const Icon(
                aedappfm.Iconsax.folder_cross,
              ),
              label: Text(
                AppLocalizations.of(context)!.btn_unpublish_website,
              ),
            )
          : null,
    );
  }
}
