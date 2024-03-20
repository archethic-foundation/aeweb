import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarMenuLinks extends ConsumerWidget {
  const AppBarMenuLinks({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuAnchor(
      style: MenuStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(top: 20, right: 20),
        ),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      alignmentOffset: const Offset(0, 2),
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(aedappfm.Iconsax.element_3),
        );
      },
      menuChildren: [
        MenuItemButton(
          requestFocusOnHover: false,
          child: SizedBox(
            height: 100,
            child: aedappfm.SingleCard(
              globalPadding: 0,
              cardContent: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .archethicDashboardMenuWalletOnWayItem,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        AppLocalizations.of(context)!
                            .archethicDashboardMenuWalletOnWayDesc,
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onPressed: () {
            launchUrl(
              Uri.parse(
                'https://www.archethic.net/wallet',
              ),
            );
          },
        ),
      ],
    );
  }
}
