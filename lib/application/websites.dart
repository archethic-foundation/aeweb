import 'package:aeweb/infrastructure/websites.repository.dart';
import 'package:aeweb/model/website.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websites.g.dart';

@riverpod
WebsitesRepositoryImpl _websitesRepository(_WebsitesRepositoryRef ref) =>
    WebsitesRepositoryImpl();

@riverpod
Future<List<Website>> _fetchWebsites(_FetchWebsitesRef ref) async {
  return ref.watch(_websitesRepositoryProvider).getWebsites();
}

abstract class WebsitesProviders {
  static final fetchWebsites = _fetchWebsitesProvider;
}
