part of 'crossword_bloc.dart';

sealed class CrosswordState extends Equatable {
  const CrosswordState();
}

class CrosswordInitial extends CrosswordState {
  @override
  List<Object> get props => [];
}

class CrosswordLoading extends CrosswordState {
  @override
  List<Object> get props => [];
}

class CrosswordError extends CrosswordState {
  final String message;
  
  const CrosswordError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class CrosswordLoaded extends CrosswordState {
  final List<Word> words;
  final List<Map<String, String>> crosswordData;
  final bool isRussianMode;

  const CrosswordLoaded({
    required this.words,
    required this.crosswordData,
    this.isRussianMode = true,
  });

  @override
  List<Object> get props => [words, crosswordData, isRussianMode];
}