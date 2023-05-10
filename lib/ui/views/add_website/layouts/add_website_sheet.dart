/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/add_website/bloc/state.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteSheet extends ConsumerWidget {
  const AddWebsiteSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        AddWebsiteFormProvider.initialAddWebsiteForm.overrideWithValue(
          const AddWebsiteFormState(),
        ),
      ],
      child: const AddWebsiteSheetBody(),
    );
  }
}

class AddWebsiteSheetBody extends ConsumerWidget {
  const AddWebsiteSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddWebsiteFormState>(
      AddWebsiteFormProvider.addWebsiteForm,
      (_, addWebsite) {
        if (addWebsite.isControlsOk) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              addWebsite.errorText,
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {},
            ),
          ),
        );

        ref.read(AddWebsiteFormProvider.addWebsiteForm.notifier).setError(
              '',
            );
      },
    );

    return const AddWebsiteFormSheet();
  }
}
