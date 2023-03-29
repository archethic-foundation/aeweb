/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'add_website_form_sheet.dart';

class AddWebsiteSelectPrivateKeyPath extends ConsumerStatefulWidget {
  const AddWebsiteSelectPrivateKeyPath({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteSelectPrivateKeyPath> createState() =>
      _AddWebsiteSelectPrivateKeyPathState();
}

class _AddWebsiteSelectPrivateKeyPathState
    extends ConsumerState<AddWebsiteSelectPrivateKeyPath> with FileMixin {
  Future<void> _selectPrivateKeyFile() async {
    try {
      final addWebsiteNotifier =
          ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        addWebsiteNotifier.setPrivateKeyPath(result.files.single.path!);
      }
    } on Exception catch (e) {
      log('Error while picking private key file: $e');
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
          onPressed: _selectPrivateKeyFile,
          icon: const Icon(Icons.upload_file),
          label: Text(
            AppLocalizations.of(context)!.addWebsitePrivateKeyCertLabel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(height: 16),
        Text(addWebsiteProvider.privateKeyPath),
      ],
    );
  }
}
