import 'package:aeweb/ui/views/util/connection_to_wallet_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/AELogo.svg',
                semanticsLabel: 'AE Logo',
                height: 30,
              ),
              Text(
                'web',
                style: TextStyle(
                  fontFamily: 'Caveat',
                  fontSize: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const ConnectionToWalletStatus(),
        ],
      ),
    );
  }
}
