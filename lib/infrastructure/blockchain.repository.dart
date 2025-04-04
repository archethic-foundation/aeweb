import 'dart:convert';

import 'package:aeweb/domain/models/blockchain.dart';
import 'package:aeweb/domain/repositories/blockchain.repository.dart';
import 'package:flutter/services.dart';

class BlockchainsRepositoryImpl implements BlockchainsRepository {
  @override
  Future<List<Blockchain>> getBlockchainsListConf() async {
    final jsonContent = await rootBundle
        .loadString('lib/domain/repositories/blockchains_list.json');

    final jsonData = jsonDecode(jsonContent);

    final blockchainsList =
        List<Map<String, dynamic>>.from(jsonData['blockchains']);

    return blockchainsList.map(Blockchain.fromJson).toList();
  }

  @override
  List<Blockchain> getBlockchainsList(
    List<Blockchain> blockchainsList,
  ) {
    blockchainsList.sort((a, b) {
      final compareEnv = a.env.compareTo(b.env);
      if (compareEnv != 0) {
        return compareEnv;
      } else {
        return a.name.compareTo(b.name);
      }
    });
    return blockchainsList;
  }

  @override
  Future<Blockchain?> getBlockchainFromEnv(
    List<Blockchain> blockchainsList,
    String env,
  ) async {
    return blockchainsList.singleWhere((element) => element.env == env);
  }
}
