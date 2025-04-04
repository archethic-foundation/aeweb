// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Session {
  Environment get environment => throw _privateConstructorUsedError;
  String get nameAccount => throw _privateConstructorUsedError;
  String get genesisAddress => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  ArchethicDappConnectionState get walletConnectionState =>
      throw _privateConstructorUsedError;
  Subscription<Account>? get accountSub => throw _privateConstructorUsedError;
  StreamSubscription<Account>? get accountStreamSub =>
      throw _privateConstructorUsedError;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionCopyWith<Session> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCopyWith<$Res> {
  factory $SessionCopyWith(Session value, $Res Function(Session) then) =
      _$SessionCopyWithImpl<$Res, Session>;
  @useResult
  $Res call(
      {Environment environment,
      String nameAccount,
      String genesisAddress,
      String error,
      ArchethicDappConnectionState walletConnectionState,
      Subscription<Account>? accountSub,
      StreamSubscription<Account>? accountStreamSub});

  $ArchethicDappConnectionStateCopyWith<$Res> get walletConnectionState;
  $SubscriptionCopyWith<Account, $Res>? get accountSub;
}

/// @nodoc
class _$SessionCopyWithImpl<$Res, $Val extends Session>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? environment = null,
    Object? nameAccount = null,
    Object? genesisAddress = null,
    Object? error = null,
    Object? walletConnectionState = null,
    Object? accountSub = freezed,
    Object? accountStreamSub = freezed,
  }) {
    return _then(_value.copyWith(
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Environment,
      nameAccount: null == nameAccount
          ? _value.nameAccount
          : nameAccount // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      walletConnectionState: null == walletConnectionState
          ? _value.walletConnectionState
          : walletConnectionState // ignore: cast_nullable_to_non_nullable
              as ArchethicDappConnectionState,
      accountSub: freezed == accountSub
          ? _value.accountSub
          : accountSub // ignore: cast_nullable_to_non_nullable
              as Subscription<Account>?,
      accountStreamSub: freezed == accountStreamSub
          ? _value.accountStreamSub
          : accountStreamSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<Account>?,
    ) as $Val);
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ArchethicDappConnectionStateCopyWith<$Res> get walletConnectionState {
    return $ArchethicDappConnectionStateCopyWith<$Res>(
        _value.walletConnectionState, (value) {
      return _then(_value.copyWith(walletConnectionState: value) as $Val);
    });
  }

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubscriptionCopyWith<Account, $Res>? get accountSub {
    if (_value.accountSub == null) {
      return null;
    }

    return $SubscriptionCopyWith<Account, $Res>(_value.accountSub!, (value) {
      return _then(_value.copyWith(accountSub: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionImplCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$$SessionImplCopyWith(
          _$SessionImpl value, $Res Function(_$SessionImpl) then) =
      __$$SessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Environment environment,
      String nameAccount,
      String genesisAddress,
      String error,
      ArchethicDappConnectionState walletConnectionState,
      Subscription<Account>? accountSub,
      StreamSubscription<Account>? accountStreamSub});

  @override
  $ArchethicDappConnectionStateCopyWith<$Res> get walletConnectionState;
  @override
  $SubscriptionCopyWith<Account, $Res>? get accountSub;
}

/// @nodoc
class __$$SessionImplCopyWithImpl<$Res>
    extends _$SessionCopyWithImpl<$Res, _$SessionImpl>
    implements _$$SessionImplCopyWith<$Res> {
  __$$SessionImplCopyWithImpl(
      _$SessionImpl _value, $Res Function(_$SessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? environment = null,
    Object? nameAccount = null,
    Object? genesisAddress = null,
    Object? error = null,
    Object? walletConnectionState = null,
    Object? accountSub = freezed,
    Object? accountStreamSub = freezed,
  }) {
    return _then(_$SessionImpl(
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Environment,
      nameAccount: null == nameAccount
          ? _value.nameAccount
          : nameAccount // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      walletConnectionState: null == walletConnectionState
          ? _value.walletConnectionState
          : walletConnectionState // ignore: cast_nullable_to_non_nullable
              as ArchethicDappConnectionState,
      accountSub: freezed == accountSub
          ? _value.accountSub
          : accountSub // ignore: cast_nullable_to_non_nullable
              as Subscription<Account>?,
      accountStreamSub: freezed == accountStreamSub
          ? _value.accountStreamSub
          : accountStreamSub // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<Account>?,
    ));
  }
}

/// @nodoc

class _$SessionImpl extends _Session {
  const _$SessionImpl(
      {required this.environment,
      this.nameAccount = '',
      this.genesisAddress = '',
      this.error = '',
      required this.walletConnectionState,
      this.accountSub,
      this.accountStreamSub})
      : super._();

  @override
  final Environment environment;
  @override
  @JsonKey()
  final String nameAccount;
  @override
  @JsonKey()
  final String genesisAddress;
  @override
  @JsonKey()
  final String error;
  @override
  final ArchethicDappConnectionState walletConnectionState;
  @override
  final Subscription<Account>? accountSub;
  @override
  final StreamSubscription<Account>? accountStreamSub;

  @override
  String toString() {
    return 'Session(environment: $environment, nameAccount: $nameAccount, genesisAddress: $genesisAddress, error: $error, walletConnectionState: $walletConnectionState, accountSub: $accountSub, accountStreamSub: $accountStreamSub)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionImpl &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            (identical(other.nameAccount, nameAccount) ||
                other.nameAccount == nameAccount) &&
            (identical(other.genesisAddress, genesisAddress) ||
                other.genesisAddress == genesisAddress) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.walletConnectionState, walletConnectionState) ||
                other.walletConnectionState == walletConnectionState) &&
            (identical(other.accountSub, accountSub) ||
                other.accountSub == accountSub) &&
            (identical(other.accountStreamSub, accountStreamSub) ||
                other.accountStreamSub == accountStreamSub));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      environment,
      nameAccount,
      genesisAddress,
      error,
      walletConnectionState,
      accountSub,
      accountStreamSub);

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      __$$SessionImplCopyWithImpl<_$SessionImpl>(this, _$identity);
}

abstract class _Session extends Session {
  const factory _Session(
      {required final Environment environment,
      final String nameAccount,
      final String genesisAddress,
      final String error,
      required final ArchethicDappConnectionState walletConnectionState,
      final Subscription<Account>? accountSub,
      final StreamSubscription<Account>? accountStreamSub}) = _$SessionImpl;
  const _Session._() : super._();

  @override
  Environment get environment;
  @override
  String get nameAccount;
  @override
  String get genesisAddress;
  @override
  String get error;
  @override
  ArchethicDappConnectionState get walletConnectionState;
  @override
  Subscription<Account>? get accountSub;
  @override
  StreamSubscription<Account>? get accountStreamSub;

  /// Create a copy of Session
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionImplCopyWith<_$SessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
