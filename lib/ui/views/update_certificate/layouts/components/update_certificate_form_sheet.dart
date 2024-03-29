/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:math' as math;

import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_select_private_key_path.dart';
import 'package:aeweb/ui/views/update_certificate/layouts/components/update_certificate_select_public_cert_path.dart';
import 'package:aeweb/ui/views/util/components/aeweb_background.dart';
import 'package:aeweb/ui/views/util/components/scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCertificateFormSheet extends ConsumerWidget {
  const UpdateCertificateFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Stack(
      children: [
        const AEWebBackground(),
        Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 5,
            right: 5,
          ),
          child: ArchethicScrollbar(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 5,
                right: 5,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.only(top: 100),
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.updateCertificateFormDesc,
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Transform.rotate(
                              angle: -math.pi,
                              child: Container(
                                width: 50,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SelectionArea(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .updateCertificateRequiredInfo,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 50,
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
                      const SizedBox(height: 16),
                      const UpdateCertificateSelectPublicCertPath(),
                      const SizedBox(height: 16),
                      const UpdateCertificateSelectPrivateKeyPath(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
