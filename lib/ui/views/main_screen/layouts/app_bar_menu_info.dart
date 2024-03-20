/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:ui';

import 'package:aeweb/application/version.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarMenuInfo extends ConsumerStatefulWidget {
  const AppBarMenuInfo({
    super.key,
  });

  @override
  ConsumerState<AppBarMenuInfo> createState() => _AppBarMenuInfoState();
}

class _AppBarMenuInfoState extends ConsumerState<AppBarMenuInfo> {
  final thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      style: MenuStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.only(top: 20, right: 20),
        ),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
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
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: MenuItemButton(
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
                'https://github.com/archethic-foundation/aeweb',
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
    );
  }
}
