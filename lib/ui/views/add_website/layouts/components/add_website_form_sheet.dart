/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';

import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_steps.dart';
import 'package:aeweb/ui/views/util/components/resizable_box.dart';
import 'package:aeweb/ui/views/util/formatters.dart';
import 'package:aeweb/ui/views/util/upload_file.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'add_website_bottom_bar.dart';
part 'add_website_select_path.dart';
part 'add_website_select_private_key_path.dart';
part 'add_website_select_public_cert_path.dart';
part 'add_website_switch_gitignore.dart';
part 'add_website_textfield_name.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Header(),
            Expanded(
              child: ResizableBox(
                width: MediaQuery.of(context).size.width - 100,
                childLeft: Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      20,
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ready to experience the future of decentralized ownership?\nDeploy your website on AEWeb and enjoy the benefits of 100% security, tamperproof technology, and optimized scalability.',
                              style: textTheme.labelMedium,
                            ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                childRight: Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: const AddWebsiteSteps(),
                  ),
                ),
              ),
            ),
            const AddWebsiteBottomBar(),
          ],
        ),
      ),
    );
  }
}
