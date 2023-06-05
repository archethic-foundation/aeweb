import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:iconsax/iconsax.dart';

class ContentWebsiteWarningPopup {
  static Future<bool?> getDialog(
    BuildContext context,
    String header,
    String text,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.only(
                        top: 10,
                      ),
                      content: Container(
                        color: Colors.transparent,
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    SelectionArea(
                                      child: Text(
                                        header,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Container(
                                        width: 25,
                                        height: 1,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0x003C89B9),
                                              Color(0xFFCC00FF),
                                            ],
                                            stops: [0, 1],
                                            begin:
                                                AlignmentDirectional.centerEnd,
                                            end: AlignmentDirectional
                                                .centerStart,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Wrap(
                                  children: [
                                    Text(
                                      text,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
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
                                      AppButton(
                                        labelBtn: AppLocalizations.of(context)!
                                            .btn_decline,
                                        icon: Iconsax.close_square,
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                      ),
                                      AppButton(
                                        labelBtn: AppLocalizations.of(context)!
                                            .btn_accept,
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
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
