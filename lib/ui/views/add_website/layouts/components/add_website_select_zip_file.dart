/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';

import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/upload_file.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteSelectZipFile extends ConsumerStatefulWidget {
  const AddWebsiteSelectZipFile({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteSelectZipFile> createState() =>
      _AddWebsiteSelectZipFileState();
}

class _AddWebsiteSelectZipFileState
    extends ConsumerState<AddWebsiteSelectZipFile>
    with FileMixin, SingleTickerProviderStateMixin {
  Future<void> _selectZipFile() async {
    try {
      final addWebsiteNotifier =
          ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip', '7z', 'rar'],
      );
      if (result != null) {
        if (kIsWeb) {
          addWebsiteNotifier.setZipFilePath(result.files.first.name);
        } else {
          addWebsiteNotifier.setZipFilePath(result.files.single.path!);
        }

        addWebsiteNotifier.setZipFile(result.files.first.bytes!);
      }
    } on Exception catch (e) {
      log('Error while picking zip file: $e');
    }
  }

  Future<void> _resetPath() async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);
    // ignore: cascade_invocations
    addWebsiteNotifier.setZipFilePath('');
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final addWebsiteProvider = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    return Column(
      children: [
        UploadFile(
          title: AppLocalizations.of(context)!.addWebsiteZipLabel,
          value: addWebsiteProvider.zipFilePath,
          onTap: _selectZipFile,
          onDelete: _resetPath,
          extensionsLabel: '(.zip, .7z, .rar)',
        ),
      ],
    );
  }
}
