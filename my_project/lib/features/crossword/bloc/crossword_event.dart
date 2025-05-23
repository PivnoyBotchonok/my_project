// crossword_event.dart
part of 'crossword_bloc.dart';

abstract class CrosswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCrossword extends CrosswordEvent {}