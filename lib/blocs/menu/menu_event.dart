part of 'menu_bloc.dart';

@freezed
class MenuEvent with _$MenuEvent {
  const factory MenuEvent.show() = _Show;
  const factory MenuEvent.hide() = _Hide;
}
