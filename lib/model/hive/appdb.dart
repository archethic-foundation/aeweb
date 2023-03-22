/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/model/hive/aeweb_website.dart';
import 'package:aeweb/model/hive/aeweb_website_metadata.dart';
import 'package:aeweb/model/hive/aeweb_website_version.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Future<void> setupDatabase() async {
    if (kIsWeb) {
      Hive.initFlutter();
    } else {
      final suppDir = await getApplicationSupportDirectory();
      Hive.init(suppDir.path);
    }

    Hive
      ..registerAdapter(AEWebLocalWebsiteAdapter())
      ..registerAdapter(AEWebLocalWebsiteVersionAdapter())
      ..registerAdapter(AEWebLocalWebsiteMetaDataAdapter());
  }
}
