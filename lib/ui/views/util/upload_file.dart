/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class UploadFile extends ConsumerWidget {
  const UploadFile({
    required this.title,
    this.value,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final Function() onTap;
  final Function() onDelete;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final _colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelMedium,
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onTap,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [10, 4],
            strokeCap: StrokeCap.round,
            color: _colorScheme.primaryContainer,
            child: Container(
              width: 200,
              height: 130,
              decoration: BoxDecoration(
                color: _colorScheme.primaryContainer.withOpacity(.3),
                borderRadius: BorderRadius.circular(10),
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
                    'Select your file',
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
              IconButton(
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
