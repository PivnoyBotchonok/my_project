import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/word/word.dart';

class WordRepository {
  static const String _wordsBoxName = 'wordsBox';
  static const String _configBoxName = 'configBox';
  static const String _dataLoadedKey = 'isDataLoaded';
  static const String _jsonPath = 'assets/word.json';

  static Box<Word>? _wordsBox;
  static Box? _configBox;

  static Future<void> _initHive() async {
    if (Hive.isBoxOpen(_wordsBoxName) && Hive.isBoxOpen(_configBoxName)) return;

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(WordAdapter().typeId)) {
      Hive.registerAdapter(WordAdapter());
    }

    _wordsBox ??= await Hive.openBox<Word>(_wordsBoxName);
    _configBox ??= await Hive.openBox(_configBoxName);

    final isDataLoaded = _configBox!.get(_dataLoadedKey, defaultValue: false);
    if (!isDataLoaded || _wordsBox!.isEmpty) {
      await _loadInitialData();
      await _configBox!.put(_dataLoadedKey, true);
    }
  }

  static Future<void> _loadInitialData() async {
    try {
      final jsonString = await rootBundle.loadString(_jsonPath);
      final List<dynamic> jsonList = json.decode(jsonString);
      final words = jsonList.map((e) => Word.fromJson(e)).toList();

      await _wordsBox!.clear();
      await _wordsBox!.putAll({for (var word in words) word.id: word});
    } catch (e) {
      print('Error loading initial data: $e');
      await _configBox!.delete(_dataLoadedKey);
      rethrow;
    }
  }

  static Future<void> addWord(Word word) async {
    await _initHive();
    await _wordsBox!.put(word.id, word);
  }

  static Future<void> saveWords(List<Word> words) async {
    await _initHive();
    await _wordsBox!.clear();
    await _wordsBox!.putAll({for (var word in words) word.id: word});
  }

  static Future<List<Word>> getWords() async {
    await _initHive();
    return _wordsBox!.values.toList();
  }

  static Future<void> close() async {
    await Hive.close();
    _wordsBox = null;
    _configBox = null;
  }
}