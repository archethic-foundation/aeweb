/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
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
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (updateWebsiteSync.step == 1)
                _waitingStep(
                  context,
                  ref,
                  'Récupération des informations sur la blockchain en cours',
                ),
              if (updateWebsiteSync.step > 1)
                _confirmedStep(
                  context,
                  'Informations récupérées sur la blockchain',
                ),
              if (updateWebsiteSync.step == 2)
                _waitingStep(
                  context,
                  ref,
                  'Analyse en cours des modifications à appliquer',
                ),
              if (updateWebsiteSync.step > 2)
                _confirmedStep(
                  context,
                  'Analyse effectuée',
                ),
              if (updateWebsiteSync.step == 3)
                _waitingStep(
                  context,
                  ref,
                  'Création des transactions avec le contenu des fichiers du site en cours.',
                ),
              if (updateWebsiteSync.step > 3)
                _confirmedStep(
                  context,
                  'Transactions avec le contenu des fichiers du site créées',
                ),
              if (updateWebsiteSync.step == 4)
                _waitingStep(
                  context,
                  ref,
                  'Signature des transactions en cours.\nVeuillez confirmer dans votre wallet Archethic pour les signer.',
                ),
              if (updateWebsiteSync.step > 4)
                _confirmedStep(
                  context,
                  'Transactions avec le contenu des fichiers du site signées',
                  icon: Iconsax.path,
                ),
              if (updateWebsiteSync.step == 5)
                _waitingStep(
                  context,
                  ref,
                  'Création de la transaction de référence listant les fichiers du site en cours.',
                ),
              if (updateWebsiteSync.step > 5)
                _confirmedStep(
                  context,
                  'Transaction de référence créée',
                ),
              if (updateWebsiteSync.step == 6)
                _waitingStep(
                  context,
                  ref,
                  'Signature de la transaction de référence en cours.\nVeuillez confirmer dans votre wallet Archethic pour la signer.',
                ),
              if (updateWebsiteSync.step > 6)
                _confirmedStep(
                  context,
                  'Transaction de référence signée',
                  icon: Iconsax.path,
                ),
              if (updateWebsiteSync.step == 7)
                _waitingStep(
                  context,
                  ref,
                  'Calcul des frais pour provisionner les chaînes de transaction contenant le site en cours.',
                ),
              if (updateWebsiteSync.step > 7)
                _confirmedStep(
                  context,
                  'Frais pour provisionner les chaînes de transaction contenant le site calculés',
                  icon: Iconsax.calculator,
                ),
              if (updateWebsiteSync.step == 8)
                _waitingStep(
                  context,
                  ref,
                  'Création de la transaction de transfert de fonds pour provisionner les chaînes de transactions contenant le site en cours.',
                ),
              if (updateWebsiteSync.step > 8)
                _confirmedStep(
                  context,
                  'Transaction de transfert de fonds pour provisionner les chaînes de transactions créée',
                ),
              if (updateWebsiteSync.step == 9)
                _waitingStep(
                  context,
                  ref,
                  'Signature de la transaction de transfert de fonds en cours.\nVeuillez confirmer dans votre wallet Archethic pour la signer.',
                ),
              if (updateWebsiteSync.step > 9)
                _confirmedStep(
                  context,
                  'Transaction de transfert de fonds pour provisionner les chaînes de transactions signée',
                  icon: Iconsax.path,
                ),
              if (updateWebsiteSync.step == 10)
                _waitingStep(
                  context,
                  ref,
                  'Calcul des frais globaux en cours',
                ),
              if (updateWebsiteSync.step > 10)
                _confirmedStep(
                  context,
                  'Frais globaux calculés: ${updateWebsiteSync.globalFees.toStringAsFixed(8)} UCO.',
                  icon: Iconsax.calculator,
                ),
              if (updateWebsiteSync.step == 11 &&
                  updateWebsiteSync.globalFeesValidated == null)
                _userConfirmStep(
                  context,
                  ref,
                  'Confirmez vous la mise à jour du site?',
                ),
              if (updateWebsiteSync.step == 12)
                _waitingStep(
                  context,
                  ref,
                  'Mise à jour du site sur la blockchain Archethic en cours.',
                ),
              if (updateWebsiteSync.step >= 13)
                _confirmedStep(
                  context,
                  'Le site a été mis à jour avec succès !',
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
                      Text('Oui', style: textTheme.labelSmall),
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
                      Text('No', style: textTheme.labelSmall),
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
