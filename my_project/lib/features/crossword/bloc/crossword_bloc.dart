
import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  final WordRepository wordRepository;

  CrosswordBloc({required this.wordRepository}) : super(CrosswordInitial()) {
    on<LoadCrossword>(_onLoadCrossword);
  }

  Future<void> _onLoadCrossword(LoadCrossword event, Emitter<CrosswordState> emit) async {
    emit(CrosswordLoading());
    try {
      final words = await wordRepository.getWords();
      final randomWords = await compute(_getRandomWords, words);
      final crosswordData = await compute(_prepareCrosswordData, randomWords);
      emit(CrosswordLoaded(words: randomWords, crosswordData: crosswordData));
    } catch (e) {
      emit(CrosswordError(message: e.toString()));
    }
  }

  static List<Word> _getRandomWords(List<Word> allWords) {
    final shuffled = List<Word>.from(allWords)..shuffle();
    return shuffled.take(10).toList();
  }

  static List<Map<String, String>> _prepareCrosswordData(List<Word> words) {
    return words.map((word) {
      final wordsList = word.ru.split(' ');
      final shortDescription = wordsList.take(3).join(' ');
      final dots = wordsList.length > 3 ? '...' : '';
      return {
        'answer': word.en.toLowerCase(),
        'description': '$shortDescription$dots',
      };
    }).toList();
  }
}