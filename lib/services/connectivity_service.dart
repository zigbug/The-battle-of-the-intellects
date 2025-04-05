import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectivityStatus(result);
    });
    await _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(result);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    _isOnline = result != ConnectivityResult.none;
  }

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map((result) => result != ConnectivityResult.none);
}
