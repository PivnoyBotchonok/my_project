import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final List<Word> words;
  final ScoreRepository scoreRepository;
  final Random _random = Random();

  GameBloc({required this.words, required this.scoreRepository})
    : super(GameLoading()) {
    on<GameInit>(_onInit);
    on<AnswerSelected>(_onAnswerSelected);
    on<NextQuestionRequested>(_onNextQuestion);
    on<LanguageToggled>(_onLanguageToggled);
  }

  void _onInit(GameInit event, Emitter<GameState> emit) {
    _generateNewQuestion(emit);
  }

  void _onAnswerSelected(AnswerSelected event, Emitter<GameState> emit) async {
    final state = this.state as GameLoaded;

    if (event.index == state.correctOptionIndex) {
      final newScore = state.score + 1;
      emit(state.copyWith(score: newScore, selectedIndex: event.index));

      Future.delayed(const Duration(milliseconds: 500), () {
        add(NextQuestionRequested());
      });
    } else {
      try {
        await scoreRepository.updateEndlessScore(state.score);
        emit(
          state.copyWith(
            score: 0,
            selectedIndex: event.index,
            wrongAttempts: [...state.wrongAttempts, event.index],
          ),
        );
      } catch (e) {
        // Обработка ошибок
        emit(GameError(message: 'Ошибка сохранения счета'));
      }
    }
  }

  void _onNextQuestion(NextQuestionRequested event, Emitter<GameState> emit) {
    _generateNewQuestion(emit);
  }

  void _onLanguageToggled(LanguageToggled event, Emitter<GameState> emit) {
    final state = this.state as GameLoaded;
    _generateNewQuestion(emit, isRussianMode: !state.isRussianMode);
  }

  void _generateNewQuestion(Emitter<GameState> emit, {bool? isRussianMode}) {
    // Убираем проверку на GameLoaded
    final newRussianMode =
        isRussianMode ??
        (state is GameLoaded ? (state as GameLoaded).isRussianMode : true);

    final currentWord = words[_random.nextInt(words.length)];

    final optionsSet = {newRussianMode ? currentWord.en : currentWord.ru};
    while (optionsSet.length < 3) {
      final randomWord = words[_random.nextInt(words.length)];
      optionsSet.add(newRussianMode ? randomWord.en : randomWord.ru);
    }

    final options = optionsSet.toList()..shuffle();
    final correctOptionIndex = options.indexOf(
      newRussianMode ? currentWord.en : currentWord.ru,
    );

    emit(
      GameLoaded(
        currentWord: currentWord,
        options: options,
        correctOptionIndex: correctOptionIndex,
        isRussianMode: newRussianMode,
        score:
            isRussianMode != null
                ? 0
                : (state is GameLoaded ? (state as GameLoaded).score : 0),
        wrongAttempts: [],
        selectedIndex: null,
      ),
    );
  }
}
