/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class UpdateCertificateBottomBar extends ConsumerWidget {
  const UpdateCertificateBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
      child: Row(
        children: [
          if (updateCertificate.creationInProgress)
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_cancel,
              icon: Iconsax.close_square,
              disabled: true,
            )
          else if (updateCertificate.processFinished)
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_close,
              icon: Iconsax.close_square,
              onPressed: () {
                context.go('/');
              },
            )
          else
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_cancel,
              icon: Iconsax.close_square,
              onPressed: () {
                context.go('/');
              },
            ),
          if (updateCertificate.creationInProgress)
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_add_certificate,
              icon: Iconsax.security_safe,
              disabled: true,
            )
          else
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_add_certificate,
              icon: Iconsax.security_safe,
              onPressed: () async {
                final ctlOk = await _submitForm();
                if (ctlOk) {
                  final updateCertificateNotifier = ref.watch(
                    UpdateCertificateFormProvider
                        .updateCertificateForm.notifier,
                  );

                  await updateCertificateNotifier.updateCertificate(
                    context,
                    ref,
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
