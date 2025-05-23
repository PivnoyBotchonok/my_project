import 'package:equatable/equatable.dart';
import 'package:my_project/data/models/word/word.dart';

abstract class DictionaryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWords extends DictionaryEvent {}

class AddNewWord extends DictionaryEvent {
  final Word word;

  AddNewWord(this.word);

  @override
  List<Object?> get props => [word];
}
