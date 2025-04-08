import 'package:aeweb/domain/models/blockchain.dart';

abstract class BlockchainsRepository {
  Future<List<Blockchain>> getBlockchainsListConf();

  List<Blockchain> getBlockchainsList(
    List<Blockchain> blockchainsList,
  );

  Future<Blockchain?> getBlockchainFromEnv(
    List<Blockchain> blockchainsList,
    String env,
  );
}
