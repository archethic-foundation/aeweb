/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/domain/usecases/website/unpublish_website.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/components/unpublish_website_circular_step_progress_indicator.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/countdown.dart';
import 'package:aeweb/ui/views/util/components/in_progress_banner.dart';
import 'package:aeweb/ui/views/util/components/popup_close_button.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UnpublishWebsiteInProgressPopup {
  static Future<void> getDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    Widget _userConfirmStep(
      BuildContext context,
      WidgetRef ref,
      String text,
    ) {
      final textTheme = Theme.of(context)
          .textTheme
          .apply(displayColor: Theme.of(context).colorScheme.onSurface);

      final unpublishWebsite =
          ref.watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm);

      return Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.addWebSiteConfirmedStep10.replaceAll(
                  '%1',
                  unpublishWebsite.globalFeesUCO.toStringAsFixed(2),
                )} (=${unpublishWebsite.globalFeesFiat.toStringAsFixed(2)}\$)',
            style: textTheme.bodyMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: textTheme.bodyMedium,
              ),
              const SizedBox(
                width: 10,
              ),
              const Countdown(),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () async {
                  ref
                      .read(
                        UnpublishWebsiteFormProvider
                            .unpublishWebsiteForm.notifier,
                      )
                      .setGlobalFeesValidated(false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.close_square,
                      size: 11,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.no,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              AppButton(
                onPressed: () async {
                  ref
                      .read(
                        UnpublishWebsiteFormProvider
                            .unpublishWebsiteForm.notifier,
                      )
                      .setGlobalFeesValidated(true);
                },
                labelBtn: AppLocalizations.of(context)!.yes,
                icon: Iconsax.tick_square,
              ),
            ],
          ),
        ],
      );
    }

    return showDialog<void>(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Consumer(
                builder: (context, ref, _) {
                  final unpublishWebsite = ref
                      .watch(UnpublishWebsiteFormProvider.unpublishWebsiteForm);

                  return Scaffold(
                    backgroundColor: Colors.transparent.withAlpha(120),
                    body: AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: Stack(
                        children: <Widget>[
                          ArchethicScrollbar(
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 30,
                                right: 15,
                                left: 8,
                              ),
                              padding: const EdgeInsets.all(20),
                              height: 300,
                              width: AeWebThemeBase.sizeBoxComponentWidth,
                              decoration: BoxDecoration(
                                color: AeWebThemeBase.backgroundPopupColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const UnpublishWebsiteCircularStepProgressIndicator(),
                                  InProgressBanner(
                                    stepLabel:
                                        UnpublishWebsiteUseCases().getStepLabel(
                                      context,
                                      unpublishWebsite.step,
                                    ),
                                    infoMessage: UnpublishWebsiteUseCases()
                                        .getConfirmLabel(
                                      context,
                                      unpublishWebsite.step,
                                    ),
                                    errorMessage: unpublishWebsite.stepError,
                                  ),
                                  if (unpublishWebsite.stepError.isEmpty &&
                                      unpublishWebsite.step == 8 &&
                                      unpublishWebsite.globalFeesValidated ==
                                          null)
                                    _userConfirmStep(
                                      context,
                                      ref,
                                      AppLocalizations.of(context)!
                                          .unpublishWebSiteConfirmStep8,
                                    ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: PopupCloseButton(
                              warningCloseWarning:
                                  unpublishWebsite.unpublishInProgress,
                              warningCloseLabel: unpublishWebsite
                                          .unpublishInProgress ==
                                      true
                                  ? AppLocalizations.of(context)!
                                      .unpublishWebsiteProcessInterruptionWarning
                                  : '',
                              warningCloseFunction: () async {
                                ref.invalidate(
                                  WebsitesProviders.fetchWebsiteVersions,
                                );

                                ref
                                    .watch(
                                      UnpublishWebsiteFormProvider
                                          .unpublishWebsiteForm.notifier,
                                    )
                                    .resetStep();

                                if (unpublishWebsite.unpublishInProgress ==
                                        false &&
                                    unpublishWebsite.processFinished) {
                                  context.pop(); // go to main screen
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
