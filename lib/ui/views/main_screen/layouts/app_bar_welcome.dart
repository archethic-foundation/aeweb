import 'package:aeweb/ui/themes/aeweb_theme_base.dart';
import 'package:aeweb/ui/views/main_screen/layouts/header.dart';
import 'package:aeweb/ui/views/util/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarWelcome extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const AppBarWelcome({
    super.key,
    required this.onAEMenuTapped,
  });
  final Function() onAEMenuTapped;
  @override
  Size get preferredSize => AppBar().preferredSize;

  @override
  ConsumerState<AppBarWelcome> createState() => _AppBarWelcomeState();
}

class _AppBarWelcomeState extends ConsumerState<AppBarWelcome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: ArchethicThemeBase.neutral0.withOpacity(0.2),
            height: 1,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Header(),
        leadingWidth: MediaQuery.of(context).size.width,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.element_3),
            onPressed: widget.onAEMenuTapped,
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
