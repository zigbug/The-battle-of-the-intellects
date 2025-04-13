import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'blocs/menu/menu_bloc.dart';
import 'pages/start_page.dart';
import 'widgets/menu_overlay.dart';
import 'services/window_service.dart';
import 'services/connectivity_service.dart';
import 'services/keyboard_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final windowService = WindowService();
  final connectivityService = ConnectivityService();
  final keyboardService = KeyboardService();

  await windowService.initialize();
  await connectivityService.initialize();
  await keyboardService.initialize();

  runApp(MyApp(
    windowService: windowService,
    connectivityService: connectivityService,
    keyboardService: keyboardService,
  ));
}

class MyApp extends StatelessWidget {
  final WindowService windowService;
  final ConnectivityService connectivityService;
  final KeyboardService keyboardService;

  const MyApp({
    super.key,
    required this.windowService,
    required this.connectivityService,
    required this.keyboardService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WindowService>.value(value: windowService),
        Provider<ConnectivityService>.value(value: connectivityService),
        Provider<KeyboardService>.value(value: keyboardService),
        BlocProvider(
          create: (context) => MenuBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Uganda Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              const MenuOverlay(),
            ],
          );
        },
        home: StartPage(
          connectivityService: connectivityService,
        ),
      ),
    );
  }
}
