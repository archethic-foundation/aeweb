/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

class PopupCloseButton extends StatelessWidget {
  const PopupCloseButton({
    super.key,
    this.warningCloseLabel = '',
    this.warningCloseFunction,
    this.warningCloseWarning = false,
  });

  final bool warningCloseWarning;
  final String warningCloseLabel;
  final Function? warningCloseFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () async {
          if (warningCloseWarning == false) {
            if (warningCloseFunction != null) {
              await warningCloseFunction!();
            }
            if (!context.mounted) return;
            Navigator.of(context).pop();
            return;
          }

          return showDialog(
            context: context,
            builder: (context) {
              return ScaffoldMessenger(
                child: Builder(
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          aedappfm.AppThemeBase.backgroundPopupColor,
                      contentPadding: const EdgeInsets.only(
                        top: 10,
                      ),
                      content: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
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
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                warningCloseLabel,
                                style: Theme.of(context).textTheme.bodyMedium,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
                                  ),
                                  aedappfm.AppButton(
                                    labelBtn: AppLocalizations.of(context)!.yes,
                                    onPressed: () async {
                                      if (warningCloseFunction != null) {
                                        await warningCloseFunction!();
                                      }

                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
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
        child: CircleAvatar(
          radius: 20,
          backgroundColor: aedappfm.AppThemeBase.backgroundPopupColor,
          child: const CircleAvatar(
            foregroundColor: Colors.white,
            radius: 12,
            child: aedappfm.IconAnimated(
              color: Colors.white,
              icon: Icons.close,
            ),
          ),
        ),
      ),
    );
  }
}
