/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/websites.dart';
import 'package:aeweb/domain/usecases/website/update_certificate.dart';
import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_circular_step_progress_indicator.dart';
import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/countdown.dart';
import 'package:aeweb/ui/views/util/components/popup_close_button.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateInProgressPopup {
  static Future<void> getDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    Widget _confirmedStep(
      BuildContext context,
      String text, {
      IconData icon = Iconsax.tick_circle,
    }) {
      final textTheme = Theme.of(context)
          .textTheme
          .apply(displayColor: Theme.of(context).colorScheme.onSurface);
      return SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              icon,
              color: Colors.green,
              size: 14,
            ),
          ],
        ),
      );
    }

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
          _confirmedStep(
            context,
            '${AppLocalizations.of(context)!.updateCertificateConfirmedStep7.replaceAll(
                  '%1',
                  updateCertificate.globalFeesUCO.toStringAsFixed(8),
                )} (=${updateCertificate.globalFeesFiat.toStringAsFixed(2)}\$)',
            icon: Iconsax.calculator,
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
                        UpdateCertificateFormProvider
                            .updateCertificateForm.notifier,
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
                  final updateCertificate = ref.watch(
                      UpdateCertificateFormProvider.updateCertificateForm);

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
                                  const UpdateCertificateCircularStepProgressIndicator(),
                                  if (updateCertificate.stepError.isEmpty)
                                    Container(
                                      alignment: Alignment.center,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        UpdateCertificateUseCases()
                                            .getStepLabel(
                                          context,
                                          updateCertificate.step,
                                        ),
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    )
                                  else
                                    Container(
                                      alignment: Alignment.center,
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        updateCertificate.stepError,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  if (updateCertificate.stepError.isEmpty &&
                                      updateCertificate.step == 8 &&
                                      updateCertificate.globalFeesValidated ==
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
                                  WebsitesProviders.fetchWebsiteVersions,
                                );
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