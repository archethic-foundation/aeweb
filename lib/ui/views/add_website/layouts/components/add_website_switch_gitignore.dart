/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context)!.addWebsiteGitignoreLabel,
                style: textTheme.bodyMedium,
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Container(
                  padding: const EdgeInsets.only(left: 2),
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
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: aedappfm.IconButtonAnimated(
                  icon: Icon(
                    Icons.help,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    launchUrl(
                      Uri.parse(
                        'https://wiki.archethic.net/FAQ/aeweb#what-is-the-purpose-of-a-gitignore-file',
                      ),
                    );
                  },
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
