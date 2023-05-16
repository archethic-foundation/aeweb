/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AddWebsiteSteps extends ConsumerWidget {
  const AddWebsiteSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addWebsite = ref.watch(AddWebsiteFormProvider.addWebsiteForm);

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
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (addWebsite.step == 1)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep1,
                  ),
                if (addWebsite.step > 1)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep1,
                    icon: Iconsax.wallet_add,
                  ),
                if (addWebsite.step == 2)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep2,
                  ),
                if (addWebsite.step > 2)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep2,
                  ),
                if (addWebsite.step == 3)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep3,
                  ),
                if (addWebsite.step > 3)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep3,
                  ),
                if (addWebsite.step == 4)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep4,
                  ),
                if (addWebsite.step > 4)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep4,
                    icon: Iconsax.path,
                  ),
                if (addWebsite.step == 5)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep5,
                  ),
                if (addWebsite.step > 5)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep5,
                  ),
                if (addWebsite.step == 6)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep6,
                  ),
                if (addWebsite.step > 6)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep6,
                    icon: Iconsax.path,
                  ),
                if (addWebsite.step == 7)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep7,
                  ),
                if (addWebsite.step > 7)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep7,
                    icon: Iconsax.calculator,
                  ),
                if (addWebsite.step == 8)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep8,
                  ),
                if (addWebsite.step > 8)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep8,
                  ),
                if (addWebsite.step == 9)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep9,
                  ),
                if (addWebsite.step > 9)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep9,
                    icon: Iconsax.path,
                  ),
                if (addWebsite.step == 10)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep10,
                  ),
                if (addWebsite.step > 10)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .addWebSiteConfirmedStep10
                        .replaceAll(
                          '%1',
                          addWebsite.globalFees.toStringAsFixed(8),
                        ),
                    icon: Iconsax.calculator,
                  ),
                if (addWebsite.step == 11 &&
                    addWebsite.globalFeesValidated == null)
                  _userConfirmStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteConfirmStep11,
                  ),
                if (addWebsite.step == 12)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.addWebSiteWaitingStep12,
                  ),
                if (addWebsite.step >= 13)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.addWebSiteConfirmedStep12,
                    icon: Iconsax.global,
                  ),
                if (addWebsite.stepError.isNotEmpty)
                  _errorStep(
                    context,
                    addWebsite.stepError,
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
    final addWebsite = ref.watch(AddWebsiteFormProvider.addWebsiteForm);
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
          if (addWebsite.stepError.isEmpty)
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
                  onPressed: () async {
                    ref
                        .read(AddWebsiteFormProvider.addWebsiteForm.notifier)
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
                  onPressed: () async {
                    ref
                        .read(AddWebsiteFormProvider.addWebsiteForm.notifier)
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