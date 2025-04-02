import 'package:window_manager/window_manager.dart';

class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();

  bool _isFullScreen = true;

  Future<void> initialize() async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      fullScreen: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  Future<void> toggleFullScreen() async {
    await windowManager.setFullScreen(!_isFullScreen);
    _isFullScreen = !_isFullScreen;
  }

  bool get isFullScreen => _isFullScreen;
}
