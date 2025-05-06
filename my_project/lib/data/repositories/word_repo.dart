import 'package:hive_ce/hive.dart';
import 'package:my_project/data/models/word.dart';

class HiveService {
  static const String _wordsBoxName = 'wordsBox';

  static Future<void> init() async {
    await Hive.openBox<Word>(_wordsBoxName);
  }
    static Future<void> addWord(Word word) async {
    final box = Hive.box<Word>(_wordsBoxName);
    await box.add(word);
  }

  static Future<void> saveWords(List<Word> words) async {
    final box = Hive.box<Word>(_wordsBoxName);
    await box.clear();
    for (var word in words) {
      await box.add(word);
    }
  }

  static List<Word> getWords() {
    final box = Hive.box<Word>(_wordsBoxName);
    return box.values.toList();
  }

  static Future<void> close() async {
    await Hive.close();
  }


}
