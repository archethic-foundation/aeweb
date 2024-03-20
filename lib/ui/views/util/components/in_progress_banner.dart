/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:flutter/material.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;

class InProgressBanner extends StatelessWidget {
  const InProgressBanner({
    super.key,
    required this.stepLabel,
    required this.infoMessage,
    required this.errorMessage,
  });

  final String stepLabel;
  final String infoMessage;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    if (stepLabel.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            stepLabel,
            style: const TextStyle(fontSize: 11),
          ),
        ),
        if (errorMessage.isNotEmpty)
          aedappfm.InfoBanner(
            errorMessage,
            aedappfm.InfoBannerType.error,
          )
        else if (infoMessage.isNotEmpty)
          aedappfm.InfoBanner(
            infoMessage,
            aedappfm.InfoBannerType.request,
          ),
      ],
    );
  }
}
