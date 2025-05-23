part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameLoading extends GameState {}

class GameError extends GameState {
  final String message;
  const GameError({required this.message});
}

class GameLoaded extends GameState {
  final Word currentWord;
  final List<String> options;
  final int correctOptionIndex;
  final bool isRussianMode;
  final int score;
  final List<int> wrongAttempts;
  final int? selectedIndex;

  const GameLoaded({
    required this.currentWord,
    required this.options,
    required this.correctOptionIndex,
    required this.isRussianMode,
    this.score = 0,
    this.wrongAttempts = const [],
    this.selectedIndex,
  });

  GameLoaded copyWith({
    Word? currentWord,
    List<String>? options,
    int? correctOptionIndex,
    bool? isRussianMode,
    int? score,
    List<int>? wrongAttempts,
    int? selectedIndex,
  }) {
    return GameLoaded(
      currentWord: currentWord ?? this.currentWord,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      isRussianMode: isRussianMode ?? this.isRussianMode,
      score: score ?? this.score,
      wrongAttempts: wrongAttempts ?? this.wrongAttempts,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object> get props => [
        currentWord,
        options,
        correctOptionIndex,
        isRussianMode,
        score,
        wrongAttempts,
        selectedIndex ?? -1,
      ];
}