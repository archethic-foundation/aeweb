import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class UpdateWebsiteSyncBottomBar extends ConsumerWidget {
  const UpdateWebsiteSyncBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateWebsiteSync =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
      child: Row(
        children: [
          Row(
            children: [
              if (updateWebsiteSync.updateInProgress)
                AppButton(
                  labelBtn: AppLocalizations.of(context)!.btn_cancel,
                  icon: Iconsax.close_square,
                )
              else if (updateWebsiteSync.processFinished)
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
              if (updateWebsiteSync.updateInProgress)
                AppButton(
                  labelBtn: AppLocalizations.of(context)!.btn_update_website,
                  icon: Iconsax.global_edit,
                )
              else
                AppButton(
                  labelBtn: AppLocalizations.of(context)!.btn_update_website,
                  icon: Iconsax.global_edit,
                  onPressed: () async {
                    final updateWebsiteSyncNotifier = ref.watch(
                      UpdateWebsiteSyncFormProvider
                          .updateWebsiteSyncForm.notifier,
                    );
                    await updateWebsiteSyncNotifier.update(context, ref);
                  },
                )
            ],
          ),
        ],
      ),
    );
  }
}
