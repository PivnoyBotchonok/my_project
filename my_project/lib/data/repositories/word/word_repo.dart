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

  Box<Word>? _wordsBox;
  Box? _configBox;

  List<Word> get words => _wordsBox?.values.toList() ?? [];

  Future<void> initHive() async {
    if (Hive.isBoxOpen(_wordsBoxName)) return;

    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    if (!Hive.isAdapterRegistered(WordAdapter().typeId)) {
      Hive.registerAdapter(WordAdapter());
    }

    _wordsBox = await Hive.openBox<Word>(_wordsBoxName);
    _configBox = await Hive.openBox(_configBoxName);

    final isDataLoaded = _configBox!.get(_dataLoadedKey, defaultValue: false);
    if (!isDataLoaded || _wordsBox!.isEmpty) {
      await _loadInitialData();
      await _configBox!.put(_dataLoadedKey, true);
    }
  }

  Future<void> _loadInitialData() async {
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

  Future<void> addWord(Word word) async {
    await initHive();
    await _wordsBox!.add(word);
  }

  Future<void> saveWords(List<Word> words) async {
    await initHive();
    await _wordsBox!.clear();
    await _wordsBox!.putAll({for (var word in words) word.id: word});
  }

  Future<List<Word>> getWords() async {
    await initHive();
    return _wordsBox!.values.toList();
  }

  Future<void> close() async {
    await _wordsBox?.close();
    await _configBox?.close();
  }
}
