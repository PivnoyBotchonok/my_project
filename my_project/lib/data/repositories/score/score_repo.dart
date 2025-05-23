import 'package:hive_ce/hive.dart';
import 'package:my_project/data/models/score/score.dart';

class ScoreRepository {
  late Box<Score> _scoreBox;
  
  static const String _boxName = 'scores';
  static String get boxName => _boxName;
  static const int _defaultKey = 0;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ScoreAdapter());
    }
    _scoreBox = await Hive.openBox<Score>(_boxName);
    
    // Инициализация дефолтных значений при первом запуске
    if (!_scoreBox.containsKey(_defaultKey)) {
      await _scoreBox.put(
        _defaultKey,
        Score(
          scoreEndlessGame: 0,
          scoreCrosswordGame: 0,
        ),
      );
    }
  }

  // Получение текущего счета
  Score getScore() {
    return _scoreBox.get(_defaultKey)!;
  }

  // Обновление лучшего результата для Endless Game
  Future<void> updateEndlessScore(int newScore) async {
    await init();
    final currentScore = getScore();
    if (newScore > currentScore.scoreEndlessGame) {
      await _scoreBox.put(
        _defaultKey,
        currentScore.copyWith(scoreEndlessGame: newScore),
      );
    }
  }

  // Увеличение счетчика Crossword Game
  Future<void> incrementCrosswordScore() async {
    final currentScore = getScore();
    await _scoreBox.put(
      _defaultKey,
      currentScore.copyWith(
        scoreCrosswordGame: currentScore.scoreCrosswordGame + 1,
      ),
    );
  }

Future<void> scoreClear() async {
  await _scoreBox.put(
    _defaultKey,
    Score(
      scoreEndlessGame: 0,
      scoreCrosswordGame: 0,
    ),
  );
}

  Future<void> close() async {
    await _scoreBox.close();
  }
}