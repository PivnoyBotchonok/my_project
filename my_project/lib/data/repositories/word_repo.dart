import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:my_project/data/models/word.dart';

class HiveService {
  static const String _wordsBoxName = 'wordsBox';
  static const String _configBoxName = 'configBox';
  static const String _dataLoadedKey = 'isDataLoaded';

  static Box<Word>? _wordsBox;
  static Box? _configBox;

  static Future<void> init() async {
    // Открываем обе коробки
    _wordsBox ??= await Hive.openBox<Word>(_wordsBoxName);
    _configBox ??= await Hive.openBox(_configBoxName);

    // Проверяем, были ли уже загружены начальные данные
    final isDataLoaded = _configBox!.get(_dataLoadedKey, defaultValue: false);

    if (!isDataLoaded && _wordsBox!.isEmpty) {
      await _loadInitialData();
      await _configBox!.put(_dataLoadedKey, true); // Устанавливаем флаг
    }
  }

  static Future<void> _loadInitialData() async {
    final jsonString = await rootBundle.loadString('assets/word.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final words = jsonData.map((data) => Word.fromJson(data)).toList();
    await saveWords(words);
  }

  static Future<void> addWord(Word word) async {
    await init();
    await _wordsBox!.add(word);
  }

  static Future<void> saveWords(List<Word> words) async {
    await init();
    await _wordsBox!.clear();
    for (var word in words) {
      await _wordsBox!.add(word);
    }
  }

  static List<Word> getWords() {
    if (_wordsBox == null) {
      throw HiveError('Box not opened');
    }
    return _wordsBox!.values.toList();
  }

  static Future<void> close() async {
    await Hive.close();
    _wordsBox = null;
    _configBox = null;
  }
}
