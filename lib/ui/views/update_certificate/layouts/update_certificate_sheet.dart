/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:async';

import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/state.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_form_sheet.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_in_progress_popup.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateSheet extends ConsumerStatefulWidget {
  const UpdateCertificateSheet({
    super.key,
    required this.websiteName,
  });

  final String websiteName;

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
      appBar: AppBar(
        title: Center(
          child: Text(
            AppLocalizations.of(context)!.updateCertificateFormTitle,
          ),
        ),
        actions: const [
          ConnectionToWalletStatus(),
          SizedBox(
            width: 10,
          ),
        ],
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
                Iconsax.security_safe,
              ),
              label: Text(
                AppLocalizations.of(context)!.btn_add_certificate,
              ),
            )
          : null,
    );
  }
}
