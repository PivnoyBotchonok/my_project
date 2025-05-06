import 'package:flutter/material.dart';
import 'package:my_project/data/repositories/word_repo.dart';
import 'package:my_project/features/endless_game/logic/game_controller.dart';
import 'package:my_project/features/endless_game/widgets/option_button.dart';
import 'package:my_project/features/endless_game/widgets/score_badge.dart';

class EndlessGameScreen extends StatefulWidget {
  const EndlessGameScreen({super.key});

  @override
  State<EndlessGameScreen> createState() => _EndlessGameScreenState();
}

class _EndlessGameScreenState extends State<EndlessGameScreen> {
  late GameController _controller;
  bool _isLoading = true;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  void _loadWords() {
    final words = HiveService.getWords();
    if (words.isEmpty) return;
    _controller = GameController(words);

    setState(() => _isLoading = false);
  }

  void _handleTap(int index) {
    final correct = _controller.handleAnswer(index);
    setState(() => _selectedIndex = index);

    if (correct) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _controller.nextQuestion();
          _selectedIndex = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Бесконечный режим')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _controller.currentWord.ru,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 150),
                ...List.generate(_controller.options.length, (i) {
                  final color = _getColorForIndex(i);
                  return Column(
                    children: [
                      OptionButton(
                        text: _controller.options[i],
                        color: color,
                        onPressed: () => _handleTap(i),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 50,
            child: ScoreBadge(score: _controller.score),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    if (_selectedIndex == null) return Colors.white;
    if (index == _controller.correctOptionIndex && index == _selectedIndex) return Colors.green;
    if (_controller.wrongAttempts.contains(index)) return Colors.red;
    return Colors.white;
  }
}
