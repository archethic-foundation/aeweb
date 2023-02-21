/// SPDX-License-Identifier: AGPL-3.0-or-later

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:aeweb/l10n/messages_all.dart';
import 'package:aeweb/model/available_language.dart';

/// Localization
class AppLocalization {
  static Locale currentLocale = const Locale('en', 'US');

  static Future<AppLocalization> load(Locale locale) {
    currentLocale = locale;
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  String get welcomeText {
    return Intl.message('Welcome to AEWeb', name: 'welcomeText');
  }

  String get systemDefault {
    return Intl.message('System Default', name: 'systemDefault');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate(this.languageSetting);

  final AvailableLanguage languageSetting;

  @override
  bool isSupported(Locale locale) {
    return languageSetting != null;
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    if (languageSetting == AvailableLanguage.systemDefault) {
      return AppLocalization.load(locale);
    }
    return AppLocalization.load(Locale(languageSetting.getLocaleString()));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return true;
  }
}
