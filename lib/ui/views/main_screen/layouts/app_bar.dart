import 'package:aeweb/ui/views/main_screen/layouts/app_bar_menu_info.dart';
import 'package:aeweb/ui/views/main_screen/layouts/app_bar_menu_links.dart';
import 'package:aeweb/ui/views/main_screen/layouts/connection_to_wallet_status.dart';
import 'package:aeweb/ui/views/main_screen/layouts/header.dart';
import 'package:flutter/material.dart';

class AppBarMainScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarMainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Header(),
        leadingWidth: MediaQuery.of(context).size.width,
        actions: const [
          ConnectionToWalletStatus(),
          SizedBox(
            width: 10,
          ),
          AppBarMenuInfo(),
          AppBarMenuLinks(),
          SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
