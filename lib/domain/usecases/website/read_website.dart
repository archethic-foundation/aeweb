import 'dart:convert';
import 'dart:developer';

import 'package:aeweb/model/hive/aeweb_website.dart';
import 'package:aeweb/model/hive/aeweb_website_metadata.dart';
import 'package:aeweb/model/hive/aeweb_website_version.dart';
import 'package:aeweb/model/website.dart';
import 'package:aeweb/model/website_version.dart';
import 'package:aeweb/util/get_it_instance.dart';
import 'package:archethic_lib_dart/archethic_lib_dart.dart';
import 'package:hive/hive.dart';

class ReadWebsiteUseCases {
  static const String websitesTable = 'websites';

  Future<WebsiteVersion?> getWebsiteVersionFromLocalFirst(
    String address,
  ) async {
    try {
      final localValue = await getLocal(address);
      if (localValue != null) {
        log('Using local value');
        return localValue;
      }
    } catch (e, stackTrace) {
      log(
        'Local read failed',
        error: e,
        stackTrace: stackTrace,
      );
    }

    try {
      final remoteValue = await getRemote(address);
      if (remoteValue != null) {
        // TODO(reddwarf03): A régler
        // saveLocal(localPath, website);
        log('Using remote value');
        return remoteValue;
      }
    } catch (e, stackTrace) {
      log(
        'Remote read failed',
        error: e,
        stackTrace: stackTrace,
      );
    }

    throw Exception('Unable to fetch local or remote value');
  }

  Future<WebsiteVersion?> getLocal(String address) async {
    late WebsiteVersion websiteVersion;

    final box = await Hive.openBox<AEWebLocalWebsite>(websitesTable);
    final websitesList = box.values.toList();
    for (final website in websitesList) {
      if (website.aewebLocalWebsiteVersionList != null) {
        for (final version in website.aewebLocalWebsiteVersionList!) {
          if (version.transactionAddress == address) {
            final metaData = <String, HostingContentMetaData>{};
            if (version.metaData != null) {
              version.metaData!.forEach((key, value) {
                final hostingContentMetaData = HostingContentMetaData(
                  hash: value.hash,
                  encoding: value.encoding,
                  size: value.size,
                  addresses: value.addresses,
                );
                metaData[key] = hostingContentMetaData;
              });
            }

            websiteVersion = WebsiteVersion(
              transactionAddress: version.transactionAddress,
              timestamp: version.timestamp,
              filesCount: version.filesCount ?? 0,
              size: version.size ?? 0,
              content: Hosting(
                aewebVersion: version.structureVersion ?? 1,
                hashFunction: version.hashFunction ?? '',
                metaData: metaData,
              ),
            );
          }
        }
      }
    }
    return websiteVersion;
  }

  Future<WebsiteVersion?> getRemote(String address) async {
    late WebsiteVersion websiteVersion;

    final transactionMap = await sl.get<ApiService>().getTransaction(
      [address],
      request: 'address, validationStamp { timestamp } data { content }',
    );
    final transaction = transactionMap[address];
    if (transaction != null &&
        transaction.data != null &&
        transaction.data!.content != null) {
      var size = 0;
      final hosting = Hosting.fromJson(
        jsonDecode(transaction.data!.content!),
      );

      hosting.metaData.forEach((key, value) {
        size = size + value.size;
      });

      websiteVersion = WebsiteVersion(
        transactionAddress: transaction.address!.address!,
        timestamp: transaction.validationStamp!.timestamp!,
        filesCount: hosting.metaData.length,
        size: size,
        content: hosting,
      );
    }

    return websiteVersion;
  }

  Future<void> saveLocal(String localPath, Website website) async {
    final metaData = <String, AEWebLocalWebsiteMetaData>{};
    final aewebLocalWebsiteVersionList = <AEWebLocalWebsiteVersion>[];
    for (final version in website.websiteVersionList) {
      version.content!.metaData.forEach((key, value) {
        metaData[key] = AEWebLocalWebsiteMetaData(
          size: value.size,
          encoding: value.encoding,
          hash: value.hash,
          addresses: value.addresses,
        );
      });

      final aewebLocalWebsiteVersion = AEWebLocalWebsiteVersion(
        structureVersion: 1,
        timestamp: version.timestamp,
        transactionAddress: version.transactionAddress,
        filesCount: version.filesCount,
        hashFunction: 'sha1',
        size: version.size,
        metaData: metaData,
      );
      aewebLocalWebsiteVersionList.add(aewebLocalWebsiteVersion);
    }

    final aewebLocalWebsite = AEWebLocalWebsite(
      genesisAddress: website.genesisAddress,
      name: website.name,
      lastSaving: DateTime.now().millisecondsSinceEpoch,
      localPath: localPath,
      aewebLocalWebsiteVersionList: aewebLocalWebsiteVersionList,
    );

    final box = await Hive.openBox<AEWebLocalWebsite>(websitesTable);
    await box.put(aewebLocalWebsite.genesisAddress, aewebLocalWebsite);
  }
}
