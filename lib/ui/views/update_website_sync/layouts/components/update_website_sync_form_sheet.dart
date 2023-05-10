import 'package:aeweb/header.dart';
import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_comparison_list.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_steps.dart';
import 'package:aeweb/ui/views/util/components/resizable_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

part 'update_website_sync_bottom_bar.dart';

class UpdateWebsiteSyncFormSheet extends ConsumerWidget {
  const UpdateWebsiteSyncFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Column(
          children: [
            const Header(),
            Expanded(
              child: ResizableBox(
                width: MediaQuery.of(context).size.width - 100,
                childLeft: const UpdateWebsiteSyncComparisonSheet(),
                childRight: Card(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 0,
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: const UpdateWebsiteSyncSteps(),
                  ),
                ),
              ),
            ),
            const UpdateWebsiteSyncBottomBar(),
          ],
        ),
      ),
    );
  }
}
