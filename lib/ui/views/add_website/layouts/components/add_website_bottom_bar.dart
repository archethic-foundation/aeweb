/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'add_website_form_sheet.dart';

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
          Row(
            children: [
              if (addWebsite.creationInProgress)
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
              if (addWebsite.creationInProgress)
                ElevatedButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.global,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_add_website,
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () async {
                    final ctlOk = await _submitForm();
                    if (ctlOk) {
                      final addWebsiteNotifier = ref.watch(
                        AddWebsiteFormProvider.addWebsiteForm.notifier,
                      );

                      await addWebsiteNotifier.addWebsite(context, ref);
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.global,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_add_website,
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
