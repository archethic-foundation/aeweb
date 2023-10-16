/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/ui/views/display_website/website_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Body extends ConsumerWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 30,
        bottom: 30,
        left: 10,
        right: 10,
      ),
      child: WebsiteList(),
    );
  }
}
