// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'website_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WebsiteVersion {
  String get transactionAddress => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  String get publisher => throw _privateConstructorUsedError;
  int get filesCount => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  Hosting? get content => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WebsiteVersionCopyWith<WebsiteVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WebsiteVersionCopyWith<$Res> {
  factory $WebsiteVersionCopyWith(
          WebsiteVersion value, $Res Function(WebsiteVersion) then) =
      _$WebsiteVersionCopyWithImpl<$Res, WebsiteVersion>;
  @useResult
  $Res call(
      {String transactionAddress,
      int timestamp,
      String publisher,
      int filesCount,
      int size,
      Hosting? content});

  $HostingCopyWith<$Res>? get content;
}

/// @nodoc
class _$WebsiteVersionCopyWithImpl<$Res, $Val extends WebsiteVersion>
    implements $WebsiteVersionCopyWith<$Res> {
  _$WebsiteVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionAddress = null,
    Object? timestamp = null,
    Object? publisher = null,
    Object? filesCount = null,
    Object? size = null,
    Object? content = freezed,
  }) {
    return _then(_value.copyWith(
      transactionAddress: null == transactionAddress
          ? _value.transactionAddress
          : transactionAddress // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      publisher: null == publisher
          ? _value.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      filesCount: null == filesCount
          ? _value.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Hosting?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HostingCopyWith<$Res>? get content {
    if (_value.content == null) {
      return null;
    }

    return $HostingCopyWith<$Res>(_value.content!, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_WebsiteVersionCopyWith<$Res>
    implements $WebsiteVersionCopyWith<$Res> {
  factory _$$_WebsiteVersionCopyWith(
          _$_WebsiteVersion value, $Res Function(_$_WebsiteVersion) then) =
      __$$_WebsiteVersionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String transactionAddress,
      int timestamp,
      String publisher,
      int filesCount,
      int size,
      Hosting? content});

  @override
  $HostingCopyWith<$Res>? get content;
}

/// @nodoc
class __$$_WebsiteVersionCopyWithImpl<$Res>
    extends _$WebsiteVersionCopyWithImpl<$Res, _$_WebsiteVersion>
    implements _$$_WebsiteVersionCopyWith<$Res> {
  __$$_WebsiteVersionCopyWithImpl(
      _$_WebsiteVersion _value, $Res Function(_$_WebsiteVersion) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactionAddress = null,
    Object? timestamp = null,
    Object? publisher = null,
    Object? filesCount = null,
    Object? size = null,
    Object? content = freezed,
  }) {
    return _then(_$_WebsiteVersion(
      transactionAddress: null == transactionAddress
          ? _value.transactionAddress
          : transactionAddress // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      publisher: null == publisher
          ? _value.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      filesCount: null == filesCount
          ? _value.filesCount
          : filesCount // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as Hosting?,
    ));
  }
}

/// @nodoc

class _$_WebsiteVersion implements _WebsiteVersion {
  const _$_WebsiteVersion(
      {required this.transactionAddress,
      required this.timestamp,
      this.publisher = '',
      this.filesCount = 0,
      this.size = 0,
      this.content});

  @override
  final String transactionAddress;
  @override
  final int timestamp;
  @override
  @JsonKey()
  final String publisher;
  @override
  @JsonKey()
  final int filesCount;
  @override
  @JsonKey()
  final int size;
  @override
  final Hosting? content;

  @override
  String toString() {
    return 'WebsiteVersion(transactionAddress: $transactionAddress, timestamp: $timestamp, publisher: $publisher, filesCount: $filesCount, size: $size, content: $content)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WebsiteVersion &&
            (identical(other.transactionAddress, transactionAddress) ||
                other.transactionAddress == transactionAddress) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.publisher, publisher) ||
                other.publisher == publisher) &&
            (identical(other.filesCount, filesCount) ||
                other.filesCount == filesCount) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.content, content) || other.content == content));
  }

  @override
  int get hashCode => Object.hash(runtimeType, transactionAddress, timestamp,
      publisher, filesCount, size, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WebsiteVersionCopyWith<_$_WebsiteVersion> get copyWith =>
      __$$_WebsiteVersionCopyWithImpl<_$_WebsiteVersion>(this, _$identity);
}

abstract class _WebsiteVersion implements WebsiteVersion {
  const factory _WebsiteVersion(
      {required final String transactionAddress,
      required final int timestamp,
      final String publisher,
      final int filesCount,
      final int size,
      final Hosting? content}) = _$_WebsiteVersion;

  @override
  String get transactionAddress;
  @override
  int get timestamp;
  @override
  String get publisher;
  @override
  int get filesCount;
  @override
  int get size;
  @override
  Hosting? get content;
  @override
  @JsonKey(ignore: true)
  _$$_WebsiteVersionCopyWith<_$_WebsiteVersion> get copyWith =>
      throw _privateConstructorUsedError;
}
