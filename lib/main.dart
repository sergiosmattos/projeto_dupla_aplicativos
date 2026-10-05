import 'package:flutter/material.dart';
import 'package:projeto_aula11_turma_b/views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToBuy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 89, 144),
        ),
        scaffoldBackgroundColor: Colors.pink.shade100,
      ),
      home: const HomePage(),
    );
  }
}
