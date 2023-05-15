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
        if (kIsWeb) {
          addWebsiteNotifier.setPublicCertPath(result.files.first.name);
        } else {
          addWebsiteNotifier.setPublicCertPath(result.files.single.path!);
        }

        addWebsiteNotifier.setPublicCert(result.files.first.bytes!);
      }
    } on Exception catch (e) {
      log('Error while picking public cert file: $e');
    }
  }

  Future<void> _resetPath() async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);
    // ignore: cascade_invocations
    addWebsiteNotifier.setPublicCertPath('');
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final addWebsiteProvider = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        UploadFile(
          title: AppLocalizations.of(context)!.addWebsitePublicCertPathLabel,
          value: addWebsiteProvider.publicCertPath,
          onTap: _selectPublicCertFile,
          onDelete: _resetPath,
          helpLink: 'https://wiki.archethic.net/participate/aeweb/dns/#ssl',
        ),
      ],
    );
  }
}
