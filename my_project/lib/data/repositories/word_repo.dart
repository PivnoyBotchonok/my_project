import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:my_project/data/models/word.dart';

class HiveService {
  static const String _wordsBoxName = 'wordsBox';

  // Box для работы
  static Box<Word>? _box;

  // Инициализация Hive и загрузка данных из JSON, если коробка пуста
  static Future<void> init() async {
    if (_box == null) {
      _box = await Hive.openBox<Word>(_wordsBoxName); // Открываем коробку
    }

    // Если коробка пуста, загружаем данные из JSON
    if (_box!.isEmpty) {
      await _loadInitialData();
    }
  }

  // Загружаем начальные данные из JSON
  static Future<void> _loadInitialData() async {
    final jsonString = await _loadJsonFromAssets('assets/word.json'); // Чтение JSON из assets
    
    // Парсим JSON в список
    final List<dynamic> jsonData = json.decode(jsonString);
    
    // Преобразуем в объекты Word
    final words = jsonData.map((data) => Word.fromJson(data)).toList();
    
    // Сохраняем данные в Hive
    await saveWords(words);
  }

  // Загружаем JSON из assets
  static Future<String> _loadJsonFromAssets(String path) async {
    return await rootBundle.loadString(path); // Чтение файла из assets
  }

  // Добавление нового слова в коробку
  static Future<void> addWord(Word word) async {
    if (_box == null) await init(); // Инициализация коробки, если она еще не была открыта
    await _box!.add(word);
  }

  // Сохранение списка слов в коробку
  static Future<void> saveWords(List<Word> words) async {
    if (_box == null) await init(); // Инициализация коробки, если она еще не была открыта
    await _box!.clear(); // Очищаем коробку перед сохранением новых данных
    for (var word in words) {
      await _box!.add(word);
    }
  }

  // Получение всех слов из коробки
  static List<Word> getWords() {
    if (_box == null) {
      throw HiveError('Box not opened');
    }
    return _box!.values.toList(); // Возвращаем список всех слов
  }

  // Закрытие Hive
  static Future<void> close() async {
    await Hive.close();
  }
}
