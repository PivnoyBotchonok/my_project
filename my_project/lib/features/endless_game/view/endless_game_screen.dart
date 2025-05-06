import 'package:flutter/material.dart';

class EndlessGameScreen extends StatefulWidget {
  const EndlessGameScreen({super.key});

  @override
  State<EndlessGameScreen> createState() => _EndlessGameScreenState();
}

class _EndlessGameScreenState extends State<EndlessGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бесконечный режим')),
      body: Stack(
        children: [
          // Основной контент
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Пример", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 150),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Ответ 1"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Ответ 1"),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Ответ 1"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Элемент с звездой и счетчиком
          Positioned(
            left: 20,
            bottom: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1A000000), // 10% opacity black
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow),
                  const SizedBox(width: 8),
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
