import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

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
          OutlinedButton(
            onPressed: () {},
            child: Text('connect your wallet', style: textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}
