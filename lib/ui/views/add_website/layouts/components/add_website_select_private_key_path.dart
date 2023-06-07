/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';
import 'dart:io';

import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/upload_file.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteSelectPrivateKeyPath extends ConsumerStatefulWidget {
  const AddWebsiteSelectPrivateKeyPath({
    super.key,
  });

  @override
  ConsumerState<AddWebsiteSelectPrivateKeyPath> createState() =>
      _AddWebsiteSelectPrivateKeyPathState();
}

class _AddWebsiteSelectPrivateKeyPathState
    extends ConsumerState<AddWebsiteSelectPrivateKeyPath>
    with FileMixin, SingleTickerProviderStateMixin {
  Future<void> _selectPrivateKeyFile() async {
    try {
      final addWebsiteNotifier =
          ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pem', 'key', 'txt'],
      );
      if (result != null && result.files.isNotEmpty) {
        if (kIsWeb) {
          addWebsiteNotifier
            ..setPrivateKeyPath(result.files.first.name)
            ..setPrivateKey(
              result.files.single.bytes,
            );
        } else {
          addWebsiteNotifier
            ..setPrivateKeyPath(result.files.single.path!)
            ..setPrivateKey(
              File(result.files.single.path!).readAsBytesSync(),
            );
        }
      }
    } on Exception catch (e) {
      log('Error while picking private key file: $e');
    }
  }

  Future<void> _resetPath() async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);
    // ignore: cascade_invocations
    addWebsiteNotifier
      ..setPrivateKeyPath('')
      ..setPrivateKey(null);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final addWebsiteProvider = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UploadFile(
          title: AppLocalizations.of(context)!.addWebsitePrivateKeyCertLabel,
          value: addWebsiteProvider.privateKeyPath,
          onTap: _selectPrivateKeyFile,
          onDelete: _resetPath,
          extensionsLabel: '(.pem, .key, .txt)',
          helpLink: 'https://wiki.archethic.net/participate/aeweb/dns/#ssl',
        ),
      ],
    );
  }
}
