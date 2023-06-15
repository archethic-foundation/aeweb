/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/update_certificate/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:loading_indicator/loading_indicator.dart';

class UpdateCertificateSteps extends ConsumerWidget {
  const UpdateCertificateSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateCertificate =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm);

    return Container(
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
              Color(0xFFCC00FF),
              Color(0x003C89B9),
            ],
            stops: [0, 1],
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ArchethicScrollbar(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (updateCertificate.step == 1)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep1,
                  ),
                if (updateCertificate.step > 1)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep1,
                    icon: Iconsax.wallet_add,
                  ),
                if (updateCertificate.step == 2)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep2,
                  ),
                if (updateCertificate.step > 2)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep2,
                  ),
                if (updateCertificate.step == 3)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep3,
                  ),
                if (updateCertificate.step > 3)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep3,
                    icon: Iconsax.path,
                  ),
                if (updateCertificate.step == 4)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep4,
                  ),
                if (updateCertificate.step > 4)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep4,
                    icon: Iconsax.calculator,
                  ),
                if (updateCertificate.step == 5)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep5,
                  ),
                if (updateCertificate.step > 5)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep5,
                  ),
                if (updateCertificate.step == 6)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep6,
                  ),
                if (updateCertificate.step > 6)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep6,
                    icon: Iconsax.path,
                  ),
                if (updateCertificate.step == 7)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep7,
                  ),
                if (updateCertificate.step > 7)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep7
                        .replaceAll(
                          '%1',
                          updateCertificate.globalFees.toStringAsFixed(8),
                        ),
                    icon: Iconsax.calculator,
                  ),
                if (updateCertificate.step == 8 &&
                    updateCertificate.globalFeesValidated == null)
                  _userConfirmStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateConfirmStep8,
                  ),
                if (updateCertificate.step == 9)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateCertificateWaitingStep9,
                  ),
                if (updateCertificate.step >= 10)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateCertificateConfirmedStep10,
                    icon: Iconsax.security_safe,
                  ),
                if (updateCertificate.stepError.isNotEmpty)
                  _errorStep(
                    context,
                    updateCertificate.stepError,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _waitingStep(BuildContext context, WidgetRef ref, String text) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final updateCertificate =
        ref.watch(UpdateCertificateFormProvider.updateCertificateForm);
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Text(
              text,
              style: textTheme.labelMedium,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          if (updateCertificate.stepError.isEmpty)
            Flexible(
              child: SizedBox(
                width: 20,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballScale,
                  colors: [Theme.of(context).colorScheme.onSurface],
                  strokeWidth: 1,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

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
        children: [
          Text(
            text,
            style: textTheme.labelMedium,
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            icon,
            color: Colors.green,
            size: 14,
          )
        ],
      ),
    );
  }

  Widget _errorStep(
    BuildContext context,
    String text, {
    IconData icon = Iconsax.close_circle,
  }) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Text(
            text,
            style: textTheme.labelMedium,
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            icon,
            color: Colors.red,
            size: 14,
          )
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
    return SizedBox(
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: textTheme.labelMedium,
          ),
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 20,
                child: OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () async {
                    ref
                        .read(
                          UpdateCertificateFormProvider
                              .updateCertificateForm.notifier,
                        )
                        .setGlobalFeesValidated(true);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Iconsax.tick_square,
                        size: 11,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.yes,
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                height: 20,
                child: OutlinedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
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
                        style: textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
