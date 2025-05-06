import 'package:my_project/features/crossword/crossword.dart';
import 'package:my_project/features/dictionary/dictionary.dart';
import 'package:my_project/features/endless_game/endless_game.dart';
import 'package:my_project/features/main_menu/main_menu.dart';


final routes = {
  "/": (context) => MainMenuScreen(),
  "/endless_game": (context) => EndlessGameScreen(),
  "/crossword": (context) => CrosswordScreen(),
  "/dictionary": (context) => DictionaryScreen(),
};
