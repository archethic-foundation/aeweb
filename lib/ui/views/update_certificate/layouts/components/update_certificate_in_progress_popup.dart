/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/website_versions.dart';
import 'package:aeweb/domain/usecases/update_certificate.usecase.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/countdown.dart';
import 'package:aeweb/ui/views/util/components/in_progress_banner.dart';
import 'package:aeweb/ui/views/util/components/popup_close_button.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateCertificateInProgressPopup {
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

      final updateCertificate =
          ref.watch(UpdateCertificateFormProvider.updateCertificateForm);

      return Column(
        children: [
          Text(
            '${AppLocalizations.of(context)!.addWebSiteConfirmedStep10.replaceAll(
                  '%1',
                  updateCertificate.globalFeesUCO.toStringAsFixed(2),
                )} (=${updateCertificate.globalFeesFiat.toStringAsFixed(2)}\$)',
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
                        UpdateCertificateFormProvider
                            .updateCertificateForm.notifier,
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
                        UpdateCertificateFormProvider
                            .updateCertificateForm.notifier,
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
                  final updateCertificate = ref.watch(
                    UpdateCertificateFormProvider.updateCertificateForm,
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
                                          currentStep: updateCertificate.step,
                                          totalSteps: 10,
                                          isProcessInProgress: updateCertificate
                                              .creationInProgress,
                                          failure: updateCertificate.failure,
                                        ),
                                        InProgressBanner(
                                          stepLabel: UpdateCertificateUseCase()
                                              .getStepLabel(
                                            context,
                                            updateCertificate.step,
                                          ),
                                          infoMessage:
                                              UpdateCertificateUseCase()
                                                  .getConfirmLabel(
                                            context,
                                            updateCertificate.step,
                                          ),
                                          errorMessage:
                                              updateCertificate.stepError,
                                        ),
                                        if (updateCertificate
                                                .stepError.isEmpty &&
                                            updateCertificate.step == 8 &&
                                            updateCertificate
                                                    .globalFeesValidated ==
                                                null)
                                          _userConfirmStep(
                                            context,
                                            ref,
                                            AppLocalizations.of(context)!
                                                .updateCertificateConfirmStep8,
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
                                  updateCertificate.creationInProgress,
                              warningCloseLabel: updateCertificate
                                          .creationInProgress ==
                                      true
                                  ? AppLocalizations.of(context)!
                                      .updateCertificateProcessInterruptionWarning
                                  : '',
                              warningCloseFunction: () async {
                                ref.invalidate(
                                  WebsiteVersionProviders.fetchWebsiteVersions,
                                );

                                ref
                                    .watch(
                                      UpdateCertificateFormProvider
                                          .updateCertificateForm.notifier,
                                    )
                                    .resetStep();

                                if (updateCertificate.creationInProgress ==
                                        false &&
                                    updateCertificate.processFinished) {
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
