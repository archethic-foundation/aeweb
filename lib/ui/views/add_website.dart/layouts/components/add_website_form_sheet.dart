/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';

import 'package:aeweb/ui/views/add_website.dart/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/ae_stepper.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'add_website_textfield_name.dart';
part 'add_website_select_path.dart';
part 'add_website_select_public_cert_path.dart';
part 'add_website_select_private_key_path.dart';
part 'add_website_switch_gitignore.dart';

class AddWebsiteFormSheet extends ConsumerStatefulWidget {
  const AddWebsiteFormSheet({super.key});

  @override
  AddWebsiteFormSheetState createState() => AddWebsiteFormSheetState();
}

class AddWebsiteFormSheetState extends ConsumerState<AddWebsiteFormSheet>
    with FileMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final websiteNameTextController = TextEditingController(
    text: '',
  );

  @override
  void dispose() {
    websiteNameTextController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final addWebsiteNotifier =
        ref.watch(AddWebsiteFormProvider.addWebsiteForm.notifier);

    final isNameOk = addWebsiteNotifier.controlName(context);
    final isPathOk = addWebsiteNotifier.controlPath(context);

    if (isNameOk && isPathOk) {
      addWebsiteNotifier.create(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Host a new website on Archethic Blockchain'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Form(
          key: _formKey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const AddWebsiteTextFieldName(),
                        const SizedBox(height: 16),
                        const AddWebsiteSelectPath(),
                        const SizedBox(height: 16),
                        const AddWebsiteSwitchGitignore(),
                        const SizedBox(height: 16),
                        const AddWebsiteSelectPublicCertPath(),
                        const SizedBox(height: 16),
                        const AddWebsiteSelectPrivateKeyPath(),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Create website',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.go('/');
                          },
                          child: Text(
                            'Back',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 50),
              const AEStepper(),
            ],
          ),
        ),
      ),
    );
  }
}
