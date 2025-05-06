import 'package:flutter/material.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите режим')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/endless_game");
              },
              child: const Text('Бесконечный режим'),
            ),
            const SizedBox(height: 20), // Отступ между кнопками
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/crossword");
              },
              child: const Text('Кроссворд'),
            ),
            const SizedBox(height: 20), // Отступ между кнопками
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/dictionary");
              },
              child: const Text('Словарь'),
            ),
          ],
        ),
      ),
    );
  }
}
