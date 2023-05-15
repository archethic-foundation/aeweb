/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:developer';

import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_steps.dart';
import 'package:aeweb/ui/views/util/components/resizable_box.dart';
import 'package:aeweb/ui/views/util/components/upload_file.dart';
import 'package:aeweb/ui/views/util/generic/formatters.dart';
import 'package:aeweb/util/file_util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';

part 'add_website_bottom_bar.dart';
part 'add_website_select_path.dart';
part 'add_website_select_private_key_path.dart';
part 'add_website_select_public_cert_path.dart';
part 'add_website_select_zip_file.dart';
part 'add_website_switch_gitignore.dart';
part 'add_website_textfield_name.dart';

class AddWebsiteFormSheet extends ConsumerWidget {
  const AddWebsiteFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00000000),
                  const Color(0x00000000).withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Header(),
                Expanded(
                  child: ResizableBox(
                    width: MediaQuery.of(context).size.width - 100,
                    childLeft: Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                        left: 5,
                        right: 5,
                      ),
                      decoration: BoxDecoration(
                        border: const GradientBoxBorder(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x003C89B9),
                              Color(0xFFCC00FF),
                            ],
                            stops: [0, 1],
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.addWebSiteDesc,
                                style: textTheme.labelMedium,
                              ),
                              const SizedBox(height: 16),
                              const AddWebsiteTextFieldName(),
                              const SizedBox(height: 16),
                              if (kIsWeb)
                                const AddWebsiteSelectZipFile()
                              else
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
                    )
                        .animate()
                        .fade(duration: const Duration(milliseconds: 200))
                        .scale(duration: const Duration(milliseconds: 200)),
                    childRight: const AddWebsiteSteps()
                        .animate()
                        .fade(duration: const Duration(milliseconds: 250))
                        .scale(duration: const Duration(milliseconds: 250)),
                  ),
                ),
                const AddWebsiteBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
