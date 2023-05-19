import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
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
          ],
        ),
      ],
    );
  }
}
