import 'package:flutter/material.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/features/endless_game/widgets/score_badge.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final ScoreRepository _scoreRepository = ScoreRepository();
  int _endlessScore = 0;
  int _crosswordScore = 0;

  @override
  void initState() {
    super.initState();
    _initScores();
  }

  Future<void> _initScores() async {
    await _scoreRepository.init();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final score = _scoreRepository.getScore();
    if (mounted) {
      setState(() {
        _endlessScore = score.scoreEndlessGame;
        _crosswordScore = score.scoreCrosswordGame;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите режим')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 25),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).pushNamed("/endless_game");
                    _loadScore();
                  },
                  child: const Text('Бесконечный режим'),
                ),
                SizedBox(width: 10),
                ScoreBadge(score: _endlessScore),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 25),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).pushNamed("/crossword");
                    _loadScore();
                  },
                  child: const Text('Кроссворд'),
                ),
                SizedBox(width: 10),
                ScoreBadge(score: _crosswordScore, color: Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 25),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/dictionary");
              },
              child: const Text('Словарь'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await _scoreRepository.scoreClear();
                setState(() {
                  _endlessScore = 0;
                  _crosswordScore = 0;
                });
              },
              child: Text("Сброс результатов"),
            ),
          ],
        ),
      ),
    );
  }
}
