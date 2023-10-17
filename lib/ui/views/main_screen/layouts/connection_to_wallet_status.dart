/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/main_screen/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:aeweb/ui/views/util/router.dart';
import 'package:busy/busy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ConnectionToWalletStatus extends ConsumerStatefulWidget {
  const ConnectionToWalletStatus({
    super.key,
  });

  @override
  ConsumerState<ConnectionToWalletStatus> createState() =>
      _ConnectionToWalletStatusState();
}

class _ConnectionToWalletStatusState
    extends ConsumerState<ConnectionToWalletStatus> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(SessionProviders.session);

    if (session.oldNameAccount.isNotEmpty &&
        session.oldNameAccount != session.nameAccount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            content: Text(
              AppLocalizations.of(context)!.changeCurrentAccountWarning,
              style: Theme.of(context).snackBarTheme.contentTextStyle,
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(SessionProviders.session.notifier).setOldNameAccount();
      });
    }

    if (session.isConnected == false) {
      return IconButton(
        onPressed: () {
          startBusyContext(
            () async {
              final sessionNotifier =
                  ref.watch(SessionProviders.session.notifier);
              await sessionNotifier.connectToWallet();
              if (ref.read(SessionProviders.session).error.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor:
                        Theme.of(context).snackBarTheme.backgroundColor,
                    content: Text(
                      ref.read(SessionProviders.session).error,
                      style: Theme.of(context).snackBarTheme.contentTextStyle,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            isBusyValueChanged: (isBusy) async {
              ref.read(isLoadingMainScreenProvider.notifier).state = isBusy;
            },
          );
        },
        icon: const Icon(Iconsax.link),
      );
    }

    if (Responsive.isDesktop(context)) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: MenuAnchor(
          style: MenuStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          alignmentOffset: const Offset(0, 10),
          builder: (context, controller, child) {
            return FilledButton.tonal(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Iconsax.user,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      session.nameAccount,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      session.endpoint,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
          menuChildren: const [
            MenuConnectionToWalletStatus(),
          ],
        ),
      );
    }

    return MenuAnchor(
      style: MenuStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      alignmentOffset: const Offset(0, 10),
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(
            Iconsax.user,
            //size: 18,
          ),
        );
      },
      menuChildren: const [
        MenuConnectionToWalletStatus(),
      ],
    );
  }
}

class MenuConnectionToWalletStatus extends ConsumerWidget {
  const MenuConnectionToWalletStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(SessionProviders.session);
    final sessionNotifier = ref.watch(SessionProviders.session.notifier);

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Center(
                child: Text(
                  session.nameAccount,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Text(
                  session.endpoint,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        MenuItemButton(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                const Icon(
                  Iconsax.logout,
                  size: 16,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(AppLocalizations.of(context)!.logout),
              ],
            ),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return ScaffoldMessenger(
                  child: Builder(
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: AeWebThemeBase.backgroundPopupColor,
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
                                      labelBtn:
                                          AppLocalizations.of(context)!.no,
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    AppButton(
                                      labelBtn:
                                          AppLocalizations.of(context)!.yes,
                                      onPressed: () async {
                                        await sessionNotifier
                                            .cancelConnection();
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
        ),
      ],
    );
  }
}
