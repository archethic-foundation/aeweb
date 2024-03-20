import 'package:aeweb/model/website.dart';

abstract class WebsitesRepository {
  Future<List<Website>> getWebsites();
}
