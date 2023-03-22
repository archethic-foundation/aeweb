import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.grey,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, color: Colors.white),
          label: 'Documentation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gavel, color: Colors.white),
          label: 'Terms of Use',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.privacy_tip, color: Colors.white),
          label: 'Privacy Policy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code, color: Colors.white),
          label: 'Source Code',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help_outline, color: Colors.white),
          label: 'FAQ',
        ),
      ],
      onTap: (int index) {
        String? url;
        switch (index) {
          case 0:
            url =
                'https://archethic-foundation.github.io/archethic-docs/participate/aeweb';
            break;
          case 1:
            url = '#';
            break;
          case 2:
            url = '#';
            break;
          case 3:
            url = 'https://github.com/archethic-foundation/aeweb';
            break;
          case 4:
            url =
                'https://archethic-foundation.github.io/archethic-docs/category/FAQ';
            break;
        }
        if (url != null) {
          launchUrl(Uri.parse(url));
        }
      },
    );
  }
}
