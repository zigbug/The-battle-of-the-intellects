import 'dart:async';
import 'package:flutter/services.dart';

class KeyboardService {
  final _controller = StreamController<LogicalKeyboardKey>.broadcast();

  Stream<LogicalKeyboardKey> get keyStream => _controller.stream;

  Future<void> initialize() async {
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      _controller.add(event.logicalKey);
    }
    return true;
  }

  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _controller.close();
  }
}
