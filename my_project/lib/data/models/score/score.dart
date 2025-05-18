import 'package:hive_ce/hive.dart';

part 'score.g.dart';

@HiveType(typeId: 1)
class Score {
  @HiveField(0)
  final int scoreEndlessGame;
  
  @HiveField(1)
  final int scoreCrosswordGame;

  Score({
    required this.scoreEndlessGame,
    required this.scoreCrosswordGame,
  });

  Score copyWith({
    int? scoreEndlessGame,
    int? scoreCrosswordGame,
  }) {
    return Score(
      scoreEndlessGame: scoreEndlessGame ?? this.scoreEndlessGame,
      scoreCrosswordGame: scoreCrosswordGame ?? this.scoreCrosswordGame,
    );
  }
}