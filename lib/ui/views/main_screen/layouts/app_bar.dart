/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/version.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/main_screen/layouts/header.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarMainScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMainScreen({
    super.key,
    required this.onAEMenuTapped,
  });

  final Function() onAEMenuTapped;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Header(),
      leadingWidth: Responsive.isMobile(context) ? null : 150,
      actions: [
        if (Responsive.isDesktop(context) || Responsive.isTablet(context))
          const ConnectionToWalletStatus(),
        const SizedBox(
          width: 10,
        ),
        MenuAnchor(
          style: MenuStyle(
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
              icon: const Icon(Icons.info_outlined),
            );
          },
          menuChildren: [
            MenuItemButton(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.document_text,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppLocalizations.of(context)!.menu_documentation),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Iconsax.export_3,
                      size: 12,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://wiki.archethic.net',
                  ),
                );
              },
            ),
            MenuItemButton(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.code_circle,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppLocalizations.of(context)!.menu_sourceCode),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Iconsax.export_3,
                      size: 12,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://github.com/archethic-foundation/bridge',
                  ),
                );
              },
            ),
            MenuItemButton(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.message_question,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppLocalizations.of(context)!.menu_faq),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Iconsax.export_3,
                      size: 12,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://wiki.archethic.net/category/FAQ',
                  ),
                );
              },
            ),
            MenuItemButton(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.video_play,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppLocalizations.of(context)!.menu_tuto),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Iconsax.export_3,
                      size: 12,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://wiki.archethic.net',
                  ),
                );
              },
            ),
            MenuItemButton(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.reserve,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(AppLocalizations.of(context)!.menu_report_bug),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Iconsax.export_3,
                      size: 12,
                    ),
                  ],
                ),
              ),
              onPressed: () {
                launchUrl(
                  Uri.parse(
                    'https://github.com/archethic-foundation/aeweb/issues/new?assignees=&labels=bug&projects=&template=bug_report.yml',
                  ),
                );
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 12,
              ),
              child: Consumer(
                builder: (context, ref, child) {
                  final asyncVersionString = ref.watch(
                    versionStringProvider(
                      AppLocalizations.of(context)!,
                    ),
                  );
                  return Text(
                    asyncVersionString.asData?.value ?? '',
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        IconButton(
          icon: const Icon(Iconsax.element_3),
          onPressed: onAEMenuTapped,
        ),
        const SizedBox(
          width: 16,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
