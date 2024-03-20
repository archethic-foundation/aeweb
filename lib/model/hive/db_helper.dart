/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/hive/aeweb_website.dart';
import 'package:aeweb/model/website.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper with DTOParser {
  static const String websitesTable = 'websites';

  static Future<void> setupDatabase() async {
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final suppDir = await getApplicationSupportDirectory();
      Hive.init(suppDir.path);
    }

    Hive.registerAdapter(AEWebLocalWebsiteAdapter());
  }

  Future<List<Website>> getLocalWebsites() async {
    final box = await Hive.openBox<AEWebLocalWebsite>(websitesTable);
    final aeWebsitesList = box.values.toList()
      ..sort(
        (AEWebLocalWebsite a, AEWebLocalWebsite b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    return _websitesDtoToModel(aeWebsitesList);
  }

  Future<void> saveWebsite(Website website) async {
    final box = await Hive.openBox<AEWebLocalWebsite>(websitesTable);
    await box.put(website.genesisAddress, _websitesModelToDto(website));
  }

  Future<void> saveWebsites(List<Website> websites) async {
    for (final website in websites) {
      await saveWebsite(website);
    }
  }

  Future<void> clearWebsites() async {
    final box = await Hive.openBox<AEWebLocalWebsite>(websitesTable);
    await box.clear();
  }
}

mixin DTOParser {
  List<Website> _websitesDtoToModel(
    List<AEWebLocalWebsite> aewebLocalWebsiteList,
  ) {
    final websites = <Website>[];
    for (final aewebLocalWebsite in aewebLocalWebsiteList) {
      final website = Website(
        genesisAddress: aewebLocalWebsite.genesisAddress,
        name: aewebLocalWebsite.name,
      );
      websites.add(website);
    }
    return websites;
  }

  AEWebLocalWebsite _websitesModelToDto(
    Website website,
  ) {
    final aeWebLocalWebsite = AEWebLocalWebsite(
      genesisAddress: website.genesisAddress,
      name: website.name,
      lastSaving: DateTime.now().millisecondsSinceEpoch,
    );
    return aeWebLocalWebsite;
  }
}
