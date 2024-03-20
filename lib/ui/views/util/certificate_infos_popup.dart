import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:aeweb/util/certificate_util.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:intl/intl.dart';

class CertificateInfosPopup with CertificateMixin {
  static Future<void> getDialog(
    BuildContext context,
    X509CertificateData? certificate,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return aedappfm.PopupTemplate(
          popupTitle: AppLocalizations.of(context)!.certificateInfosTitle,
          popupHeight: 400,
          popupContent: aedappfm.ArchethicScrollbar(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (certificate == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(aedappfm.Iconsax.warning_2),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .certificateInfosNoCertInstalled,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .certificateInfosSubjectTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      for (final property
                          in CertificateMixin.getCertificateProperties())
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              SelectableText(
                                property['label'] ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(width: 10),
                              SelectableText(
                                certificate.tbsCertificate!
                                        .subject[property['code']] ??
                                    AppLocalizations.of(
                                      context,
                                    )!
                                        .certificateInfosNotIncluded,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .certificateInfosIssuerTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      for (final property
                          in CertificateMixin.getCertificateProperties())
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              SelectableText(
                                property['label'] ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(width: 10),
                              SelectableText(
                                certificate.tbsCertificate!
                                        .issuer[property['code']] ??
                                    AppLocalizations.of(
                                      context,
                                    )!
                                        .certificateInfosNotIncluded,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .certificateInfosValidityTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            SelectableText(
                              AppLocalizations.of(context)!
                                  .certificateInfosValidityStart,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SelectableText(
                              DateFormat.yMMMEd(
                                Localizations.localeOf(context).languageCode,
                              ).add_Hms().format(
                                    certificate
                                        .tbsCertificate!.validity.notBefore,
                                  ),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            SelectableText(
                              AppLocalizations.of(context)!
                                  .certificateInfosValidityEnd,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            SelectableText(
                              DateFormat.yMMMEd(
                                Localizations.localeOf(context).languageCode,
                              ).add_Hms().format(
                                    certificate
                                        .tbsCertificate!.validity.notAfter,
                                  ),
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .certificateInfosThumbprintTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Wrap(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .certificateInfosThumbprintSha256,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SelectableText(
                              certificate.sha256Thumbprint ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontFamily: 'Roboto',
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Wrap(
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .certificateInfosThumbprintSha1,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SelectableText(
                              certificate.sha1Thumbprint ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    fontFamily: 'Roboto',
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
