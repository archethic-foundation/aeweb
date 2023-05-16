/// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/state.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/components/unpublish_website_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UnpublishWebsiteSheet extends ConsumerWidget {
  const UnpublishWebsiteSheet({
    required this.websiteName,
    super.key,
  });

  final String websiteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        UnpublishWebsiteFormProvider.initialUnpublishWebsiteForm
            .overrideWithValue(
          UnpublishWebsiteFormState(
            name: websiteName,
          ),
        ),
      ],
      child: const UnpublishWebsiteSheetBody(),
    );
  }
}

class UnpublishWebsiteSheetBody extends ConsumerWidget {
  const UnpublishWebsiteSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<UnpublishWebsiteFormState>(
      UnpublishWebsiteFormProvider.unpublishWebsiteForm,
      (_, unpublishWebsite) {
        if (unpublishWebsite.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              unpublishWebsite.errorText,
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

    return const UnpublishebsiteFormSheet();
  }
}