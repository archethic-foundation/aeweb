/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/domain/usecases/website/unpublish_website.usecase.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/unpublish_website/bloc/provider.dart';
import 'package:aeweb/ui/views/unpublish_website/layouts/components/unpublish_website_circular_step_progress_indicator.dart';
import 'package:aeweb/ui/views/util/components/countdown.dart';
import 'package:aeweb/ui/views/util/components/in_progress_banner.dart';
import 'package:aeweb/ui/views/util/components/popup_close_button.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
                      aedappfm.Iconsax.close_square,
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
              aedappfm.AppButton(
                onPressed: () async {
                  ref
                      .read(
                        UnpublishWebsiteFormProvider
                            .unpublishWebsiteForm.notifier,
                      )
                      .setGlobalFeesValidated(true);
                },
                labelBtn: AppLocalizations.of(context)!.yes,
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
                          aedappfm.ArchethicScrollbar(
                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 30,
                                right: 15,
                                left: 8,
                              ),
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
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 200,
                                    ),
                                    child: Card(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: EdgeInsets.zero,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: WaveWidget(
                                        config: CustomConfig(
                                          gradients: [
                                            [
                                              ArchethicThemeBase.blue800
                                                  .withOpacity(0.1),
                                              ArchethicThemeBase.purple800
                                                  .withOpacity(0.1),
                                            ],
                                            [
                                              ArchethicThemeBase.blue500
                                                  .withOpacity(0.1),
                                              ArchethicThemeBase.purple500
                                                  .withOpacity(0.1),
                                            ],
                                            [
                                              ArchethicThemeBase.blue300
                                                  .withOpacity(0.1),
                                              ArchethicThemeBase.purple300
                                                  .withOpacity(0.1),
                                            ],
                                            [
                                              ArchethicThemeBase.blue200
                                                  .withOpacity(0.1),
                                              ArchethicThemeBase.purple200
                                                  .withOpacity(0.1),
                                            ]
                                          ],
                                          durations: [
                                            35000,
                                            19440,
                                            10800,
                                            6000,
                                          ],
                                          heightPercentages: [
                                            0.20,
                                            0.23,
                                            0.25,
                                            0.30,
                                          ],
                                          gradientBegin: Alignment.bottomLeft,
                                          gradientEnd: Alignment.topRight,
                                        ),
                                        size: Size.infinite,
                                        waveAmplitude: 0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const UnpublishWebsiteCircularStepProgressIndicator(),
                                        InProgressBanner(
                                          stepLabel: UnpublishWebsiteUseCase()
                                              .getStepLabel(
                                            context,
                                            unpublishWebsite.step,
                                          ),
                                          infoMessage: UnpublishWebsiteUseCase()
                                              .getConfirmLabel(
                                            context,
                                            unpublishWebsite.step,
                                          ),
                                          errorMessage:
                                              unpublishWebsite.stepError,
                                        ),
                                        if (unpublishWebsite
                                                .stepError.isEmpty &&
                                            unpublishWebsite.step == 8 &&
                                            unpublishWebsite
                                                    .globalFeesValidated ==
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
