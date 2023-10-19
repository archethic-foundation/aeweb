/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/state.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateSheet extends ConsumerWidget {
  const UpdateCertificateSheet({
    super.key,
    required this.websiteName,
  });

  final String websiteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        UpdateCertificateFormProvider.initialUpdateCertificateForm
            .overrideWithValue(
          UpdateCertificateFormState(
            name: websiteName,
          ),
        ),
      ],
      child: const UpdateCertificateSheetBody(),
    );
  }
}

class UpdateCertificateSheetBody extends ConsumerWidget {
  const UpdateCertificateSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    );
  }
}
