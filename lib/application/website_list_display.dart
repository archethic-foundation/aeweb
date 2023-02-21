/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WebsiteListDisplayNotifier extends StateNotifier<bool> {
  WebsiteListDisplayNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final websiteListDisplayProvider =
    StateNotifierProvider<WebsiteListDisplayNotifier, bool>(
  (ref) => WebsiteListDisplayNotifier(),
);
