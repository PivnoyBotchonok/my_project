import 'package:equatable/equatable.dart';
import 'package:my_project/data/models/word/word.dart';

abstract class DictionaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DictionaryInitial extends DictionaryState {}

class DictionaryLoading extends DictionaryState {}

class DictionaryLoaded extends DictionaryState {
  final List<Word> words;

  DictionaryLoaded(this.words);

  @override
  List<Object?> get props => [words];
}

class DictionaryError extends DictionaryState {
  final String message;

  DictionaryError(this.message);

  @override
  List<Object?> get props => [message];
}
