import 'package:flutter/material.dart';
import 'package:uganda/start_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text to Speech App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TeamInputPage(),
    );
  }
}
