// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'website_version_tx.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WebsiteVersionTx {
  String get address => throw _privateConstructorUsedError;
  String get typeHostingTx => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WebsiteVersionTxCopyWith<WebsiteVersionTx> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsiteVersionTxCopyWith<$Res> {
  factory $WebsiteVersionTxCopyWith(
          WebsiteVersionTx value, $Res Function(WebsiteVersionTx) then) =
      _$WebsiteVersionTxCopyWithImpl<$Res, WebsiteVersionTx>;
  @useResult
  $Res call({String address, String typeHostingTx});
}

/// @nodoc
class _$WebsiteVersionTxCopyWithImpl<$Res, $Val extends WebsiteVersionTx>
    implements $WebsiteVersionTxCopyWith<$Res> {
  _$WebsiteVersionTxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? typeHostingTx = null,
  }) {
    return _then(_value.copyWith(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      typeHostingTx: null == typeHostingTx
          ? _value.typeHostingTx
          : typeHostingTx // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WebsiteVersionTxCopyWith<$Res>
    implements $WebsiteVersionTxCopyWith<$Res> {
  factory _$$_WebsiteVersionTxCopyWith(
          _$_WebsiteVersionTx value, $Res Function(_$_WebsiteVersionTx) then) =
      __$$_WebsiteVersionTxCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String address, String typeHostingTx});
}

/// @nodoc
class __$$_WebsiteVersionTxCopyWithImpl<$Res>
    extends _$WebsiteVersionTxCopyWithImpl<$Res, _$_WebsiteVersionTx>
    implements _$$_WebsiteVersionTxCopyWith<$Res> {
  __$$_WebsiteVersionTxCopyWithImpl(
      _$_WebsiteVersionTx _value, $Res Function(_$_WebsiteVersionTx) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = null,
    Object? typeHostingTx = null,
  }) {
    return _then(_$_WebsiteVersionTx(
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      typeHostingTx: null == typeHostingTx
          ? _value.typeHostingTx
          : typeHostingTx // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_WebsiteVersionTx implements _WebsiteVersionTx {
  const _$_WebsiteVersionTx(
      {required this.address, required this.typeHostingTx});

  @override
  final String address;
  @override
  final String typeHostingTx;

  @override
  String toString() {
    return 'WebsiteVersionTx(address: $address, typeHostingTx: $typeHostingTx)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WebsiteVersionTx &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.typeHostingTx, typeHostingTx) ||
                other.typeHostingTx == typeHostingTx));
  }

  @override
  int get hashCode => Object.hash(runtimeType, address, typeHostingTx);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WebsiteVersionTxCopyWith<_$_WebsiteVersionTx> get copyWith =>
      __$$_WebsiteVersionTxCopyWithImpl<_$_WebsiteVersionTx>(this, _$identity);
}

abstract class _WebsiteVersionTx implements WebsiteVersionTx {
  const factory _WebsiteVersionTx(
      {required final String address,
      required final String typeHostingTx}) = _$_WebsiteVersionTx;

  @override
  String get address;
  @override
  String get typeHostingTx;
  @override
  @JsonKey(ignore: true)
  _$$_WebsiteVersionTxCopyWith<_$_WebsiteVersionTx> get copyWith =>
      throw _privateConstructorUsedError;
}
