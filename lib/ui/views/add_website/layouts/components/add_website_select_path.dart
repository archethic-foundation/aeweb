/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';

import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/upload_file.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        addWebsiteNotifier
          ..setPath('$result/')
          ..setApplyGitIgnoreRules(gitIgnoreExist == false ? null : true);
        log('ApplyGitIgnoreRules ($result/): $gitIgnoreExist');
      }
    } on Exception catch (e) {
      log('Error while picking folder: $e');
    }
  }

  Future<void> _resetPath() async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);
    // ignore: cascade_invocations
    addWebsiteNotifier
      ..setPath('')
      ..setApplyGitIgnoreRules(null);
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
          title: AppLocalizations.of(context)!.addWebsitePathLabel,
          value: addWebsiteProvider.path,
          onTap: _selectFilePath,
          onDelete: _resetPath,
        ),
      ],
    );
  }
}
