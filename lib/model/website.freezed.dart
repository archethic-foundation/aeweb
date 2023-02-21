// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'website.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Website {
  String get name => throw _privateConstructorUsedError;
  String get genesisAddress => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get nbTransactions => throw _privateConstructorUsedError;
  String get lastPublicationFees => throw _privateConstructorUsedError;
  String get globalFees => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WebsiteCopyWith<Website> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsiteCopyWith<$Res> {
  factory $WebsiteCopyWith(Website value, $Res Function(Website) then) =
      _$WebsiteCopyWithImpl<$Res, Website>;
  @useResult
  $Res call(
      {String name,
      String genesisAddress,
      String size,
      String nbTransactions,
      String lastPublicationFees,
      String globalFees});
}

/// @nodoc
class _$WebsiteCopyWithImpl<$Res, $Val extends Website>
    implements $WebsiteCopyWith<$Res> {
  _$WebsiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? genesisAddress = null,
    Object? size = null,
    Object? nbTransactions = null,
    Object? lastPublicationFees = null,
    Object? globalFees = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      nbTransactions: null == nbTransactions
          ? _value.nbTransactions
          : nbTransactions // ignore: cast_nullable_to_non_nullable
              as String,
      lastPublicationFees: null == lastPublicationFees
          ? _value.lastPublicationFees
          : lastPublicationFees // ignore: cast_nullable_to_non_nullable
              as String,
      globalFees: null == globalFees
          ? _value.globalFees
          : globalFees // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WebsiteCopyWith<$Res> implements $WebsiteCopyWith<$Res> {
  factory _$$_WebsiteCopyWith(
          _$_Website value, $Res Function(_$_Website) then) =
      __$$_WebsiteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String genesisAddress,
      String size,
      String nbTransactions,
      String lastPublicationFees,
      String globalFees});
}

/// @nodoc
class __$$_WebsiteCopyWithImpl<$Res>
    extends _$WebsiteCopyWithImpl<$Res, _$_Website>
    implements _$$_WebsiteCopyWith<$Res> {
  __$$_WebsiteCopyWithImpl(_$_Website _value, $Res Function(_$_Website) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? genesisAddress = null,
    Object? size = null,
    Object? nbTransactions = null,
    Object? lastPublicationFees = null,
    Object? globalFees = null,
  }) {
    return _then(_$_Website(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String,
      nbTransactions: null == nbTransactions
          ? _value.nbTransactions
          : nbTransactions // ignore: cast_nullable_to_non_nullable
              as String,
      lastPublicationFees: null == lastPublicationFees
          ? _value.lastPublicationFees
          : lastPublicationFees // ignore: cast_nullable_to_non_nullable
              as String,
      globalFees: null == globalFees
          ? _value.globalFees
          : globalFees // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Website implements _Website {
  const _$_Website(
      {required this.name,
      required this.genesisAddress,
      required this.size,
      required this.nbTransactions,
      required this.lastPublicationFees,
      required this.globalFees});

  @override
  final String name;
  @override
  final String genesisAddress;
  @override
  final String size;
  @override
  final String nbTransactions;
  @override
  final String lastPublicationFees;
  @override
  final String globalFees;

  @override
  String toString() {
    return 'Website(name: $name, genesisAddress: $genesisAddress, size: $size, nbTransactions: $nbTransactions, lastPublicationFees: $lastPublicationFees, globalFees: $globalFees)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Website &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.genesisAddress, genesisAddress) ||
                other.genesisAddress == genesisAddress) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.nbTransactions, nbTransactions) ||
                other.nbTransactions == nbTransactions) &&
            (identical(other.lastPublicationFees, lastPublicationFees) ||
                other.lastPublicationFees == lastPublicationFees) &&
            (identical(other.globalFees, globalFees) ||
                other.globalFees == globalFees));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, genesisAddress, size,
      nbTransactions, lastPublicationFees, globalFees);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WebsiteCopyWith<_$_Website> get copyWith =>
      __$$_WebsiteCopyWithImpl<_$_Website>(this, _$identity);
}

abstract class _Website implements Website {
  const factory _Website(
      {required final String name,
      required final String genesisAddress,
      required final String size,
      required final String nbTransactions,
      required final String lastPublicationFees,
      required final String globalFees}) = _$_Website;

  @override
  String get name;
  @override
  String get genesisAddress;
  @override
  String get size;
  @override
  String get nbTransactions;
  @override
  String get lastPublicationFees;
  @override
  String get globalFees;
  @override
  @JsonKey(ignore: true)
  _$$_WebsiteCopyWith<_$_Website> get copyWith =>
      throw _privateConstructorUsedError;
}
