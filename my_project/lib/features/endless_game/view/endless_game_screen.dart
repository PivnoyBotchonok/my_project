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
  GameController? _controller;
  bool _isLoading = true;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await HiveService.getWords();
    if (words.isEmpty) return;

    setState(() {
      _controller = GameController(words);
      _isLoading = false;
    });
  }

  void _handleTap(int index) {
    if (_controller == null) return;

    final correct = _controller!.handleAnswer(index);
    setState(() => _selectedIndex = index);

    if (correct) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _controller!.nextQuestion();
          _selectedIndex = null;
        });
      });
    }
  }

  void _toggleLanguage() {
    if (_controller == null) return;

    setState(() {
      _controller!.toggleLanguage();
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Бесконечный режим'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _controller!.isRussianMode
                      ? _controller!.currentWord.ru
                      : _controller!.currentWord.en,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 150),
                ...List.generate(_controller!.options.length, (i) {
                  final color = _getColorForIndex(i);
                  return Column(
                    children: [
                      OptionButton(
                        text: _controller!.options[i],
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
            child: ScoreBadge(score: _controller!.score),
          ),
        ],
      ),
    );
  }

  Color _getColorForIndex(int index) {
    if (_controller == null || _selectedIndex == null) return Colors.white;
    if (index == _controller!.correctOptionIndex && index == _selectedIndex) return Colors.green;
    if (_controller!.wrongAttempts.contains(index)) return Colors.red;
    return Colors.white;
  }
}
