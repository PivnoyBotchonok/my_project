part of 'crossword_bloc.dart';

abstract class CrosswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CrosswordInitial extends CrosswordState {}

class CrosswordLoading extends CrosswordState {}

class CrosswordLoaded extends CrosswordState {
  final List<Word> words;
  final List<Map<String, String>> crosswordData;

  CrosswordLoaded({required this.words, required this.crosswordData});

  @override
  List<Object?> get props => [words, crosswordData];
}

class CrosswordError extends CrosswordState {
  final String message;

  CrosswordError({required this.message});

  @override
  List<Object?> get props => [message];
}