import 'package:aeweb/application/api_service.dart';
import 'package:aeweb/application/dapp_client.dart';
import 'package:aeweb/domain/usecases/website/add_website.dart';
import 'package:aeweb/domain/usecases/website/read_website_version.dart';
import 'package:aeweb/domain/usecases/website/unpublish_website.dart';
import 'package:aeweb/domain/usecases/website/update_certificate.dart';
import 'package:aeweb/domain/usecases/website/update_website_sync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'usecases.g.dart';

@riverpod
UnpublishWebsiteUseCase unpublishWebsiteUseCase(
  Ref ref,
) {
  final dappClientAsync = ref.watch(dappClientProvider);

  return dappClientAsync.when(
    data: (dappClient) => UnpublishWebsiteUseCase(
      apiService: ref.watch(apiServiceProvider),
      dappClient: dappClient,
    ),
    loading: () => throw UnimplementedError('Dapp client is loading'),
    error: (error, stack) =>
        throw UnimplementedError('Failed to load dapp client'),
  );
}

@riverpod
UpdateCertificateUseCase updateCertificateUseCase(
  Ref ref,
) {
  final dappClientAsync = ref.watch(dappClientProvider);

  return dappClientAsync.when(
    data: (dappClient) => UpdateCertificateUseCase(
      apiService: ref.watch(apiServiceProvider),
      dappClient: dappClient,
    ),
    loading: () => throw UnimplementedError('Dapp client is loading'),
    error: (error, stack) =>
        throw UnimplementedError('Failed to load dapp client'),
  );
}

@riverpod
UpdateWebsiteSyncUseCase updateWebsiteSyncUseCase(
  Ref ref,
) {
  final dappClientAsync = ref.watch(dappClientProvider);

  return dappClientAsync.when(
    data: (dappClient) => UpdateWebsiteSyncUseCase(
      apiService: ref.watch(apiServiceProvider),
      dappClient: dappClient,
    ),
    loading: () => throw UnimplementedError('Dapp client is loading'),
    error: (error, stack) =>
        throw UnimplementedError('Failed to load dapp client'),
  );
}

@riverpod
AddWebsiteUseCase addWebsiteUseCase(
  Ref ref,
) {
  final dappClientAsync = ref.watch(dappClientProvider);

  return dappClientAsync.when(
    data: (dappClient) => AddWebsiteUseCase(
      apiService: ref.watch(apiServiceProvider),
      dappClient: dappClient,
    ),
    loading: () => throw UnimplementedError('Dapp client is loading'),
    error: (error, stack) =>
        throw UnimplementedError('Failed to load dapp client'),
  );
}

@riverpod
ReadWebsiteVersionUseCase readWebsiteVersionUseCase(
  Ref ref,
) {
  final dappClientAsync = ref.watch(dappClientProvider);

  return dappClientAsync.when(
    data: (dappClient) => ReadWebsiteVersionUseCase(
      apiService: ref.watch(apiServiceProvider),
    ),
    loading: () => throw UnimplementedError('Dapp client is loading'),
    error: (error, stack) =>
        throw UnimplementedError('Failed to load dapp client'),
  );
}
