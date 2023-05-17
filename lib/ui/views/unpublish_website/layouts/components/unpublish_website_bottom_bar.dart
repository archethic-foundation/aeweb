/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'unpublish_website_form_sheet.dart';

class UnpublishWebsiteBottomBar extends ConsumerWidget {
  const UnpublishWebsiteBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpublishWebsite =
        ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm);

    Future<bool> _submitForm() async {
      final unpublishWebsiteNotifier =
          ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm.notifier);

      return true;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
      child: Row(
        children: [
          Row(
            children: [
              if (unpublishWebsite.unpublishInProgress)
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
              else if (unpublishWebsite.processFinished)
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
              if (unpublishWebsite.unpublishInProgress)
                ElevatedButton(
                  onPressed: null,
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.folder_cross,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_unpublish_website,
                      ),
                    ],
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () async {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return ScaffoldMessenger(
                          child: Builder(
                            builder: (context) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.only(
                                  top: 10,
                                ),
                                content: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .confirmationPopupTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .unplublishWebsiteWarning,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(
                                          bottom: 20,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .no,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final ctlOk =
                                                    await _submitForm();
                                                if (ctlOk) {
                                                  final unpublishWebsiteNotifier =
                                                      ref.watch(
                                                    UnpublishWebsiteFormProvider
                                                        .unpublishWebsiteForm
                                                        .notifier,
                                                  );

                                                  await unpublishWebsiteNotifier
                                                      .unpublishWebsite(
                                                    context,
                                                    ref,
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.folder_cross,
                        size: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        AppLocalizations.of(context)!.btn_unpublish_website,
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
