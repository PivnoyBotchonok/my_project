part of 'crossword_bloc.dart';

sealed class CrosswordEvent extends Equatable {
  const CrosswordEvent();
}

class LoadCrossword extends CrosswordEvent {
  final bool? isRussianMode;

  const LoadCrossword({this.isRussianMode});

  @override
  List<Object?> get props => [isRussianMode];
}

class LanguageToggled extends CrosswordEvent {
  @override
  List<Object> get props => [];
}