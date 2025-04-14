import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../services/connectivity_service.dart';
import 'team_input_page.dart';

@RoutePage()
class StartPage extends StatefulWidget {
  final ConnectivityService connectivityService;
  const StartPage({super.key, required this.connectivityService});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool _isOnlineAvailable = false;
  bool _isLoading = true;
  String? _error;
  late ConnectivityService _connectivityService;

  @override
  void initState() {
    super.initState();
    _connectivityService = widget.connectivityService;
    _initializeConnectivity();
  }

  Future<void> _initializeConnectivity() async {
    try {
      await _connectivityService.initialize();
      setState(() {
        _isOnlineAvailable = _connectivityService.isOnline;
        _isLoading = false;
      });

      _connectivityService.onConnectivityChanged.listen((isOnline) {
        if (mounted) {
          setState(() {
            _isOnlineAvailable = isOnline;
          });
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка инициализации: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/start_page_back.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Ошибка загрузки фонового изображения',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : _error != null
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'The Battle of the Intellects',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TeamInputPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                textStyle: const TextStyle(fontSize: 24),
                              ),
                              child: const Text('Автономная игра'),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isOnlineAvailable
                                  ? () {
                                      // TODO: Добавить навигацию к онлайн игре
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isOnlineAvailable
                                    ? Colors.blue.withOpacity(0.8)
                                    : Colors.grey.withOpacity(0.8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                textStyle: const TextStyle(fontSize: 24),
                              ),
                              child: const Text('Онлайн игра'),
                            ),
                            if (!_isOnlineAvailable)
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Нет подключения к интернету',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
