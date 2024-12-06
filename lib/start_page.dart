import 'package:flutter/material.dart';
import 'game_page.dart';
import 'package:file_picker/file_picker.dart';

class TeamInputPage extends StatefulWidget {
  const TeamInputPage({Key? key}) : super(key: key);

  @override
  State<TeamInputPage> createState() => _TeamInputPageState();
}

class _TeamInputPageState extends State<TeamInputPage> {
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();
  String? _selectedPackPath;

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
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.srcOver),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Text(
                  'Битва интеллектов',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lobster',
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
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['zip'], // Allow only zip files
                  );
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      _selectedPackPath = result.files.single.path;
                    });
                  }
                },
                child: const Text('Выбрать пак заданий (zip)'),
              ),
              if (_selectedPackPath != null)
                Text('Выбранный пак: $_selectedPackPath'),
              ElevatedButton(
                onPressed: _selectedPackPath != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamePage(
                              team1Name: _team1Controller.text,
                              team2Name: _team2Controller.text,
                              selectedPackPath: _selectedPackPath!,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Готово'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
