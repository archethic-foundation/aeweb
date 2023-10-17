import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class IconCloseConnection extends ConsumerWidget {
  const IconCloseConnection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionNotifier = ref.watch(SessionProviders.session.notifier);

    return IconButtonAnimated(
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .connectionWalletDisconnectWarning,
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
                                AppButton(
                                  labelBtn: AppLocalizations.of(context)!.no,
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                AppButton(
                                  labelBtn: AppLocalizations.of(context)!.yes,
                                  onPressed: () async {
                                    await sessionNotifier.cancelConnection();
                                    context.go(RoutesPath().welcome());
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
      icon: const Icon(Icons.power_settings_new_rounded),
      color: Colors.red,
      tooltip: AppLocalizations.of(context)!.connectionWalletDisconnect,
    );
  }
}
