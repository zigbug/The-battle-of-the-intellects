import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = false;
  bool _isInitialized = false;

  bool get isOnline => _isOnline;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _connectivity.onConnectivityChanged.listen((result) {
        _updateConnectivityStatus(result);
      });
      await _checkConnectivity();
      _isInitialized = true;
    } catch (e) {
      print('Error initializing connectivity service: $e');
      _isOnline = false;
      _isInitialized = true;
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(result);
    } catch (e) {
      print('Error checking connectivity: $e');
      _isOnline = false;
    }
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    _isOnline = result != ConnectivityResult.none;
  }

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map((result) => result != ConnectivityResult.none);
}
