import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:window_manager/window_manager.dart';
import '../blocs/menu/menu_bloc.dart';
import '../pages/start_page.dart';
import '../services/connectivity_service.dart';
import '../services/keyboard_service.dart';
import '../services/window_service.dart';

class MenuOverlay extends StatefulWidget {
  const MenuOverlay({super.key});

  @override
  State<MenuOverlay> createState() => _MenuOverlayState();
}

class _MenuOverlayState extends State<MenuOverlay> {
  late final KeyboardService _keyboardService;
  late final StreamSubscription<LogicalKeyboardKey> _keySubscription;
  bool _showExitDialog = false;
  bool _showSettings = false;
  late final WindowService _windowService;

  @override
  void initState() {
    super.initState();
    _keyboardService = context.read<KeyboardService>();
    _windowService = context.read<WindowService>();
    _keySubscription = _keyboardService.keyStream.listen(_handleKeyPress);
  }

  @override
  void dispose() {
    _keySubscription.cancel();
    super.dispose();
  }

  void _handleKeyPress(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      if (_showExitDialog) {
        setState(() {
          _showExitDialog = false;
        });
      } else if (_showSettings) {
        setState(() {
          _showSettings = false;
        });
      } else {
        final menuBloc = context.read<MenuBloc>();
        menuBloc.state.map(
          initial: (_) => menuBloc.add(const MenuEvent.show()),
          visible: (_) => menuBloc.add(const MenuEvent.hide()),
        );
      }
    }
  }

  Widget _buildMainMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Меню',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StartPage(
                          connectivityService:
                              context.read<ConnectivityService>(),
                        )),
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(200, 48),
          ),
          child: const Text(
            'Выйти в стартовое меню',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showSettings = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(200, 48),
          ),
          child: const Text(
            'Настройки',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showExitDialog = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(200, 48),
          ),
          child: const Text(
            'Выход',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Настройки',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Полноэкранный режим',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Switch(
              value: _windowService.isFullScreen,
              onChanged: (value) async {
                await _windowService.toggleFullScreen();
                setState(() {});
              },
              activeColor: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showSettings = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(200, 48),
          ),
          child: const Text(
            'Назад',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          visible: (_) => Stack(
            children: [
              // Фоновый затемнитель
              GestureDetector(
                onTap: () {
                  if (_showExitDialog) {
                    setState(() {
                      _showExitDialog = false;
                    });
                  } else if (_showSettings) {
                    setState(() {
                      _showSettings = false;
                    });
                  } else {
                    context.read<MenuBloc>().add(const MenuEvent.hide());
                  }
                },
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              // Меню
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child:
                        _showSettings ? _buildSettingsMenu() : _buildMainMenu(),
                  ),
                ),
              ),
              // Диалог выхода
              if (_showExitDialog)
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 350,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Выход',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Вы уверены, что хотите выйти из игры?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showExitDialog = false;
                                  });
                                },
                                child: const Text(
                                  'Отмена',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await windowManager.close();
                                },
                                child: const Text(
                                  'Выйти',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
