// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websites.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String $_websitesRepositoryHash() =>
    r'2d2a0ff7a595ecfa5b7c4f44f4460f6f9289984c';

/// See also [_websitesRepository].
final _websitesRepositoryProvider = AutoDisposeProvider<WebsitesRepository>(
  _websitesRepository,
  name: r'_websitesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : $_websitesRepositoryHash,
);
typedef _WebsitesRepositoryRef = AutoDisposeProviderRef<WebsitesRepository>;
String $_fetchWebsitesHash() => r'5df5cdc5be89b73c14e82e73bf7918c9d14894bb';

/// See also [_fetchWebsites].
final _fetchWebsitesProvider = AutoDisposeFutureProvider<List<Website>>(
  _fetchWebsites,
  name: r'_fetchWebsitesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : $_fetchWebsitesHash,
);
typedef _FetchWebsitesRef = AutoDisposeFutureProviderRef<List<Website>>;
String $_fetchWebsiteVersionsHash() =>
    r'8d92709a0eb444847c6ae196deb4585b7b30bc15';

/// See also [_fetchWebsiteVersions].
class _FetchWebsiteVersionsProvider
    extends AutoDisposeFutureProvider<List<WebsiteVersion>> {
  _FetchWebsiteVersionsProvider(
    this.genesisAddress,
  ) : super(
          (ref) => _fetchWebsiteVersions(
            ref,
            genesisAddress,
          ),
          from: _fetchWebsiteVersionsProvider,
          name: r'_fetchWebsiteVersionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $_fetchWebsiteVersionsHash,
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

typedef _FetchWebsiteVersionsRef
    = AutoDisposeFutureProviderRef<List<WebsiteVersion>>;

/// See also [_fetchWebsiteVersions].
final _fetchWebsiteVersionsProvider = _FetchWebsiteVersionsFamily();

class _FetchWebsiteVersionsFamily
    extends Family<AsyncValue<List<WebsiteVersion>>> {
  _FetchWebsiteVersionsFamily();

  _FetchWebsiteVersionsProvider call(
    dynamic genesisAddress,
  ) {
    return _FetchWebsiteVersionsProvider(
      genesisAddress,
    );
  }

  @override
  AutoDisposeFutureProvider<List<WebsiteVersion>> getProviderOverride(
    covariant _FetchWebsiteVersionsProvider provider,
  ) {
    return call(
      provider.genesisAddress,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'_fetchWebsiteVersionsProvider';
}
