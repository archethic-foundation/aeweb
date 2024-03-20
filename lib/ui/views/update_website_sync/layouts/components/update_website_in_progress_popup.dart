/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/website_versions.dart';
import 'package:aeweb/domain/usecases/update_website_sync.usecase.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/countdown.dart';
import 'package:aeweb/ui/views/util/components/in_progress_banner.dart';
import 'package:aeweb/ui/views/util/components/popup_close_button.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateWebsiteInProgressPopup {
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

      final updateWebsiteSync =
          ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);

      return Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.addWebSiteConfirmedStep10.replaceAll(
                  '%1',
                  updateWebsiteSync.globalFeesUCO.toStringAsFixed(2),
                )} (=${updateWebsiteSync.globalFeesFiat.toStringAsFixed(2)}\$)',
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
                        UpdateWebsiteSyncFormProvider
                            .updateWebsiteSyncForm.notifier,
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
                        UpdateWebsiteSyncFormProvider
                            .updateWebsiteSyncForm.notifier,
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
                  final updateWebsiteSync = ref.watch(
                    UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm,
                  );

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
                              width:
                                  aedappfm.AppThemeBase.sizeBoxComponentWidth,
                              decoration: BoxDecoration(
                                color:
                                    aedappfm.AppThemeBase.backgroundPopupColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 200,
                                    ),
                                    child: Card(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: aedappfm.PopupWaves(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        aedappfm
                                            .InProgressCircularStepProgressIndicator(
                                          currentStep: updateWebsiteSync.step,
                                          totalSteps: 13,
                                          isProcessInProgress: updateWebsiteSync
                                              .updateInProgress,
                                          failure: updateWebsiteSync.failure,
                                        ),
                                        InProgressBanner(
                                          stepLabel: UpdateWebsiteSyncUseCase()
                                              .getStepLabel(
                                            context,
                                            updateWebsiteSync.step,
                                          ),
                                          infoMessage:
                                              UpdateWebsiteSyncUseCase()
                                                  .getConfirmLabel(
                                            context,
                                            updateWebsiteSync.step,
                                          ),
                                          errorMessage:
                                              updateWebsiteSync.stepError,
                                        ),
                                        if (updateWebsiteSync
                                                .stepError.isEmpty &&
                                            updateWebsiteSync.step == 11 &&
                                            updateWebsiteSync
                                                    .globalFeesValidated ==
                                                null)
                                          _userConfirmStep(
                                            context,
                                            ref,
                                            AppLocalizations.of(context)!
                                                .updateWebSiteConfirmStep11,
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
                                  updateWebsiteSync.updateInProgress,
                              warningCloseLabel: updateWebsiteSync
                                          .updateInProgress ==
                                      true
                                  ? AppLocalizations.of(context)!
                                      .updateWebsiteProcessInterruptionWarning
                                  : '',
                              warningCloseFunction: () async {
                                ref.invalidate(
                                  WebsiteVersionProviders.fetchWebsiteVersions,
                                );

                                ref
                                    .watch(
                                      UpdateWebsiteSyncFormProvider
                                          .updateWebsiteSyncForm.notifier,
                                    )
                                    .resetStep();

                                if (updateWebsiteSync.updateInProgress ==
                                        false &&
                                    updateWebsiteSync.processFinished) {
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
