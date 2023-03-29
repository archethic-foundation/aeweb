/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'add_website_form_sheet.dart';

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
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);
    final addWebsiteProvider = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.addWebsiteGitignoreLabel,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            Switch(
              value: addWebsiteProvider.applyGitIgnoreRules ?? false,
              onChanged: addWebsiteProvider.applyGitIgnoreRules == null
                  ? null
                  : addWebsiteNotifier.setApplyGitIgnoreRules,
            ),
          ],
        ),
      ],
    );
  }
}
