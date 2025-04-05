import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/menu/menu_bloc.dart';

class MenuOverlay extends StatelessWidget {
  const MenuOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          visible: (_) => RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                context.read<MenuBloc>().add(const MenuEvent.hide());
              }
            },
            child: GestureDetector(
              onTap: () => context.read<MenuBloc>().add(const MenuEvent.hide()),
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: GestureDetector(
                    onTap:
                        () {}, // Предотвращаем закрытие меню при клике по карточке
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Меню',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Добавить настройки
                                context
                                    .read<MenuBloc>()
                                    .add(const MenuEvent.hide());
                              },
                              child: const Text('Настройки'),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Выход'),
                                    content: const Text(
                                        'Вы уверены, что хотите выйти из игры?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('Отмена'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          SystemNavigator.pop();
                                        },
                                        child: const Text('Выйти'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Выход'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
