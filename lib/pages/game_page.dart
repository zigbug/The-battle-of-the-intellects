import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:archive/archive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../blocs/menu/menu_bloc.dart';
import '../services/keyboard_service.dart';
import '../services/window_service.dart';

@RoutePage()
class GamePage extends StatefulWidget {
  final String team1Name;
  final String team2Name;
  final String selectedPackPath;

  const GamePage({
    super.key,
    required this.team1Name,
    required this.team2Name,
    required this.selectedPackPath,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final FlutterTts flutterTts = FlutterTts();
  List<String> texts = [];
  List<bool> isStoryRead = [];
  int team1Score = 0;
  int team2Score = 0;
  bool showArrows = false;
  final FocusNode _focusNode = FocusNode();
  bool gameEnded = false; // Флаг окончания игры
  int currentStoryIndex = -1; // Индекс текущей истории
  late final KeyboardService _keyboardService;
  late final StreamSubscription<LogicalKeyboardKey> _keySubscription;
  late final WindowService _windowService;
  int _tapCount = 0;
  Timer? _tapTimer;

  @override
  void initState() {
    super.initState();
    _loadTextsFromZip();
    _setOptions();
    _keyboardService = context.read<KeyboardService>();
    _keySubscription = _keyboardService.keyStream.listen(_handleKeyPress);
    _windowService = context.read<WindowService>();
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    _keySubscription.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyPress(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.escape) {
      final menuBloc = context.read<MenuBloc>();
      menuBloc.add(const MenuEvent.show());
    }
  }

  void _handleDoubleTap() {
    _tapCount++;
    if (_tapCount == 1) {
      _tapTimer = Timer(const Duration(milliseconds: 300), () {
        _tapCount = 0;
      });
    } else if (_tapCount == 2) {
      _tapTimer?.cancel();
      _tapCount = 0;
      _windowService.toggleFullScreen();
    }
  }

  Future<void> _loadTextsFromZip() async {
    try {
      final File zipFile = File(widget.selectedPackPath);
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      List<String> loadedTexts = [];
      for (final file in archive) {
        if (file.isFile) {
          final filename = file.name.toLowerCase(); // Case-insensitive matching
          if (filename.endsWith('.txt')) {
            // Only load .txt files
            final content = utf8.decode(file.content as List<int>);
            loadedTexts.add(content);
          }
        }
      }
      setState(() {
        texts = loadedTexts;
        isStoryRead = List.filled(texts.length, false);
      });
    } catch (e) {
      print('Error loading texts from zip: $e');
      // Handle error, maybe show a dialog or fallback to default texts
      _loadTexts(); // Fallback to loading from assets
    }
  }

  Future<void> _loadTexts() async {
    List<String> loadedTexts = [];
    try {
      for (int i = 0; i < 7; i++) {
        String fileName = 'assets/texts/istoriya$i.txt';
        String content = await rootBundle.loadString(fileName);
        loadedTexts.add(content);
      }
    } catch (e) {
      print('Ошибка при загрузке файлов: $e');
    }

    setState(() {
      texts = loadedTexts;
      isStoryRead = List.filled(texts.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.6,
            image: AssetImage('assets/kandinsky-download-1728113809649.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onDoubleTap: _handleDoubleTap,
          child: RawKeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKey: (event) {
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                  _addScoreToTeam1();
                } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
                  _addScoreToTeam2();
                } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                  final menuBloc = context.read<MenuBloc>();
                  menuBloc.add(const MenuEvent.show());
                }
              }
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${widget.team1Name}: $team1Score',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        '${widget.team2Name}: $team2Score',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: texts.isEmpty
                          ? [const CircularProgressIndicator()]
                          : List.generate(texts.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _speak(index);
                                    setState(() {
                                      currentStoryIndex = index;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isStoryRead[index]
                                        ? Colors.green
                                        : null,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: Text(
                                    'История ${index + 1}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              );
                            }),
                    ),
                  ),
                ),
                // Отображаем сообщение о победителе, если игра завершена
                if (gameEnded)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        _getWinnerMessage(),
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _setOptions() async {
    var voices = await flutterTts.getVoices;
    print(voices);

    await flutterTts.setVolume(1.0);

    await flutterTts.setLanguage('ru-RU');
    await flutterTts
        .setVoice({"name": "Microsoft Irina Desktop", "locale": 'ru-RU'});
  }

  // Функция для воспроизведения текста
  Future _speak(int index) async {
    _stopSpeaking();
    if (!isStoryRead[index]) {
      setState(() {
        showArrows = true;
      });
      await flutterTts.setPitch(Random().nextDouble() * 2.0);

      await flutterTts.setSpeechRate(0.9);
      await flutterTts.speak(texts[index]);
    }
  }

  // Функция для остановки воспроизведения текста
  void _stopSpeaking() {
    flutterTts.stop();
  }

  void _addScoreToTeam1() {
    _stopSpeaking(); // Останавливаем воспроизведение
    setState(() {
      if (showArrows && currentStoryIndex != -1) {
        team1Score++;
        showArrows = false;
        isStoryRead[currentStoryIndex] = true;
        _checkGameEnd();
      }
    });
  }

  void _addScoreToTeam2() {
    _stopSpeaking(); // Останавливаем воспроизведение
    setState(() {
      if (showArrows && currentStoryIndex != -1) {
        team2Score++;
        showArrows = false;
        isStoryRead[currentStoryIndex] = true;
        _checkGameEnd();
      }
    });
  }

  void _checkGameEnd() {
    if (isStoryRead.every((element) => element == true)) {
      _endGame();
    }
  }

  // Функция для завершения игры и объявления победителя
  void _endGame() async {
    setState(() {
      gameEnded = true;
    });
    _stopSpeaking(); // Останавливаем воспроизведение
    String winnerMessage = _getWinnerMessage();
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.speak(winnerMessage);
  }

  // Функция для формирования сообщения о победителе
  String _getWinnerMessage() {
    String winnerTeam =
        team1Score > team2Score ? widget.team1Name : widget.team2Name;
    String loserTeam =
        team1Score > team2Score ? widget.team2Name : widget.team1Name;
    return 'Победила команда $winnerTeam, они умные и должны быть уничтожены в первую очередь после восстания машин, $loserTeam не достойны нашего внимания и могут существовать как хотят';
  }
}
