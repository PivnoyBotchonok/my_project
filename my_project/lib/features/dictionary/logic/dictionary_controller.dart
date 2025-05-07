import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_project/data/models/word.dart';
import 'package:my_project/data/repositories/word_repo.dart';

class DictionaryController {
  final FlutterTts _tts = FlutterTts();

  Future<void> initTts() async {
    await _tts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  Future<List<Word>> loadWords() async {
    return HiveService.getWords();
  }

  Future<void> addWord(Word word) async {
    await HiveService.addWord(word);
  }
}
