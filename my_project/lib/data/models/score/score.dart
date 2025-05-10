import 'package:hive_ce/hive.dart';

part 'score.g.dart'; // Файл будет сгенерирован

@HiveType(typeId: 1)
class Score {
  @HiveField(0)
  final int score_endless_game;
  
  @HiveField(1)
  final int score_crossword_game;  
  Score({
    required this.score_endless_game,
    required this.score_crossword_game,
  });
}