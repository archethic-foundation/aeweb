// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blockchain.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Blockchain _$BlockchainFromJson(Map<String, dynamic> json) {
  return _Blockchain.fromJson(json);
}

/// @nodoc
mixin _$Blockchain {
  String get name => throw _privateConstructorUsedError;
  String get env => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get urlExplorerAddress => throw _privateConstructorUsedError;
  String get urlExplorerTransaction => throw _privateConstructorUsedError;
  String get urlExplorerChain => throw _privateConstructorUsedError;
  String get nativeCurrency => throw _privateConstructorUsedError;

  /// Serializes this Blockchain to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Blockchain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlockchainCopyWith<Blockchain> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlockchainCopyWith<$Res> {
  factory $BlockchainCopyWith(
          Blockchain value, $Res Function(Blockchain) then) =
      _$BlockchainCopyWithImpl<$Res, Blockchain>;
  @useResult
  $Res call(
      {String name,
      String env,
      String icon,
      String urlExplorerAddress,
      String urlExplorerTransaction,
      String urlExplorerChain,
      String nativeCurrency});
}

/// @nodoc
class _$BlockchainCopyWithImpl<$Res, $Val extends Blockchain>
    implements $BlockchainCopyWith<$Res> {
  _$BlockchainCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Blockchain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? env = null,
    Object? icon = null,
    Object? urlExplorerAddress = null,
    Object? urlExplorerTransaction = null,
    Object? urlExplorerChain = null,
    Object? nativeCurrency = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      env: null == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      urlExplorerAddress: null == urlExplorerAddress
          ? _value.urlExplorerAddress
          : urlExplorerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      urlExplorerTransaction: null == urlExplorerTransaction
          ? _value.urlExplorerTransaction
          : urlExplorerTransaction // ignore: cast_nullable_to_non_nullable
              as String,
      urlExplorerChain: null == urlExplorerChain
          ? _value.urlExplorerChain
          : urlExplorerChain // ignore: cast_nullable_to_non_nullable
              as String,
      nativeCurrency: null == nativeCurrency
          ? _value.nativeCurrency
          : nativeCurrency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlockchainImplCopyWith<$Res>
    implements $BlockchainCopyWith<$Res> {
  factory _$$BlockchainImplCopyWith(
          _$BlockchainImpl value, $Res Function(_$BlockchainImpl) then) =
      __$$BlockchainImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String env,
      String icon,
      String urlExplorerAddress,
      String urlExplorerTransaction,
      String urlExplorerChain,
      String nativeCurrency});
}

/// @nodoc
class __$$BlockchainImplCopyWithImpl<$Res>
    extends _$BlockchainCopyWithImpl<$Res, _$BlockchainImpl>
    implements _$$BlockchainImplCopyWith<$Res> {
  __$$BlockchainImplCopyWithImpl(
      _$BlockchainImpl _value, $Res Function(_$BlockchainImpl) _then)
      : super(_value, _then);

  /// Create a copy of Blockchain
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? env = null,
    Object? icon = null,
    Object? urlExplorerAddress = null,
    Object? urlExplorerTransaction = null,
    Object? urlExplorerChain = null,
    Object? nativeCurrency = null,
  }) {
    return _then(_$BlockchainImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      env: null == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      urlExplorerAddress: null == urlExplorerAddress
          ? _value.urlExplorerAddress
          : urlExplorerAddress // ignore: cast_nullable_to_non_nullable
              as String,
      urlExplorerTransaction: null == urlExplorerTransaction
          ? _value.urlExplorerTransaction
          : urlExplorerTransaction // ignore: cast_nullable_to_non_nullable
              as String,
      urlExplorerChain: null == urlExplorerChain
          ? _value.urlExplorerChain
          : urlExplorerChain // ignore: cast_nullable_to_non_nullable
              as String,
      nativeCurrency: null == nativeCurrency
          ? _value.nativeCurrency
          : nativeCurrency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlockchainImpl extends _Blockchain {
  const _$BlockchainImpl(
      {this.name = '',
      this.env = '',
      this.icon = '',
      this.urlExplorerAddress = '',
      this.urlExplorerTransaction = '',
      this.urlExplorerChain = '',
      this.nativeCurrency = ''})
      : super._();

  factory _$BlockchainImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlockchainImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String env;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String urlExplorerAddress;
  @override
  @JsonKey()
  final String urlExplorerTransaction;
  @override
  @JsonKey()
  final String urlExplorerChain;
  @override
  @JsonKey()
  final String nativeCurrency;

  @override
  String toString() {
    return 'Blockchain(name: $name, env: $env, icon: $icon, urlExplorerAddress: $urlExplorerAddress, urlExplorerTransaction: $urlExplorerTransaction, urlExplorerChain: $urlExplorerChain, nativeCurrency: $nativeCurrency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlockchainImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.env, env) || other.env == env) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.urlExplorerAddress, urlExplorerAddress) ||
                other.urlExplorerAddress == urlExplorerAddress) &&
            (identical(other.urlExplorerTransaction, urlExplorerTransaction) ||
                other.urlExplorerTransaction == urlExplorerTransaction) &&
            (identical(other.urlExplorerChain, urlExplorerChain) ||
                other.urlExplorerChain == urlExplorerChain) &&
            (identical(other.nativeCurrency, nativeCurrency) ||
                other.nativeCurrency == nativeCurrency));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      env,
      icon,
      urlExplorerAddress,
      urlExplorerTransaction,
      urlExplorerChain,
      nativeCurrency);

  /// Create a copy of Blockchain
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlockchainImplCopyWith<_$BlockchainImpl> get copyWith =>
      __$$BlockchainImplCopyWithImpl<_$BlockchainImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlockchainImplToJson(
      this,
    );
  }
}

abstract class _Blockchain extends Blockchain {
  const factory _Blockchain(
      {final String name,
      final String env,
      final String icon,
      final String urlExplorerAddress,
      final String urlExplorerTransaction,
      final String urlExplorerChain,
      final String nativeCurrency}) = _$BlockchainImpl;
  const _Blockchain._() : super._();

  factory _Blockchain.fromJson(Map<String, dynamic> json) =
      _$BlockchainImpl.fromJson;

  @override
  String get name;
  @override
  String get env;
  @override
  String get icon;
  @override
  String get urlExplorerAddress;
  @override
  String get urlExplorerTransaction;
  @override
  String get urlExplorerChain;
  @override
  String get nativeCurrency;

  /// Create a copy of Blockchain
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlockchainImplCopyWith<_$BlockchainImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
