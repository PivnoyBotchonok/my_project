import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'score_event.dart';
import 'score_state.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  final ScoreRepository repository;

  ScoreBloc({required this.repository}) : super(ScoreInitial()) {
    on<LoadScores>(_onLoadScores);
    on<ResetScores>(_onResetScores);
  }

  Future<void> _onLoadScores(LoadScores event, Emitter<ScoreState> emit) async {
    await repository.init();
    final score = repository.getScore();
    emit(ScoreLoaded(
      endlessScore: score.scoreEndlessGame,
      crosswordScore: score.scoreCrosswordGame,
    ));
  }

  Future<void> _onResetScores(ResetScores event, Emitter<ScoreState> emit) async {
    await repository.scoreClear();
    emit(const ScoreLoaded(endlessScore: 0, crosswordScore: 0));
  }
}
