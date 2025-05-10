import 'package:hive_ce/hive.dart';
import 'package:my_project/data/models/score/score.dart';

class ScoreRepository {
  static const _boxName = 'scoreBox';
  static const _bestScoreKey = 'best_score';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ScoreAdapter());
    }
    await Hive.openBox<Score>(_boxName);
  }

  Future<void> saveScore(Score newScore) async {
    final box = Hive.box<Score>(_boxName);
    final currentScore = getBestScore();

    final updatedScore = _mergeScores(currentScore, newScore);
    await box.put(_bestScoreKey, updatedScore);
  }

  Score _mergeScores(Score? current, Score newScore) {
    if (current == null) return newScore;
    
    return Score(
      score_endless_game: _getMax(current.score_endless_game, newScore.score_endless_game),
      score_crossword_game: _getMax(current.score_crossword_game, newScore.score_crossword_game),
    );
  }

  int _getMax(int a, int b) => a > b ? a : b;

  Score? getBestScore() {
    final box = Hive.box<Score>(_boxName);
    return box.get(_bestScoreKey);
  }

  Future<void> clearScore() async {
    final box = Hive.box<Score>(_boxName);
    await box.delete(_bestScoreKey);
  }
}