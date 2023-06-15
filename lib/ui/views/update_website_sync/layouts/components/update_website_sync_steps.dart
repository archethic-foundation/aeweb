/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:loading_indicator/loading_indicator.dart';

class UpdateWebsiteSyncSteps extends ConsumerWidget {
  const UpdateWebsiteSyncSteps({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateWebsiteSync =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);

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
                if (updateWebsiteSync.step == 1)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep1,
                  ),
                if (updateWebsiteSync.step > 1)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep1,
                  ),
                if (updateWebsiteSync.step == 2)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep2,
                  ),
                if (updateWebsiteSync.step > 2)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep2,
                    icon: Iconsax.filter_tick,
                  ),
                if (updateWebsiteSync.step == 3)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep3,
                  ),
                if (updateWebsiteSync.step > 3)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep3,
                  ),
                if (updateWebsiteSync.step == 4)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep4,
                  ),
                if (updateWebsiteSync.step > 4)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep4,
                    icon: Iconsax.path,
                  ),
                if (updateWebsiteSync.step == 5)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep5,
                  ),
                if (updateWebsiteSync.step > 5)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep5,
                  ),
                if (updateWebsiteSync.step == 6)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep6,
                  ),
                if (updateWebsiteSync.step > 6)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep6,
                    icon: Iconsax.path,
                  ),
                if (updateWebsiteSync.step == 7)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep7,
                  ),
                if (updateWebsiteSync.step > 7)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep7,
                    icon: Iconsax.calculator,
                  ),
                if (updateWebsiteSync.step == 8)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep8,
                  ),
                if (updateWebsiteSync.step > 8)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep8,
                  ),
                if (updateWebsiteSync.step == 9)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep9,
                  ),
                if (updateWebsiteSync.step > 9)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep9,
                    icon: Iconsax.path,
                  ),
                if (updateWebsiteSync.step == 10)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep10,
                  ),
                if (updateWebsiteSync.step > 10)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!
                        .updateWebSiteConfirmedStep10
                        .replaceAll(
                          '%1',
                          updateWebsiteSync.globalFees.toStringAsFixed(8),
                        ),
                    icon: Iconsax.calculator,
                  ),
                if (updateWebsiteSync.step == 11 &&
                    updateWebsiteSync.globalFeesValidated == null)
                  _userConfirmStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteConfirmStep11,
                  ),
                if (updateWebsiteSync.step == 12)
                  _waitingStep(
                    context,
                    ref,
                    AppLocalizations.of(context)!.updateWebSiteWaitingStep12,
                  ),
                if (updateWebsiteSync.step >= 13)
                  _confirmedStep(
                    context,
                    AppLocalizations.of(context)!.updateWebSiteConfirmedStep13,
                    icon: Iconsax.global,
                  ),
                if (updateWebsiteSync.stepError.isNotEmpty)
                  _errorStep(
                    context,
                    updateWebsiteSync.stepError,
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
    final updateWebsiteSync =
        ref.watch(UpdateWebsiteSyncFormProvider.updateWebsiteSyncForm);
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
          if (updateWebsiteSync.stepError.isEmpty)
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
                          UpdateWebsiteSyncFormProvider
                              .updateWebsiteSyncForm.notifier,
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
                          UpdateWebsiteSyncFormProvider
                              .updateWebsiteSyncForm.notifier,
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
