/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class UnpublishWebsiteBottomBar extends ConsumerWidget {
  const UnpublishWebsiteBottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unpublishWebsite =
        ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm);

    Future<bool> _submitForm() async {
      return true;
    }

    final session = ref.watch(SessionProviders.session);

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
      child: Row(
        children: [
          if (unpublishWebsite.unpublishInProgress)
            AppButton(
              labelBtn: AppLocalizations.of(context)!.btn_cancel,
              icon: Iconsax.close_square,
              disabled: true,
            )
          else if (unpublishWebsite.processFinished)
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
          if (session.isConnected)
            if (unpublishWebsite.unpublishInProgress)
              AppButton(
                labelBtn: AppLocalizations.of(context)!.btn_unpublish_website,
                icon: Iconsax.folder_cross,
                disabled: true,
              )
            else
              AppButton(
                labelBtn: AppLocalizations.of(context)!.btn_unpublish_website,
                icon: Iconsax.folder_cross,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          AppButton(
                                            labelBtn:
                                                AppLocalizations.of(context)!
                                                    .no,
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          AppButton(
                                            labelBtn:
                                                AppLocalizations.of(context)!
                                                    .yes,
                                            onPressed: () async {
                                              final ctlOk = await _submitForm();
                                              if (ctlOk) {
                                                Navigator.of(context).pop();
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
                                            },
                                          )
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
              )
        ],
      ),
    );
  }
}
