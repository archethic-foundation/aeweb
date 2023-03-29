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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AddWebsiteFormState {
  int get addWebsiteProcessStep => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  String get publicCertPath => throw _privateConstructorUsedError;
  String get privateKeyPath => throw _privateConstructorUsedError;
  bool? get applyGitIgnoreRules => throw _privateConstructorUsedError;
  String get errorText => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddWebsiteFormStateCopyWith<AddWebsiteFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddWebsiteFormStateCopyWith<$Res> {
  factory $AddWebsiteFormStateCopyWith(
          AddWebsiteFormState value, $Res Function(AddWebsiteFormState) then) =
      _$AddWebsiteFormStateCopyWithImpl<$Res, AddWebsiteFormState>;
  @useResult
  $Res call(
      {int addWebsiteProcessStep,
      String name,
      String path,
      String publicCertPath,
      String privateKeyPath,
      bool? applyGitIgnoreRules,
      String errorText});
}

/// @nodoc
class _$AddWebsiteFormStateCopyWithImpl<$Res, $Val extends AddWebsiteFormState>
    implements $AddWebsiteFormStateCopyWith<$Res> {
  _$AddWebsiteFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addWebsiteProcessStep = null,
    Object? name = null,
    Object? path = null,
    Object? publicCertPath = null,
    Object? privateKeyPath = null,
    Object? applyGitIgnoreRules = freezed,
    Object? errorText = null,
  }) {
    return _then(_value.copyWith(
      addWebsiteProcessStep: null == addWebsiteProcessStep
          ? _value.addWebsiteProcessStep
          : addWebsiteProcessStep // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      publicCertPath: null == publicCertPath
          ? _value.publicCertPath
          : publicCertPath // ignore: cast_nullable_to_non_nullable
              as String,
      privateKeyPath: null == privateKeyPath
          ? _value.privateKeyPath
          : privateKeyPath // ignore: cast_nullable_to_non_nullable
              as String,
      applyGitIgnoreRules: freezed == applyGitIgnoreRules
          ? _value.applyGitIgnoreRules
          : applyGitIgnoreRules // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorText: null == errorText
          ? _value.errorText
          : errorText // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AddWebsiteFormStateCopyWith<$Res>
    implements $AddWebsiteFormStateCopyWith<$Res> {
  factory _$$_AddWebsiteFormStateCopyWith(_$_AddWebsiteFormState value,
          $Res Function(_$_AddWebsiteFormState) then) =
      __$$_AddWebsiteFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int addWebsiteProcessStep,
      String name,
      String path,
      String publicCertPath,
      String privateKeyPath,
      bool? applyGitIgnoreRules,
      String errorText});
}

/// @nodoc
class __$$_AddWebsiteFormStateCopyWithImpl<$Res>
    extends _$AddWebsiteFormStateCopyWithImpl<$Res, _$_AddWebsiteFormState>
    implements _$$_AddWebsiteFormStateCopyWith<$Res> {
  __$$_AddWebsiteFormStateCopyWithImpl(_$_AddWebsiteFormState _value,
      $Res Function(_$_AddWebsiteFormState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addWebsiteProcessStep = null,
    Object? name = null,
    Object? path = null,
    Object? publicCertPath = null,
    Object? privateKeyPath = null,
    Object? applyGitIgnoreRules = freezed,
    Object? errorText = null,
  }) {
    return _then(_$_AddWebsiteFormState(
      addWebsiteProcessStep: null == addWebsiteProcessStep
          ? _value.addWebsiteProcessStep
          : addWebsiteProcessStep // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      publicCertPath: null == publicCertPath
          ? _value.publicCertPath
          : publicCertPath // ignore: cast_nullable_to_non_nullable
              as String,
      privateKeyPath: null == privateKeyPath
          ? _value.privateKeyPath
          : privateKeyPath // ignore: cast_nullable_to_non_nullable
              as String,
      applyGitIgnoreRules: freezed == applyGitIgnoreRules
          ? _value.applyGitIgnoreRules
          : applyGitIgnoreRules // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorText: null == errorText
          ? _value.errorText
          : errorText // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AddWebsiteFormState extends _AddWebsiteFormState {
  const _$_AddWebsiteFormState(
      {this.addWebsiteProcessStep = 0,
      this.name = '',
      this.path = '',
      this.publicCertPath = '',
      this.privateKeyPath = '',
      this.applyGitIgnoreRules,
      this.errorText = ''})
      : super._();

  @override
  @JsonKey()
  final int addWebsiteProcessStep;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String path;
  @override
  @JsonKey()
  final String publicCertPath;
  @override
  @JsonKey()
  final String privateKeyPath;
  @override
  final bool? applyGitIgnoreRules;
  @override
  @JsonKey()
  final String errorText;

  @override
  String toString() {
    return 'AddWebsiteFormState(addWebsiteProcessStep: $addWebsiteProcessStep, name: $name, path: $path, publicCertPath: $publicCertPath, privateKeyPath: $privateKeyPath, applyGitIgnoreRules: $applyGitIgnoreRules, errorText: $errorText)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AddWebsiteFormState &&
            (identical(other.addWebsiteProcessStep, addWebsiteProcessStep) ||
                other.addWebsiteProcessStep == addWebsiteProcessStep) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.publicCertPath, publicCertPath) ||
                other.publicCertPath == publicCertPath) &&
            (identical(other.privateKeyPath, privateKeyPath) ||
                other.privateKeyPath == privateKeyPath) &&
            (identical(other.applyGitIgnoreRules, applyGitIgnoreRules) ||
                other.applyGitIgnoreRules == applyGitIgnoreRules) &&
            (identical(other.errorText, errorText) ||
                other.errorText == errorText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, addWebsiteProcessStep, name,
      path, publicCertPath, privateKeyPath, applyGitIgnoreRules, errorText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AddWebsiteFormStateCopyWith<_$_AddWebsiteFormState> get copyWith =>
      __$$_AddWebsiteFormStateCopyWithImpl<_$_AddWebsiteFormState>(
          this, _$identity);
}

abstract class _AddWebsiteFormState extends AddWebsiteFormState {
  const factory _AddWebsiteFormState(
      {final int addWebsiteProcessStep,
      final String name,
      final String path,
      final String publicCertPath,
      final String privateKeyPath,
      final bool? applyGitIgnoreRules,
      final String errorText}) = _$_AddWebsiteFormState;
  const _AddWebsiteFormState._() : super._();

  @override
  int get addWebsiteProcessStep;
  @override
  String get name;
  @override
  String get path;
  @override
  String get publicCertPath;
  @override
  String get privateKeyPath;
  @override
  bool? get applyGitIgnoreRules;
  @override
  String get errorText;
  @override
  @JsonKey(ignore: true)
  _$$_AddWebsiteFormStateCopyWith<_$_AddWebsiteFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
