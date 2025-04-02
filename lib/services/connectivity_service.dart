import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  bool _isOnline = false;

  bool get isOnline => _isOnline;

  Future<void> initialize() async {
    _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectivityStatus(results.first);
    });
    await _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectivityStatus(results.first);
  }

  void _updateConnectivityStatus(ConnectivityResult result) {
    _isOnline = result != ConnectivityResult.none;
  }

  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged
      .map((results) => results.first != ConnectivityResult.none);
}
