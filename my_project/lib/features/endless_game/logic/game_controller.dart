import 'dart:math';
import 'package:my_project/data/models/word/word.dart';

class GameController {
  final List<Word> _words;
  late Word currentWord;
  late List<String> options;
  int score = 0;
  int? correctOptionIndex;
  final List<int> wrongAttempts = [];

  final Random _random = Random();
  bool isRussianMode = true; // Флаг для текущего режима игры (если true, то русский режим)

  GameController(this._words) {
    _generateNewWord();
  }

  void _generateNewWord() {
    currentWord = _words[_random.nextInt(_words.length)];

    // В зависимости от текущего режима генерируем правильные варианты ответов
    final Set<String> optionsSet = {
      isRussianMode ? currentWord.en : currentWord.ru,
    };
    while (optionsSet.length < 3) {
      final randomWord = _words[_random.nextInt(_words.length)];
      optionsSet.add(isRussianMode ? randomWord.en : randomWord.ru);
    }

    options = optionsSet.toList()..shuffle();
    correctOptionIndex = options.indexOf(
      isRussianMode ? currentWord.en : currentWord.ru,
    );
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

  // Метод для смены языка (смена режима)
  void toggleLanguage() {
    isRussianMode = !isRussianMode;
    score = 0; // Сбрасываем счет при смене режима
    _generateNewWord(); // Генерируем новый вопрос
  }
}
