import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class AddWebsiteBottomBar extends ConsumerWidget {
  const AddWebsiteBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addWebsite = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    Future<bool> _submitForm() async {
      final addWebsiteNotifier =
          ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

      final isNameOk = addWebsiteNotifier.controlName(context);
      final isPathOk = addWebsiteNotifier.controlPath(context);

      if (isNameOk && isPathOk) {
        return true;
      }
      return false;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
      child: Row(
        children: [
          if (addWebsite.creationInProgress)
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_cancel,
              icon: Iconsax.close_square,
            )
          else if (addWebsite.processFinished)
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
          if (addWebsite.creationInProgress)
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_add_website,
              icon: Iconsax.global,
            )
          else
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_add_website,
              icon: Iconsax.global,
              onPressed: () async {
                final ctlOk = await _submitForm();
                if (ctlOk) {
                  final addWebsiteNotifier = ref.watch(
                    AddWebsiteFormProvider.addWebsiteForm.notifier,
                  );

                  await addWebsiteNotifier.addWebsite(context, ref);
                }
              },
            ),
        ],
      ),
    );
  }
}
