import 'dart:math';
import 'package:my_project/data/models/word.dart';

class GameController {
  final List<Word> _words;
  late Word currentWord;
  late List<String> options;
  int score = 0;
  int? correctOptionIndex;
  final List<int> wrongAttempts = [];

  final Random _random = Random();

  GameController(this._words) {
    _generateNewWord();
  }

  void _generateNewWord() {
    currentWord = _words[_random.nextInt(_words.length)];

    final Set<String> optionsSet = {currentWord.en};
    while (optionsSet.length < 3) {
      final randomWord = _words[_random.nextInt(_words.length)];
      optionsSet.add(randomWord.en);
    }

    options = optionsSet.toList()..shuffle();
    correctOptionIndex = options.indexOf(currentWord.en);
    wrongAttempts.clear();
  }

  bool handleAnswer(int index) {
    if (index == correctOptionIndex) {
      score += 1;
      return true;
    } else {
      score = 0;
      wrongAttempts.add(index);
      return false;
    }
  }

  void nextQuestion() {
    _generateNewWord();
  }
}
