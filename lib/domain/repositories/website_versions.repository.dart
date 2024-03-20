import 'package:aeweb/model/website_version.dart';

abstract class WebsiteVersionsRepository {
  Future<List<WebsiteVersion>> getWebsiteVersions(String genesisAddress);
}
