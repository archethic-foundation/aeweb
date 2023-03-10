// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_pool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ActionPool {
  List<Action> get actions => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActionPoolCopyWith<ActionPool> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionPoolCopyWith<$Res> {
  factory $ActionPoolCopyWith(
          ActionPool value, $Res Function(ActionPool) then) =
      _$ActionPoolCopyWithImpl<$Res, ActionPool>;
  @useResult
  $Res call({List<Action> actions});
}

/// @nodoc
class _$ActionPoolCopyWithImpl<$Res, $Val extends ActionPool>
    implements $ActionPoolCopyWith<$Res> {
  _$ActionPoolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actions = null,
  }) {
    return _then(_value.copyWith(
      actions: null == actions
          ? _value.actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<Action>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ActionPoolCopyWith<$Res>
    implements $ActionPoolCopyWith<$Res> {
  factory _$$_ActionPoolCopyWith(
          _$_ActionPool value, $Res Function(_$_ActionPool) then) =
      __$$_ActionPoolCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Action> actions});
}

/// @nodoc
class __$$_ActionPoolCopyWithImpl<$Res>
    extends _$ActionPoolCopyWithImpl<$Res, _$_ActionPool>
    implements _$$_ActionPoolCopyWith<$Res> {
  __$$_ActionPoolCopyWithImpl(
      _$_ActionPool _value, $Res Function(_$_ActionPool) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actions = null,
  }) {
    return _then(_$_ActionPool(
      actions: null == actions
          ? _value._actions
          : actions // ignore: cast_nullable_to_non_nullable
              as List<Action>,
    ));
  }
}

/// @nodoc

class _$_ActionPool implements _ActionPool {
  const _$_ActionPool({required final List<Action> actions})
      : _actions = actions;

  final List<Action> _actions;
  @override
  List<Action> get actions {
    if (_actions is EqualUnmodifiableListView) return _actions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actions);
  }

  @override
  String toString() {
    return 'ActionPool(actions: $actions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ActionPool &&
            const DeepCollectionEquality().equals(other._actions, _actions));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_actions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ActionPoolCopyWith<_$_ActionPool> get copyWith =>
      __$$_ActionPoolCopyWithImpl<_$_ActionPool>(this, _$identity);
}

abstract class _ActionPool implements ActionPool {
  const factory _ActionPool({required final List<Action> actions}) =
      _$_ActionPool;

  @override
  List<Action> get actions;
  @override
  @JsonKey(ignore: true)
  _$$_ActionPoolCopyWith<_$_ActionPool> get copyWith =>
      throw _privateConstructorUsedError;
}
