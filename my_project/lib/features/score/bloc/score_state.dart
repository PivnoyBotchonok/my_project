import 'package:equatable/equatable.dart';

abstract class ScoreState extends Equatable {
  const ScoreState();

  @override
  List<Object?> get props => [];
}

class ScoreInitial extends ScoreState {}

class ScoreLoaded extends ScoreState {
  final int endlessScore;
  final int crosswordScore;

  const ScoreLoaded({
    required this.endlessScore,
    required this.crosswordScore,
  });

  @override
  List<Object?> get props => [endlessScore, crosswordScore];
}
