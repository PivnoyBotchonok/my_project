part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameInit extends GameEvent {}
class AnswerSelected extends GameEvent {
  final int index;
  const AnswerSelected(this.index);
}
class NextQuestionRequested extends GameEvent {}
class LanguageToggled extends GameEvent {}