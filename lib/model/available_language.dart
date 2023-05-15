/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';

enum AvailableLanguage { systemDefault, english }

extension AvailableLanguageExt on AvailableLanguage {
  Locale? getLocale() {
    switch (this) {
      case AvailableLanguage.english:
        return const Locale('en', 'US');
      case AvailableLanguage.systemDefault:
        return null;
    }
  }

  String getLocaleString() {
    switch (this) {
      case AvailableLanguage.english:
        return 'en';
      case AvailableLanguage.systemDefault:
        return 'DEFAULT';
    }
  }
}

/// Represent the available languages our app supports
@immutable
class LanguageSetting extends SettingSelectionItem {
  const LanguageSetting(this.language);

  final AvailableLanguage language;

  @override
  String getDisplayName(BuildContext context) {
    switch (language) {
      case AvailableLanguage.english:
        return 'English (en)';
      case AvailableLanguage.systemDefault:
        return AppLocalizations.of(context)!.systemDefault;
    }
  }

  // For saving to shared prefs
  int getIndex() {
    return language.index;
  }
}
