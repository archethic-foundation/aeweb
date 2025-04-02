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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HostingContentComparison {
  String get path => throw _privateConstructorUsedError;
  HostingContentComparisonStatus get status =>
      throw _privateConstructorUsedError;

  /// Create a copy of HostingContentComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of HostingContentComparison
  /// with the given fields replaced by the non-null parameter values.
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
abstract class _$$HostingContentComparisonImplCopyWith<$Res>
    implements $HostingContentComparisonCopyWith<$Res> {
  factory _$$HostingContentComparisonImplCopyWith(
          _$HostingContentComparisonImpl value,
          $Res Function(_$HostingContentComparisonImpl) then) =
      __$$HostingContentComparisonImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, HostingContentComparisonStatus status});
}

/// @nodoc
class __$$HostingContentComparisonImplCopyWithImpl<$Res>
    extends _$HostingContentComparisonCopyWithImpl<$Res,
        _$HostingContentComparisonImpl>
    implements _$$HostingContentComparisonImplCopyWith<$Res> {
  __$$HostingContentComparisonImplCopyWithImpl(
      _$HostingContentComparisonImpl _value,
      $Res Function(_$HostingContentComparisonImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostingContentComparison
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? status = null,
  }) {
    return _then(_$HostingContentComparisonImpl(
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

class _$HostingContentComparisonImpl implements _HostingContentComparison {
  const _$HostingContentComparisonImpl(
      {required this.path, required this.status});

  @override
  final String path;
  @override
  final HostingContentComparisonStatus status;

  @override
  String toString() {
    return 'HostingContentComparison(path: $path, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostingContentComparisonImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path, status);

  /// Create a copy of HostingContentComparison
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostingContentComparisonImplCopyWith<_$HostingContentComparisonImpl>
      get copyWith => __$$HostingContentComparisonImplCopyWithImpl<
          _$HostingContentComparisonImpl>(this, _$identity);
}

abstract class _HostingContentComparison implements HostingContentComparison {
  const factory _HostingContentComparison(
          {required final String path,
          required final HostingContentComparisonStatus status}) =
      _$HostingContentComparisonImpl;

  @override
  String get path;
  @override
  HostingContentComparisonStatus get status;

  /// Create a copy of HostingContentComparison
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostingContentComparisonImplCopyWith<_$HostingContentComparisonImpl>
      get copyWith => throw _privateConstructorUsedError;
}
