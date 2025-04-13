import 'package:flutter/material.dart';
import 'game_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamInputPage extends StatefulWidget {
  const TeamInputPage({super.key});

  @override
  State<TeamInputPage> createState() => _TeamInputPageState();
}

class _TeamInputPageState extends State<TeamInputPage> {
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();
  String? _selectedPackPath;

  @override
  void initState() {
    super.initState();
    _loadSavedPackPath();
  }

  Future<void> _loadSavedPackPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPackPath = prefs.getString('selectedPackPath');
    });
  }

  Future<void> _savePackPath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPackPath', path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['zip'],
                    );
                    if (result != null && result.files.single.path != null) {
                      String path = result.files.single.path!;
                      setState(() {
                        _selectedPackPath = path;
                      });
                      _savePackPath(path);
                    }
                  },
                  child: const Text('Выбрать пак заданий'),
                ),
              ),
              if (_selectedPackPath != null)
                Text('Выбранный пак: $_selectedPackPath'),
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _team1Controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Команда 1',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _team2Controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Команда 2',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
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
