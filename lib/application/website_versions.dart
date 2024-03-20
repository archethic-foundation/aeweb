import 'package:aeweb/infrastructure/website_versions.repository.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'website_versions.g.dart';

@riverpod
WebsiteVersionsRepositoryImpl _websiteVersionsRepository(
  _WebsiteVersionsRepositoryRef ref,
) =>
    WebsiteVersionsRepositoryImpl();

@riverpod
Future<List<WebsiteVersion>> _fetchWebsiteVersions(
  _FetchWebsiteVersionsRef ref,
  genesisAddress,
) async {
  return ref
      .watch(_websiteVersionsRepositoryProvider)
      .getWebsiteVersions(genesisAddress);
}

abstract class WebsiteVersionProviders {
  static const fetchWebsiteVersions = _fetchWebsiteVersionsProvider;
}
