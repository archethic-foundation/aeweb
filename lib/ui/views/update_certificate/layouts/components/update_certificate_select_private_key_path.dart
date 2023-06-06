/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';
import 'dart:io';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/upload_file.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateSelectPrivateKeyPath extends ConsumerStatefulWidget {
  const UpdateCertificateSelectPrivateKeyPath({
    super.key,
  });

  @override
  ConsumerState<UpdateCertificateSelectPrivateKeyPath> createState() =>
      _UpdateCertificateSelectPrivateKeyPathState();
}

class _UpdateCertificateSelectPrivateKeyPathState
    extends ConsumerState<UpdateCertificateSelectPrivateKeyPath>
    with FileMixin, SingleTickerProviderStateMixin {
  Future<void> _selectPrivateKeyFile() async {
    try {
      final updateCertificateNotifier = ref
          .watch(UpdateCertificateFormProvider.updateCertificateForm.notifier);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pem', 'key', 'txt'],
      );
      if (result != null && result.files.isNotEmpty) {
        if (kIsWeb) {
          updateCertificateNotifier
            ..setPrivateKeyPath(result.files.first.name)
            ..setPrivateKey(
              File.fromRawPath(result.files.single.bytes!).readAsBytesSync(),
            );
        } else {
          updateCertificateNotifier
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
    final updateCertificateNotifier =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm.notifier);
    // ignore: cascade_invocations
    updateCertificateNotifier
      ..setPrivateKeyPath('')
      ..setPrivateKey(null);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final updateCertificateNotifier =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UploadFile(
          title: AppLocalizations.of(context)!
              .updateCertificatePrivateKeyCertLabel,
          value: updateCertificateNotifier.privateKeyPath,
          onTap: _selectPrivateKeyFile,
          onDelete: _resetPath,
          extensionsLabel: '(.pem, .key, .txt)',
          helpLink: 'https://wiki.archethic.net/participate/aeweb/dns/#ssl',
        ),
      ],
    );
  }
}
