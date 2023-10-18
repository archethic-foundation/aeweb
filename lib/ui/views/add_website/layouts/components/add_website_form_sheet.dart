import 'dart:math' as math;

import 'package:aeweb/ui/utils/components/main_screen_background.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_select_path.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_select_private_key_path.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_select_public_cert_path.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_select_zip_file.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_switch_gitignore.dart';
import 'package:aeweb/ui/views/add_website/layouts/components/add_website_textfield_name.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:aeweb/ui/views/util/warning_size_label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddWebsiteFormSheet extends ConsumerWidget {
  const AddWebsiteFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Stack(
      children: [
        const MainScreenBackground(),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.addWebSiteDesc,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.warning_2,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      AppLocalizations.of(context)!.disclaimer,
                      style: textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.addWebSiteDisclaimer,
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Transform.rotate(
                        angle: -math.pi,
                        child: Container(
                          width: 50,
                          height: 1,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x003C89B9),
                                Color(0xFFCC00FF),
                              ],
                              stops: [0, 1],
                              begin: AlignmentDirectional.centerEnd,
                              end: AlignmentDirectional.centerStart,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SelectionArea(
                        child: Text(
                          AppLocalizations.of(context)!
                              .addWebSiteFormRequiredInfo,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 50,
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x003C89B9),
                              Color(0xFFCC00FF),
                            ],
                            stops: [0, 1],
                            begin: AlignmentDirectional.centerEnd,
                            end: AlignmentDirectional.centerStart,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const AddWebsiteTextFieldName(),
                const SizedBox(height: 16),
                if (kIsWeb)
                  const AddWebsiteSelectZipFile()
                else
                  const AddWebsiteSelectPath(),
                const SizedBox(height: 16),
                const WarningSizeLabel(),
                const SizedBox(height: 16),
                const AddWebsiteSwitchGitignore(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Transform.rotate(
                        angle: -math.pi,
                        child: Container(
                          width: 50,
                          height: 1,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x003C89B9),
                                Color(0xFFCC00FF),
                              ],
                              stops: [0, 1],
                              begin: AlignmentDirectional.centerEnd,
                              end: AlignmentDirectional.centerStart,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: SelectionArea(
                        child: Text(
                          AppLocalizations.of(context)!
                              .addWebSiteFormOptionalInfo,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 50,
                        height: 1,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x003C89B9),
                              Color(0xFFCC00FF),
                            ],
                            stops: [0, 1],
                            begin: AlignmentDirectional.centerEnd,
                            end: AlignmentDirectional.centerStart,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const AddWebsiteSelectPublicCertPath(),
                const SizedBox(height: 16),
                const AddWebsiteSelectPrivateKeyPath(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
