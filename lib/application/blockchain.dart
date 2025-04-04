/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'package:aeweb/application/session/provider.dart';
import 'package:aeweb/domain/models/blockchain.dart';
import 'package:aeweb/domain/repositories/blockchain.repository.dart';
import 'package:aeweb/infrastructure/blockchain.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'blockchain.g.dart';

@riverpod
Future<List<Blockchain>> _getBlockchainsListConf(
  Ref ref,
) async {
  return ref.watch(_blockchainsRepositoryProvider).getBlockchainsListConf();
}

@riverpod
BlockchainsRepository _blockchainsRepository(
  Ref ref,
) =>
    BlockchainsRepositoryImpl();

@riverpod
Future<List<Blockchain>> _getBlockchainsList(
  Ref ref,
) async {
  final blockchainsList =
      await ref.watch(_getBlockchainsListConfProvider.future);
  return ref
      .watch(_blockchainsRepositoryProvider)
      .getBlockchainsList(blockchainsList);
}

@riverpod
Future<Blockchain?> _currentBlockchain(
  Ref ref,
) async {
  final blockchainsList = await ref.watch(_getBlockchainsListProvider.future);

  final environment = ref.watch(environmentProvider);
  return ref
      .watch(_blockchainsRepositoryProvider)
      .getBlockchainFromEnv(blockchainsList, environment.name);
}

abstract class BlockchainsProviders {
  static final getBlockchainsList = _getBlockchainsListProvider;
  static final currentBlockchain = _currentBlockchainProvider;
  static final getBlockchainsListConf = _getBlockchainsListConfProvider;
}
