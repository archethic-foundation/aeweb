import 'package:aeweb/side_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SideMenuItem(
                title: 'New website',
                iconSrc: 'assets/Icons/Inbox.svg',
                press: () => context.go('/addWebsite'),
              ),
              SideMenuItem(
                title: 'Documentation',
                iconSrc: 'assets/Icons/Inbox.svg',
                press: () => launchUrl(
                  Uri.parse(
                    'https://archethic-foundation.github.io/archethic-docs/participate/aeweb',
                  ),
                ),
              ),
              SideMenuItem(
                press: () {},
                title: 'Terms of Use',
                iconSrc: 'assets/Icons/Send.svg',
              ),
              SideMenuItem(
                press: () {},
                title: 'Privacy Policy',
                iconSrc: 'assets/Icons/File.svg',
              ),
              SideMenuItem(
                title: 'Source Code',
                iconSrc: 'assets/Icons/Trash.svg',
                press: () => launchUrl(
                  Uri.parse('https://github.com/archethic-foundation/aeweb'),
                ),
              ),
              SideMenuItem(
                title: 'FAQ',
                iconSrc: 'assets/Icons/Trash.svg',
                press: () => launchUrl(
                  Uri.parse(
                    'https://archethic-foundation.github.io/archethic-docs/category/FAQ',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
