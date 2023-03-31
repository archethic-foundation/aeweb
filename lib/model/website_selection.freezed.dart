// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'website_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WebsiteSelection {
  String get name => throw _privateConstructorUsedError;
  String get genesisAddress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WebsiteSelectionCopyWith<WebsiteSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsiteSelectionCopyWith<$Res> {
  factory $WebsiteSelectionCopyWith(
          WebsiteSelection value, $Res Function(WebsiteSelection) then) =
      _$WebsiteSelectionCopyWithImpl<$Res, WebsiteSelection>;
  @useResult
  $Res call({String name, String genesisAddress});
}

/// @nodoc
class _$WebsiteSelectionCopyWithImpl<$Res, $Val extends WebsiteSelection>
    implements $WebsiteSelectionCopyWith<$Res> {
  _$WebsiteSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? genesisAddress = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WebsiteSelectionCopyWith<$Res>
    implements $WebsiteSelectionCopyWith<$Res> {
  factory _$$_WebsiteSelectionCopyWith(
          _$_WebsiteSelection value, $Res Function(_$_WebsiteSelection) then) =
      __$$_WebsiteSelectionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String genesisAddress});
}

/// @nodoc
class __$$_WebsiteSelectionCopyWithImpl<$Res>
    extends _$WebsiteSelectionCopyWithImpl<$Res, _$_WebsiteSelection>
    implements _$$_WebsiteSelectionCopyWith<$Res> {
  __$$_WebsiteSelectionCopyWithImpl(
      _$_WebsiteSelection _value, $Res Function(_$_WebsiteSelection) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? genesisAddress = null,
  }) {
    return _then(_$_WebsiteSelection(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genesisAddress: null == genesisAddress
          ? _value.genesisAddress
          : genesisAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_WebsiteSelection implements _WebsiteSelection {
  const _$_WebsiteSelection({required this.name, required this.genesisAddress});

  @override
  final String name;
  @override
  final String genesisAddress;

  @override
  String toString() {
    return 'WebsiteSelection(name: $name, genesisAddress: $genesisAddress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WebsiteSelection &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.genesisAddress, genesisAddress) ||
                other.genesisAddress == genesisAddress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, genesisAddress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WebsiteSelectionCopyWith<_$_WebsiteSelection> get copyWith =>
      __$$_WebsiteSelectionCopyWithImpl<_$_WebsiteSelection>(this, _$identity);
}

abstract class _WebsiteSelection implements WebsiteSelection {
  const factory _WebsiteSelection(
      {required final String name,
      required final String genesisAddress}) = _$_WebsiteSelection;

  @override
  String get name;
  @override
  String get genesisAddress;
  @override
  @JsonKey(ignore: true)
  _$$_WebsiteSelectionCopyWith<_$_WebsiteSelection> get copyWith =>
      throw _privateConstructorUsedError;
}
