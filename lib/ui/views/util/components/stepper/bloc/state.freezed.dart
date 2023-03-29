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
mixin _$AEStepperState {
  List<StepperData> get stepperList => throw _privateConstructorUsedError;
  int get activeIndex => throw _privateConstructorUsedError;
  Axis? get axis => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AEStepperStateCopyWith<AEStepperState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AEStepperStateCopyWith<$Res> {
  factory $AEStepperStateCopyWith(
          AEStepperState value, $Res Function(AEStepperState) then) =
      _$AEStepperStateCopyWithImpl<$Res, AEStepperState>;
  @useResult
  $Res call({List<StepperData> stepperList, int activeIndex, Axis? axis});
}

/// @nodoc
class _$AEStepperStateCopyWithImpl<$Res, $Val extends AEStepperState>
    implements $AEStepperStateCopyWith<$Res> {
  _$AEStepperStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stepperList = null,
    Object? activeIndex = null,
    Object? axis = freezed,
  }) {
    return _then(_value.copyWith(
      stepperList: null == stepperList
          ? _value.stepperList
          : stepperList // ignore: cast_nullable_to_non_nullable
              as List<StepperData>,
      activeIndex: null == activeIndex
          ? _value.activeIndex
          : activeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      axis: freezed == axis
          ? _value.axis
          : axis // ignore: cast_nullable_to_non_nullable
              as Axis?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AEStepperStateCopyWith<$Res>
    implements $AEStepperStateCopyWith<$Res> {
  factory _$$_AEStepperStateCopyWith(
          _$_AEStepperState value, $Res Function(_$_AEStepperState) then) =
      __$$_AEStepperStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StepperData> stepperList, int activeIndex, Axis? axis});
}

/// @nodoc
class __$$_AEStepperStateCopyWithImpl<$Res>
    extends _$AEStepperStateCopyWithImpl<$Res, _$_AEStepperState>
    implements _$$_AEStepperStateCopyWith<$Res> {
  __$$_AEStepperStateCopyWithImpl(
      _$_AEStepperState _value, $Res Function(_$_AEStepperState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stepperList = null,
    Object? activeIndex = null,
    Object? axis = freezed,
  }) {
    return _then(_$_AEStepperState(
      stepperList: null == stepperList
          ? _value._stepperList
          : stepperList // ignore: cast_nullable_to_non_nullable
              as List<StepperData>,
      activeIndex: null == activeIndex
          ? _value.activeIndex
          : activeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      axis: freezed == axis
          ? _value.axis
          : axis // ignore: cast_nullable_to_non_nullable
              as Axis?,
    ));
  }
}

/// @nodoc

class _$_AEStepperState extends _AEStepperState {
  const _$_AEStepperState(
      {final List<StepperData> stepperList = const [],
      this.activeIndex = 0,
      this.axis})
      : _stepperList = stepperList,
        super._();

  final List<StepperData> _stepperList;
  @override
  @JsonKey()
  List<StepperData> get stepperList {
    if (_stepperList is EqualUnmodifiableListView) return _stepperList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stepperList);
  }

  @override
  @JsonKey()
  final int activeIndex;
  @override
  final Axis? axis;

  @override
  String toString() {
    return 'AEStepperState(stepperList: $stepperList, activeIndex: $activeIndex, axis: $axis)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AEStepperState &&
            const DeepCollectionEquality()
                .equals(other._stepperList, _stepperList) &&
            (identical(other.activeIndex, activeIndex) ||
                other.activeIndex == activeIndex) &&
            (identical(other.axis, axis) || other.axis == axis));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_stepperList), activeIndex, axis);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AEStepperStateCopyWith<_$_AEStepperState> get copyWith =>
      __$$_AEStepperStateCopyWithImpl<_$_AEStepperState>(this, _$identity);
}

abstract class _AEStepperState extends AEStepperState {
  const factory _AEStepperState(
      {final List<StepperData> stepperList,
      final int activeIndex,
      final Axis? axis}) = _$_AEStepperState;
  const _AEStepperState._() : super._();

  @override
  List<StepperData> get stepperList;
  @override
  int get activeIndex;
  @override
  Axis? get axis;
  @override
  @JsonKey(ignore: true)
  _$$_AEStepperStateCopyWith<_$_AEStepperState> get copyWith =>
      throw _privateConstructorUsedError;
}
