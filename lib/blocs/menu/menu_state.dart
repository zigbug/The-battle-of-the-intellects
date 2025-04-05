part of 'menu_bloc.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState.initial() = _Initial;
  const factory MenuState.visible() = _Visible;
}
