import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_comparison_list.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_steps.dart';
import 'package:aeweb/ui/views/util/components/resizable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

part 'update_website_sync_bottom_bar.dart';

class UpdateWebsiteSyncFormSheet extends ConsumerWidget {
  const UpdateWebsiteSyncFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/background.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00000000),
                  const Color(0x00000000).withOpacity(1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                const Header(),
                Expanded(
                  child: ResizableBox(
                    width: MediaQuery.of(context).size.width - 100,
                    childLeft: const UpdateWebsiteSyncComparisonSheet()
                        .animate()
                        .fade(duration: const Duration(milliseconds: 200))
                        .scale(duration: const Duration(milliseconds: 200)),
                    childRight: const UpdateWebsiteSyncSteps()
                        .animate()
                        .fade(duration: const Duration(milliseconds: 250))
                        .scale(duration: const Duration(milliseconds: 250)),
                  ),
                ),
                const UpdateWebsiteSyncBottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
