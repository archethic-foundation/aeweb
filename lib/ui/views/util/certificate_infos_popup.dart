import 'package:aeweb/ui/views/util/components/app_button.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:aeweb/util/certificate_util.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CertificateInfosPopup with CertificateMixin {
  static Future<void> getDialog(
    BuildContext context,
    X509CertificateData? certificate,
  ) async {
    return showDialog(
      context: context,
      builder: (context) {
        return ScaffoldMessenger(
          child: Builder(
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      content: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(
                          top: 10,
                          left: 30,
                          right: 30,
                        ),
                        child: ArchethicScrollbar(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  SelectionArea(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .certificateInfosTitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Container(
                                      width: 25,
                                      height: 1,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0x003C89B9),
                                            Color(0xFFCC00FF),
                                          ],
                                          stops: [0, 1],
                                          begin: AlignmentDirectional.centerEnd,
                                          end: AlignmentDirectional.centerStart,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 400,
                                height: 20,
                              ),
                              if (certificate == null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Iconsax.warning_2),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    for (final property in CertificateMixin
                                        .getCertificateProperties())
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            SelectableText(
                                              property['label'] ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const SizedBox(width: 10),
                                            SelectableText(
                                              certificate.tbsCertificate!
                                                          .subject[
                                                      property['code']] ??
                                                  AppLocalizations.of(
                                                    context,
                                                  )!
                                                      .certificateInfosNotIncluded,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    for (final property in CertificateMixin
                                        .getCertificateProperties())
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            SelectableText(
                                              property['label'] ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const SizedBox(width: 10),
                                            SelectableText(
                                              certificate.tbsCertificate!
                                                          .issuer[
                                                      property['code']] ??
                                                  AppLocalizations.of(
                                                    context,
                                                  )!
                                                      .certificateInfosNotIncluded,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          SelectableText(
                                            AppLocalizations.of(context)!
                                                .certificateInfosValidityStart,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          SelectableText(
                                            DateFormat.yMMMEd(
                                              Localizations.localeOf(context)
                                                  .languageCode,
                                            ).add_Hms().format(
                                                  certificate.tbsCertificate!
                                                      .validity.notBefore,
                                                ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                          SelectableText(
                                            DateFormat.yMMMEd(
                                              Localizations.localeOf(context)
                                                  .languageCode,
                                            ).add_Hms().format(
                                                  certificate.tbsCertificate!
                                                      .validity.notAfter,
                                                ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .certificateInfosThumbprintSha256,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
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
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .certificateInfosThumbprintSha1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButton(
                                    labelBtn:
                                        AppLocalizations.of(context)!.btn_close,
                                    icon: Iconsax.close_square,
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
