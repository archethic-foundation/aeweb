/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:archethic_dapp_framework_flutter/archethic_dapp_framework_flutter.dart'
    as aedappfm;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum InfoBannerType { error, request }

class InfoBanner extends StatelessWidget {
  const InfoBanner(
    this.message,
    this.infoBannerType, {
    this.height = 40,
    this.width = aedappfm.AppThemeBase.sizeBoxComponentWidth,
    super.key,
  });

  final String message;
  final InfoBannerType infoBannerType;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return SizedBox(
        height: height,
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        border: Border.all(
                          color: infoBannerType == InfoBannerType.error
                              ? Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withValues(alpha: 0.6)
                              : infoBannerType == InfoBannerType.request
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.6)
                                  : aedappfm.AppThemeBase.statusOK
                                      .withValues(alpha: 0.6),
                          width: 0.5,
                        ),
                        gradient:
                            aedappfm.AppThemeBase.gradientInfoBannerBackground,
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        height: 45,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            if (infoBannerType == InfoBannerType.error)
                              Icon(
                                Iconsax.warning_2,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            if (infoBannerType == InfoBannerType.error)
                              const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: infoBannerType == InfoBannerType.error
                                      ? Theme.of(context).colorScheme.error
                                      : infoBannerType == InfoBannerType.request
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : aedappfm.AppThemeBase.statusOK,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 200))
        .scale(duration: const Duration(milliseconds: 200));
  }
}
