/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/util/components/icon_button_animated.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadFile extends ConsumerWidget {
  const UploadFile({
    required this.title,
    this.value,
    required this.onTap,
    required this.onDelete,
    this.helpLink,
    super.key,
  });

  final Function() onTap;
  final Function() onDelete;
  final String title;
  final String? value;
  final String? helpLink;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: textTheme.labelMedium,
            ),
            if (helpLink != null)
              IconButtonAnimated(
                icon: const Icon(Icons.help),
                onPressed: () {
                  launchUrl(
                    Uri.parse(
                      helpLink!,
                    ),
                  );
                },
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
          ],
        ),
        if (helpLink == null) const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [10, 4],
            strokeCap: StrokeCap.round,
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Container(
              width: 200,
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(1),
                    Theme.of(context).colorScheme.background.withOpacity(0.3),
                  ],
                  stops: const [0, 1],
                ),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.background.withOpacity(0.5),
                      Theme.of(context).colorScheme.background.withOpacity(0.7),
                    ],
                    stops: const [0, 1],
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Iconsax.folder_open,
                    size: 40,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    AppLocalizations.of(context)!.uploadFileSelect,
                    style: textTheme.labelSmall!
                        .copyWith(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (value != null && value!.isNotEmpty)
          Row(
            children: [
              Text(
                value!,
                style:
                    textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w300),
              ),
              IconButtonAnimated(
                color: Theme.of(context).colorScheme.primary,
                onPressed: onDelete,
                icon: const Icon(
                  Iconsax.trash4,
                  size: 14,
                ),
              )
            ],
          ),
      ],
    );
  }
}