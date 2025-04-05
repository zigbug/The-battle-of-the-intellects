import 'package:window_manager/window_manager.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/foundation.dart';

class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;

  final Size defaultWindowSize;
  final Size minimumWindowSize;
  final Duration transitionDelay;

  WindowService._internal({
    this.defaultWindowSize = const Size(1280, 720),
    this.minimumWindowSize = const Size(800, 600),
    this.transitionDelay = const Duration(milliseconds: 100),
  });

  bool _isFullScreen = false;

  Future<void> initialize({bool startFullscreen = false}) async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      fullScreen: startFullscreen,
      size: defaultWindowSize,
      minimumSize: minimumWindowSize,
      center: true,
    );

    _isFullScreen = startFullscreen;

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  Future<void> toggleFullScreen() async {
    try {
      _isFullScreen = !_isFullScreen;

      if (_isFullScreen) {
        await _safeWindowOperation(() => windowManager.setFullScreen(true));
      } else {
        await _safeWindowOperation(() => windowManager.setFullScreen(false));
        await _safeWindowOperation(
            () => windowManager.setSize(defaultWindowSize));
        await _safeWindowOperation(() => windowManager.center());
        await windowManager.focus();
      }
    } catch (e) {
      _recoverFromError(e);
    }
  }

  Future<void> _safeWindowOperation(Future Function() op) async {
    try {
      await op();
      await Future.delayed(transitionDelay ~/ 2);
    } catch (e) {
      await Future.delayed(transitionDelay);
      await op();
    }
  }

  Future<void> _recoverFromError(Object error) async {
    debugPrint('Window operation failed: $error');
    _isFullScreen = false;
    await windowManager.setFullScreen(false);
    await Future.delayed(transitionDelay);
    await windowManager.focus();
  }

  bool get isFullScreen => _isFullScreen;
}
