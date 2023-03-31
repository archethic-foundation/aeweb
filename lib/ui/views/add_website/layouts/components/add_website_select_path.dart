/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'add_website_form_sheet.dart';

class AddWebsiteSelectPath extends ConsumerStatefulWidget {
  const AddWebsiteSelectPath({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteSelectPath> createState() =>
      _AddWebsiteSelectPathState();
}

class _AddWebsiteSelectPathState extends ConsumerState<AddWebsiteSelectPath>
    with FileMixin {
  Future<void> _selectFilePath() async {
    try {
      final addWebsiteNotifier =
          ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

      final result = await FilePicker.platform.getDirectoryPath();
      final gitIgnoreExist = await isGitignoreExist(path: '$result/');
      if (result != null) {
        setState(() {
          addWebsiteNotifier
            ..setPath('$result/')
            ..setApplyGitIgnoreRules(gitIgnoreExist == false ? null : true);
          log('ApplyGitIgnoreRules ($result/): $gitIgnoreExist');
        });
      }
    } on Exception catch (e) {
      log('Error while picking folder: $e');
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final addWebsiteProvider = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: _selectFilePath,
          icon: const Icon(Icons.folder),
          label: Text(
            AppLocalizations.of(context)!.addWebsitePathLabel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Text(addWebsiteProvider.path),
      ],
    );
  }
}
