import 'package:flutter/material.dart';
import 'package:uganda/pages/team_input_page.dart';
import 'package:uganda/services/connectivity_service.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  bool _isOnlineAvailable = false;

  @override
  void initState() {
    super.initState();
    _isOnlineAvailable = _connectivityService.isOnline;
    _connectivityService.onConnectivityChanged.listen((isOnline) {
      setState(() {
        _isOnlineAvailable = isOnline;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/start_page_back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
    );
  }
}
