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
                    context.go('/');
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
              if (addWebsite.creationInProgress)
                ElevatedButton(
                  onPressed: null,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Create website',
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
                    children: const [
                      Icon(
                        Icons.add,
                        size: 12,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Create website',
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
