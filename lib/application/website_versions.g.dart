// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'website_versions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$websiteVersionsRepositoryHash() =>
    r'9720d8748cac4daa2541489be0f2f3ad2adc96dd';

/// See also [_websiteVersionsRepository].
@ProviderFor(_websiteVersionsRepository)
final _websiteVersionsRepositoryProvider =
    AutoDisposeProvider<WebsiteVersionsRepositoryImpl>.internal(
  _websiteVersionsRepository,
  name: r'_websiteVersionsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$websiteVersionsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _WebsiteVersionsRepositoryRef
    = AutoDisposeProviderRef<WebsiteVersionsRepositoryImpl>;
String _$fetchWebsiteVersionsHash() =>
    r'4655cda39588d2af65ede532db1e8c6e42febb8c';

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
    dynamic genesisAddress,
  ) : this._internal(
          (ref) => _fetchWebsiteVersions(
            ref as _FetchWebsiteVersionsRef,
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
          genesisAddress: genesisAddress,
        );

  _FetchWebsiteVersionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genesisAddress,
  }) : super.internal();

  final dynamic genesisAddress;

  @override
  Override overrideWith(
    FutureOr<List<WebsiteVersion>> Function(_FetchWebsiteVersionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _FetchWebsiteVersionsProvider._internal(
        (ref) => create(ref as _FetchWebsiteVersionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genesisAddress: genesisAddress,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WebsiteVersion>> createElement() {
    return _FetchWebsiteVersionsProviderElement(this);
  }

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

mixin _FetchWebsiteVersionsRef
    on AutoDisposeFutureProviderRef<List<WebsiteVersion>> {
  /// The parameter `genesisAddress` of this provider.
  dynamic get genesisAddress;
}

class _FetchWebsiteVersionsProviderElement
    extends AutoDisposeFutureProviderElement<List<WebsiteVersion>>
    with _FetchWebsiteVersionsRef {
  _FetchWebsiteVersionsProviderElement(super.provider);

  @override
  dynamic get genesisAddress =>
      (origin as _FetchWebsiteVersionsProvider).genesisAddress;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
