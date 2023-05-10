/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/add_website/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                  'Création du site dans votre porte-clés en cours.\nVeuillez confirmer dans votre wallet Archethic pour confirmer la création.',
                ),
              if (addWebsite.step > 1)
                _confirmedStep(
                  context,
                  'Site créé en tant que nouveau service dans votre porte-clés',
                ),
              if (addWebsite.step == 2)
                _waitingStep(
                  context,
                  ref,
                  'Récupération des fichiers en cours.',
                ),
              if (addWebsite.step > 2)
                _confirmedStep(
                  context,
                  'Fichiers récupérés',
                ),
              if (addWebsite.step == 3)
                _waitingStep(
                  context,
                  ref,
                  'Création des transactions avec le contenu des fichiers du site en cours.',
                ),
              if (addWebsite.step > 3)
                _confirmedStep(
                  context,
                  'Transactions avec le contenu des fichiers du site créées',
                ),
              if (addWebsite.step == 4)
                _waitingStep(
                  context,
                  ref,
                  'Signature des transactions en cours.\nVeuillez confirmer dans votre wallet Archethic pour les signer.',
                ),
              if (addWebsite.step > 4)
                _confirmedStep(
                  context,
                  'Transactions avec le contenu des fichiers du site signées',
                  icon: Iconsax.path,
                ),
              if (addWebsite.step == 5)
                _waitingStep(
                  context,
                  ref,
                  'Création de la transaction de référence listant les fichiers du site en cours.',
                ),
              if (addWebsite.step > 5)
                _confirmedStep(
                  context,
                  'Transaction de référence créée',
                ),
              if (addWebsite.step == 6)
                _waitingStep(
                  context,
                  ref,
                  'Signature de la transaction de référence en cours.\nVeuillez confirmer dans votre wallet Archethic pour la signer.',
                ),
              if (addWebsite.step > 6)
                _confirmedStep(
                  context,
                  'Transaction de référence signée',
                  icon: Iconsax.path,
                ),
              if (addWebsite.step == 7)
                _waitingStep(
                  context,
                  ref,
                  'Calcul des frais pour provisionner les chaînes de transaction contenant le site en cours.',
                ),
              if (addWebsite.step > 7)
                _confirmedStep(
                  context,
                  'Frais pour provisionner les chaînes de transaction contenant le site calculés',
                  icon: Iconsax.calculator,
                ),
              if (addWebsite.step == 8)
                _waitingStep(
                  context,
                  ref,
                  'Création de la transaction de transfert de fonds pour provisionner les chaînes de transactions contenant le site en cours.',
                ),
              if (addWebsite.step > 8)
                _confirmedStep(
                  context,
                  'Transaction de transfert de fonds pour provisionner les chaînes de transactions créée',
                ),
              if (addWebsite.step == 9)
                _waitingStep(
                  context,
                  ref,
                  'Signature de la transaction de transfert de fonds en cours.\nVeuillez confirmer dans votre wallet Archethic pour la signer.',
                ),
              if (addWebsite.step > 9)
                _confirmedStep(
                  context,
                  'Transaction de transfert de fonds pour provisionner les chaînes de transactions signée',
                  icon: Iconsax.path,
                ),
              if (addWebsite.step == 10)
                _waitingStep(
                  context,
                  ref,
                  'Calcul des frais globaux en cours',
                ),
              if (addWebsite.step > 10)
                _confirmedStep(
                  context,
                  'Frais globaux calculés: ${addWebsite.globalFees.toStringAsFixed(8)} UCO.',
                  icon: Iconsax.calculator,
                ),
              if (addWebsite.step == 11 &&
                  addWebsite.globalFeesValidated == null)
                _userConfirmStep(
                  context,
                  ref,
                  'Confirmez vous la création du site?',
                ),
              if (addWebsite.step == 12)
                _waitingStep(
                  context,
                  ref,
                  'Création du site sur la blockchain Archethic en cours.',
                ),
              if (addWebsite.step >= 13)
                _confirmedStep(
                  context,
                  'Le site a été déployé avec succès !',
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
