/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreenThirdPart extends StateNotifier<Widget> {
  MainScreenThirdPart() : super(const SizedBox());

  void setWidget(Widget newWidget) {
    state = SizedBox(child: newWidget);
  }
}

final _mainScreenThirdPartProvider =
    StateNotifierProvider<MainScreenThirdPart, Widget>(
  (ref) => MainScreenThirdPart(),
);

abstract class MainScreenThirdPartProviders {
  static final mainScreenThirdPartProvider = _mainScreenThirdPartProvider;
}
