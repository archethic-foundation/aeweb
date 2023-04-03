import 'package:aeweb/ui/views/update_website_sync/bloc/provider.dart';
import 'package:aeweb/ui/views/update_website_sync/layouts/components/update_website_sync_comparison_list.dart';
import 'package:aeweb/ui/views/util/components/ae_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateWebsiteSyncFormSheet extends ConsumerWidget {
  const UpdateWebsiteSyncFormSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Host a new website on Archethic Blockchain'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    child: UpdateWebsiteSyncComparisonSheet(),
                  ),
                  SizedBox(width: 50),
                  AEStepper(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: const Text(
                      'Back',
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final updateWebsiteSyncNotifier = ref.watch(
                        UpdateWebsiteSyncFormProvider
                            .updateWebsiteSyncForm.notifier,
                      );
                      await updateWebsiteSyncNotifier.update(context, ref);
                    },
                    child: Text(
                      'Update website',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
