import 'package:aeweb/model/website_selection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedWebsite extends StateNotifier<WebsiteSelection> {
  SelectedWebsite()
      : super(
          const WebsiteSelection(
            name: '',
            genesisAddress: '',
          ),
        );

  void setSelection(String genesisAddress, String websiteName) {
    state = WebsiteSelection(
      name: websiteName,
      genesisAddress: genesisAddress,
    );
  }
}

final _selectedWebsiteProvider =
    StateNotifierProvider<SelectedWebsite, WebsiteSelection>(
  (ref) => SelectedWebsite(),
);

abstract class SelectedWebsiteProviders {
  static final selectedWebsiteProvider = _selectedWebsiteProvider;
}
