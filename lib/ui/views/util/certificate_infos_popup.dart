import 'package:aeweb/util/certificate_util.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
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
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    SelectionArea(
                                      child: Text(
                                        'Certificate infos',
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
                                            begin:
                                                AlignmentDirectional.centerEnd,
                                            end: AlignmentDirectional
                                                .centerStart,
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
                                    children: const [
                                      Icon(Iconsax.warning_2),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'No certificate installed',
                                      ),
                                      SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Emis pour',
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
                                              Text(
                                                property['label'] ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                certificate.tbsCertificate!
                                                            .subject[
                                                        property['code']] ??
                                                    '<not included in the certificate>',
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
                                        'Emis par',
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
                                              Text(
                                                property['label'] ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                certificate.tbsCertificate!
                                                            .issuer[
                                                        property['code']] ??
                                                    '<not included in the certificate>',
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
                                        'Durée de validité',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Emis le ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            Text(
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
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Expire le ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            Text(
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
                                        'Empreintes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Empreinte SHA-256',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              certificate.sha256Thumbprint ??
                                                  '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Empreinte SHA-1',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              certificate.sha1Thumbprint ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                Align(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
