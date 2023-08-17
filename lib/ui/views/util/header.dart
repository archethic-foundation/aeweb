import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/util/generic/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({
    this.displayWalletConnectStatus = false,
    this.forceAELogo = false,
    super.key,
  });
  final bool displayWalletConnectStatus;
  final bool forceAELogo;

  @override
  Widget build(BuildContext context) {
    if (forceAELogo == false &&
        (Responsive.isMobile(context) || Responsive.isTablet(context))) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/Archethic-Logo-Alone-White.svg',
            semanticsLabel: 'AE Logo',
            height: 40,
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      );
    }
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/AELogo.svg',
              semanticsLabel: 'AE Logo',
              height: 30,
            ),
            const Text(
              'web',
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 50,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Text(
                'Beta',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
        if (displayWalletConnectStatus)
          const Positioned(
            top: 7,
            right: 0,
            child: SizedBox(
              width: 250,
              height: 60,
              child: ConnectionToWalletStatus(),
            ),
          ),
      ],
    );
  }
}
