import 'package:equatable/equatable.dart';

abstract class ScoreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadScores extends ScoreEvent {}

class ResetScores extends ScoreEvent {}
