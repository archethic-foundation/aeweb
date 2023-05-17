/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'update_website_sync_form_sheet.dart';

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
                ElevatedButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.close_square,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_cancel,
                      ),
                    ],
                  ),
                )
              else if (updateWebsiteSync.processFinished)
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.close_square,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_close,
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.close_square,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_cancel,
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
              if (updateWebsiteSync.updateInProgress)
                ElevatedButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.global_edit,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_update_website,
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () async {
                    final updateWebsiteSyncNotifier = ref.watch(
                      UpdateWebsiteSyncFormProvider
                          .updateWebsiteSyncForm.notifier,
                    );
                    await updateWebsiteSyncNotifier.update(context, ref);
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.global_edit,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_update_website,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
