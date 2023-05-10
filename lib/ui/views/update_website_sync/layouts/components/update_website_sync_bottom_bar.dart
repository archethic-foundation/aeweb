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
                    children: const [
                      Icon(
                        Icons.arrow_back_ios_new,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Back',
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    if (updateWebsiteSync.updateInProgress == false) {
                      context.go('/');
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back_ios_new,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Back',
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
                  child: Text(
                    'Update website',
                    style: Theme.of(context).textTheme.labelLarge,
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
                  child: Text(
                    'Update website',
                    style: Theme.of(context).textTheme.labelLarge,
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
