/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';
import 'dart:ui';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/state.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_form_sheet.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_in_progress_popup.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateSheet extends ConsumerStatefulWidget {
  const UpdateCertificateSheet({
    super.key,
    required this.websiteName,
  });

  final String websiteName;

  static const routerPage = '/updatecertificate';

  @override
  ConsumerState<UpdateCertificateSheet> createState() =>
      _UpdateCertificateSheetState();
}

class _UpdateCertificateSheetState
    extends ConsumerState<UpdateCertificateSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(UpdateCertificateFormProvider.updateCertificateForm.notifier)
          .setName(widget.websiteName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);
    final updateCertificate =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm);

    Future<bool> _submitForm() async {
      final updateCertificateNotifier = ref
          .watch(UpdateCertificateFormProvider.updateCertificateForm.notifier)
        ..setControlInProgress(true);
      final isCertOk = updateCertificateNotifier.controlCert(context);
      updateCertificateNotifier.setControlInProgress(false);
      return isCertOk;
    }

    ref.listen<UpdateCertificateFormState>(
      UpdateCertificateFormProvider.updateCertificateForm,
      (_, updateCertificate) {
        if (updateCertificate.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              updateCertificate.errorText,
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
            .read(UpdateCertificateFormProvider.updateCertificateForm.notifier)
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
                  AppLocalizations.of(context)!.updateCertificateFormTitle,
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
      body: const UpdateCertificateFormSheet(),
      floatingActionButton: session.isConnected
          ? FloatingActionButton.extended(
              onPressed: updateCertificate.creationInProgress
                  ? null
                  : () async {
                      final ctlOk = await _submitForm();
                      if (ctlOk) {
                        final updateCertificateNotifier = ref.watch(
                          UpdateCertificateFormProvider
                              .updateCertificateForm.notifier,
                        );

                        unawaited(
                          updateCertificateNotifier.updateCertificate(
                            context,
                            ref,
                          ),
                        );

                        if (!context.mounted) return;

                        await UpdateCertificateInProgressPopup.getDialog(
                          context,
                          ref,
                        );
                      }
                    },
              icon: const Icon(
                aedappfm.Iconsax.security_safe,
              ),
              label: Text(
                AppLocalizations.of(context)!.btn_add_certificate,
              ),
            )
          : null,
    );
  }
}
