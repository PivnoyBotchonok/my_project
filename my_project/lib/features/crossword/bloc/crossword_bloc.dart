import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordDataParams {
  final List<Word> words;
  final bool isRussianMode;

  CrosswordDataParams(this.words, this.isRussianMode);
}

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  final WordRepository wordRepository;

  CrosswordBloc({required this.wordRepository}) : super(CrosswordInitial()) {
    on<LoadCrossword>(_onLoadCrossword);
    on<LanguageToggled>(_onLanguageToggled);
  }

  void _onLanguageToggled(LanguageToggled event, Emitter<CrosswordState> emit) {
    if (state is CrosswordLoaded) {
      final currentState = state as CrosswordLoaded;
      add(LoadCrossword(isRussianMode: !currentState.isRussianMode));
    }
  }

  Future<void> _onLoadCrossword(LoadCrossword event, Emitter<CrosswordState> emit) async {
    emit(CrosswordLoading());
    try {
      final words = await wordRepository.getWords();
      final randomWords = await compute(
        _getValidSingleWords, 
        words
      );
      
      if (randomWords.isEmpty) {
        throw Exception("Не найдено подходящих слов для кроссворда");
      }
      
      final isRussianMode = event.isRussianMode ?? 
          (state is CrosswordLoaded ? (state as CrosswordLoaded).isRussianMode : true);
      
      final crosswordData = await compute(
        _prepareCrosswordData, 
        CrosswordDataParams(randomWords, isRussianMode)
      );
      
      emit(CrosswordLoaded(
        words: randomWords,
        crosswordData: crosswordData,
        isRussianMode: isRussianMode,
      ));
    } catch (e) {
      emit(CrosswordError(message: e.toString()));
    }
  }

  static List<Word> _getValidSingleWords(List<Word> allWords) {
    // Фильтрация слов, где оба варианта состоят из одного слова
    final validWords = allWords.where((word) {
      final enHasSingleWord = word.en.trim().split(' ').length == 1;
      final ruHasSingleWord = word.ru.trim().split(' ').length == 1;
      return enHasSingleWord && ruHasSingleWord;
    }).toList();
    
    if (validWords.isEmpty) return [];
    
    final shuffled = List<Word>.from(validWords)..shuffle();
    return shuffled.take(min(10, validWords.length)).toList();
  }

  static List<Map<String, String>> _prepareCrosswordData(CrosswordDataParams params) {
    return params.words.map((word) {
      final descriptionSource = params.isRussianMode ? word.ru : word.en;
      final wordsList = descriptionSource.split(' ');
      final shortDescription = wordsList.take(3).join(' ');
      final dots = wordsList.length > 3 ? '...' : '';
      
      return {
        'answer': params.isRussianMode 
            ? word.en.toLowerCase() 
            : word.ru.toLowerCase(),
        'description': '$shortDescription$dots',
      };
    }).toList();
  }
}