import 'package:flutter/material.dart';
import 'game_page.dart';

class TeamInputPage extends StatefulWidget {
  const TeamInputPage({Key? key}) : super(key: key);

  @override
  State<TeamInputPage> createState() => _TeamInputPageState();
}

class _TeamInputPageState extends State<TeamInputPage> {
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ввод команд'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/kandinsky-download-1728049639323.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black54, BlendMode.srcOver), // Прозрачность 50%
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 50.0), // Добавлено отступ
                child: Text(
                  'Битва интеллектов',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lobster', // Пример декоративного шрифта
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _team1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Команда 1',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _team2Controller,
                  decoration: const InputDecoration(
                    labelText: 'Команда 2',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GamePage(
                        team1Name: _team1Controller.text,
                        team2Name: _team2Controller.text,
                      ),
                    ),
                  );
                },
                child: const Text('Готово'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
