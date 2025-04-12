import 'dart:async';
import 'package:flutter/services.dart';

class KeyboardService {
  final _controller = StreamController<LogicalKeyboardKey>.broadcast();
  final Set<PhysicalKeyboardKey> _pressedKeys = {};

  Stream<LogicalKeyboardKey> get keyStream => _controller.stream;

  Future<void> initialize() async {
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (!_pressedKeys.contains(event.physicalKey)) {
        _pressedKeys.add(event.physicalKey);
        _controller.add(event.logicalKey);
      }
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.physicalKey);
    }
    return true;
  }

  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _controller.close();
    _pressedKeys.clear();
  }
}
