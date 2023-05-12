import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreenThirdPart extends StateNotifier<Widget> {
  MainScreenThirdPart() : super(const SizedBox());

  // ignore: use_setters_to_change_properties
  void setWidget(Widget newWidget) {
    state = newWidget;
  }
}

final _mainScreenThirdPartProvider =
    StateNotifierProvider<MainScreenThirdPart, Widget>(
  (ref) => MainScreenThirdPart(),
);

abstract class MainScreenThirdPartProviders {
  static final mainScreenThirdPartProvider = _mainScreenThirdPartProvider;
}
