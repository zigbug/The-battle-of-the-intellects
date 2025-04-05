import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_event.dart';
part 'menu_state.dart';
part 'menu_bloc.freezed.dart';

// @freezed
// sealed class MenuEvent with _$MenuEvent {
//   const factory MenuEvent.show() = _Show;
//   const factory MenuEvent.hide() = _Hide;
// }

// @freezed
// sealed class MenuState with _$MenuState {
//   const factory MenuState.initial() = _Initial;
//   const factory MenuState.visible() = _Visible;
// }

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState.initial()) {
    on<_Show>((event, emit) => emit(const MenuState.visible()));
    on<_Hide>((event, emit) => emit(const MenuState.initial()));
  }
}
