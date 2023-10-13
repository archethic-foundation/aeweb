// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websites.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$websitesRepositoryHash() =>
    r'2d2a0ff7a595ecfa5b7c4f44f4460f6f9289984c';

/// See also [_websitesRepository].
@ProviderFor(_websitesRepository)
final _websitesRepositoryProvider =
    AutoDisposeProvider<WebsitesRepository>.internal(
  _websitesRepository,
  name: r'_websitesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$websitesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _WebsitesRepositoryRef = AutoDisposeProviderRef<WebsitesRepository>;
String _$fetchWebsitesHash() => r'5df5cdc5be89b73c14e82e73bf7918c9d14894bb';

/// See also [_fetchWebsites].
@ProviderFor(_fetchWebsites)
final _fetchWebsitesProvider =
    AutoDisposeFutureProvider<List<Website>>.internal(
  _fetchWebsites,
  name: r'_fetchWebsitesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchWebsitesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _FetchWebsitesRef = AutoDisposeFutureProviderRef<List<Website>>;
String _$fetchWebsiteVersionsHash() =>
    r'8d92709a0eb444847c6ae196deb4585b7b30bc15';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef _FetchWebsiteVersionsRef
    = AutoDisposeFutureProviderRef<List<WebsiteVersion>>;

/// See also [_fetchWebsiteVersions].
@ProviderFor(_fetchWebsiteVersions)
const _fetchWebsiteVersionsProvider = _FetchWebsiteVersionsFamily();

/// See also [_fetchWebsiteVersions].
class _FetchWebsiteVersionsFamily
    extends Family<AsyncValue<List<WebsiteVersion>>> {
  /// See also [_fetchWebsiteVersions].
  const _FetchWebsiteVersionsFamily();

  /// See also [_fetchWebsiteVersions].
  _FetchWebsiteVersionsProvider call(
    dynamic genesisAddress,
  ) {
    return _FetchWebsiteVersionsProvider(
      genesisAddress,
    );
  }

  @override
  _FetchWebsiteVersionsProvider getProviderOverride(
    covariant _FetchWebsiteVersionsProvider provider,
  ) {
    return call(
      provider.genesisAddress,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_fetchWebsiteVersionsProvider';
}

/// See also [_fetchWebsiteVersions].
class _FetchWebsiteVersionsProvider
    extends AutoDisposeFutureProvider<List<WebsiteVersion>> {
  /// See also [_fetchWebsiteVersions].
  _FetchWebsiteVersionsProvider(
    this.genesisAddress,
  ) : super.internal(
          (ref) => _fetchWebsiteVersions(
            ref,
            genesisAddress,
          ),
          from: _fetchWebsiteVersionsProvider,
          name: r'_fetchWebsiteVersionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchWebsiteVersionsHash,
          dependencies: _FetchWebsiteVersionsFamily._dependencies,
          allTransitiveDependencies:
              _FetchWebsiteVersionsFamily._allTransitiveDependencies,
        );

  final dynamic genesisAddress;

  @override
  bool operator ==(Object other) {
    return other is _FetchWebsiteVersionsProvider &&
        other.genesisAddress == genesisAddress;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genesisAddress.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
