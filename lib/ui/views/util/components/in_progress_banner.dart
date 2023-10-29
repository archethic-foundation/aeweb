/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/util/components/info_banner.dart';
import 'package:flutter/material.dart';

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
          InfoBanner(
            errorMessage,
            InfoBannerType.error,
          )
        else if (infoMessage.isNotEmpty)
          InfoBanner(
            infoMessage,
            InfoBannerType.request,
          ),
      ],
    );
  }
}
