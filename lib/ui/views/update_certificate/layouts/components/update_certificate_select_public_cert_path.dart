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

class UpdateCertificateSelectPublicCertPath extends ConsumerStatefulWidget {
  const UpdateCertificateSelectPublicCertPath({
    super.key,
  });

  @override
  ConsumerState<UpdateCertificateSelectPublicCertPath> createState() =>
      _UpdateCertificateSelectPublicCertPathState();
}

class _UpdateCertificateSelectPublicCertPathState
    extends ConsumerState<UpdateCertificateSelectPublicCertPath>
    with FileMixin {
  Future<void> _selectPublicCertFile() async {
    try {
      final updateCertificateNotifier = ref
          .watch(UpdateCertificateFormProvider.updateCertificateForm.notifier);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pem', 'crt', 'txt'],
      );
      if (result != null && result.files.isNotEmpty) {
        if (kIsWeb) {
          updateCertificateNotifier
            ..setPublicCertPath(result.files.first.name)
            ..setPublicCert(
              result.files.single.bytes,
            );
        } else {
          updateCertificateNotifier
            ..setPublicCertPath(result.files.single.path!)
            ..setPublicCert(
              File(result.files.single.path!).readAsBytesSync(),
            );
        }
      }
    } on Exception catch (e) {
      log('Error while picking public cert file: $e');
    }
  }

  Future<void> _resetPath() async {
    final updateCertificateNotifier =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm.notifier);
    // ignore: cascade_invocations
    updateCertificateNotifier
      ..setPublicCertPath('')
      ..setPublicCert(null);
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
        const SizedBox(width: 10),
        UploadFile(
          title: AppLocalizations.of(context)!
              .updateCertificatePublicCertPathLabel,
          value: updateCertificateNotifier.publicCertPath,
          onTap: _selectPublicCertFile,
          onDelete: _resetPath,
          extensionsLabel: '(.pem, .crt, .txt)',
          helpLink: 'https://wiki.archethic.net/participate/aeweb/dns/#ssl',
        ),
      ],
    );
  }
}
