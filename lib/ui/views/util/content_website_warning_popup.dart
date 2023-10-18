import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/popup_template.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
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
        return PopupTemplate(
          popupContent: ArchethicScrollbar(
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
                              Iconsax.close_square,
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
                      AppButton(
                        labelBtn: AppLocalizations.of(context)!.btn_accept,
                        icon: Iconsax.tick_square,
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
