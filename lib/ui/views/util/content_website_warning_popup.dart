import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

class ContentWebsiteWarningPopup {
  static Future<bool?> getDialog(
    BuildContext context,
    String header,
    String text,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return aedappfm.PopupTemplate(
          popupContent: aedappfm.ArchethicScrollbar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Wrap(
                  children: [
                    Text(
                      text,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              aedappfm.Iconsax.close_square,
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.btn_decline,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                      aedappfm.AppButton(
                        labelBtn: AppLocalizations.of(context)!.btn_accept,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          popupTitle: header,
          popupHeight: 400,
        );
      },
    );
  }
}
