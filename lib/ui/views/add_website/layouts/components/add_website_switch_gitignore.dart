/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteSwitchGitignore extends ConsumerStatefulWidget {
  const AddWebsiteSwitchGitignore({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteSwitchGitignore> createState() =>
      _AddWebsiteSwitchGitignoreState();
}

class _AddWebsiteSwitchGitignoreState
    extends ConsumerState<AddWebsiteSwitchGitignore> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);
    final addWebsiteProvider = ref.watch(AddWebsiteFormProvider.addWebsiteForm);
    final thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.addWebsiteGitignoreLabel,
              style: textTheme.labelMedium,
            ),
            const SizedBox(width: 2),
            SizedBox(
              height: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  thumbIcon: thumbIcon,
                  value: addWebsiteProvider.applyGitIgnoreRules ?? false,
                  onChanged: addWebsiteProvider.applyGitIgnoreRules == null
                      ? null
                      : addWebsiteNotifier.setApplyGitIgnoreRules,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
