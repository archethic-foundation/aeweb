// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_website.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HostingContentComparison {
  String get path => throw _privateConstructorUsedError;
  HostingContentComparisonStatus get status =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HostingContentComparisonCopyWith<HostingContentComparison> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostingContentComparisonCopyWith<$Res> {
  factory $HostingContentComparisonCopyWith(HostingContentComparison value,
          $Res Function(HostingContentComparison) then) =
      _$HostingContentComparisonCopyWithImpl<$Res, HostingContentComparison>;
  @useResult
  $Res call({String path, HostingContentComparisonStatus status});
}

/// @nodoc
class _$HostingContentComparisonCopyWithImpl<$Res,
        $Val extends HostingContentComparison>
    implements $HostingContentComparisonCopyWith<$Res> {
  _$HostingContentComparisonCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HostingContentComparisonStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HostingContentComparisonCopyWith<$Res>
    implements $HostingContentComparisonCopyWith<$Res> {
  factory _$$_HostingContentComparisonCopyWith(
          _$_HostingContentComparison value,
          $Res Function(_$_HostingContentComparison) then) =
      __$$_HostingContentComparisonCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, HostingContentComparisonStatus status});
}

/// @nodoc
class __$$_HostingContentComparisonCopyWithImpl<$Res>
    extends _$HostingContentComparisonCopyWithImpl<$Res,
        _$_HostingContentComparison>
    implements _$$_HostingContentComparisonCopyWith<$Res> {
  __$$_HostingContentComparisonCopyWithImpl(_$_HostingContentComparison _value,
      $Res Function(_$_HostingContentComparison) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? status = null,
  }) {
    return _then(_$_HostingContentComparison(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HostingContentComparisonStatus,
    ));
  }
}

/// @nodoc

class _$_HostingContentComparison implements _HostingContentComparison {
  const _$_HostingContentComparison({required this.path, required this.status});

  @override
  final String path;
  @override
  final HostingContentComparisonStatus status;

  @override
  String toString() {
    return 'HostingContentComparison(path: $path, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HostingContentComparison &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HostingContentComparisonCopyWith<_$_HostingContentComparison>
      get copyWith => __$$_HostingContentComparisonCopyWithImpl<
          _$_HostingContentComparison>(this, _$identity);
}

abstract class _HostingContentComparison implements HostingContentComparison {
  const factory _HostingContentComparison(
          {required final String path,
          required final HostingContentComparisonStatus status}) =
      _$_HostingContentComparison;

  @override
  String get path;
  @override
  HostingContentComparisonStatus get status;
  @override
  @JsonKey(ignore: true)
  _$$_HostingContentComparisonCopyWith<_$_HostingContentComparison>
      get copyWith => throw _privateConstructorUsedError;
}
