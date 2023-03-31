/// SPDX-License-Identifier: AGPL-3.0-or-later
part of 'add_website_form_sheet.dart';

class AddWebsiteSelectPublicCertPath extends ConsumerStatefulWidget {
  const AddWebsiteSelectPublicCertPath({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteSelectPublicCertPath> createState() =>
      _AddWebsiteSelectPublicCertPathState();
}

class _AddWebsiteSelectPublicCertPathState
    extends ConsumerState<AddWebsiteSelectPublicCertPath> with FileMixin {
  Future<void> _selectPublicCertFile() async {
    try {
      final addWebsiteNotifier =
          ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pem', 'crt'],
      );
      if (result != null) {
        addWebsiteNotifier.setPublicCertPath(result.files.single.path!);
      }
    } on Exception catch (e) {
      log('Error while picking public cert file: $e');
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
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.addWebsitePublicCertPathLabel,
            ),
            const SizedBox(width: 2),
            TextButton(
              onPressed: _selectPublicCertFile,
              child: const Icon(Icons.upload_file),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(addWebsiteProvider.publicCertPath),
      ],
    );
  }
}
