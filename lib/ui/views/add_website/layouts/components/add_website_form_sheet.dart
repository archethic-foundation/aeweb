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
import 'package:gradient_borders/gradient_borders.dart';

class AddWebsiteFormSheet extends ConsumerWidget {
  const AddWebsiteFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Container(
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
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SelectionArea(
                      child: Text(
                        AppLocalizations.of(context)!.addWebSiteFormTitle,
                        style: Theme.of(context).textTheme.titleSmall,
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
              Text(
                AppLocalizations.of(context)!.addWebSiteDesc,
                style: textTheme.labelMedium,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(
                    Iconsax.warning_2,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context)!.disclaimer,
                    style: textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.addWebSiteDisclaimer,
                style: textTheme.labelMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SelectionArea(
                      child: Text(
                        AppLocalizations.of(context)!
                            .addWebSiteFormRequiredInfo,
                        style: Theme.of(context).textTheme.titleSmall,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SelectionArea(
                      child: Text(
                        AppLocalizations.of(context)!
                            .addWebSiteFormOptionalInfo,
                        style: Theme.of(context).textTheme.titleSmall,
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
    );
  }
}
