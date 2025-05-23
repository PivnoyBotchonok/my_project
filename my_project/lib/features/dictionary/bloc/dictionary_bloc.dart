import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';
import 'dictionary_event.dart';
import 'dictionary_state.dart';

class DictionaryBloc extends Bloc<DictionaryEvent, DictionaryState> {
  final WordRepository wordRepository;

  DictionaryBloc({required this.wordRepository}) : super(DictionaryInitial()) {
    on<LoadWords>(_onLoadWords);
    on<AddNewWord>(_onAddWord);
  }

  Future<void> _onLoadWords(
    LoadWords event,
    Emitter<DictionaryState> emit,
  ) async {
    emit(DictionaryLoading());
    try {
      final words = await wordRepository.getWords();
      emit(DictionaryLoaded(words));
    } catch (e) {
      emit(DictionaryError(e.toString()));
    }
  }

  Future<void> _onAddWord(
    AddNewWord event,
    Emitter<DictionaryState> emit,
  ) async {
    try {
      await wordRepository.addWord(event.word);
      final updatedWords = await wordRepository.getWords();
      emit(DictionaryLoaded(updatedWords));
    } catch (e) {
      emit(DictionaryError(e.toString()));
    }
  }
}
