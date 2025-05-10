import 'package:flutter/material.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/features/endless_game/endless_game.dart';
import 'package:my_project/features/endless_game/widgets/score_badge.dart';
import 'package:my_project/main.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> with RouteAware {
  final ScoreRepository _scoreRepository = ScoreRepository();
  int _endlessScore = 0;
  int _crosswordScore = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Вызывается при возврате на этот экран
    _loadBestScore();
  }

  @override
  void initState() {
    super.initState();
    _loadBestScore();
  }

  Future<void> _loadBestScore() async {
    await _scoreRepository.init();
    final score = _scoreRepository.getBestScore();
    if (mounted) {
      setState(() {
        _endlessScore = score?.score_endless_game ?? 0;
        _crosswordScore = score?.score_crossword_game ?? 0;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadBestScore();
    });
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
                    // Используем push вместо pushNamed и ожидаем результат
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EndlessGameScreen(),
                      ),
                    );
                    _loadBestScore(); // Обновляем данные после возврата
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
                  onPressed: () {
                    Navigator.of(context).pushNamed("/crossword");
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
                await _scoreRepository.clearScore();
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
