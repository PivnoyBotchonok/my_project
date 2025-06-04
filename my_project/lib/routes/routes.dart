import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';
import 'package:my_project/features/crossword/crossword.dart';
import 'package:my_project/features/dictionary/bloc/dictionary_bloc.dart';
import 'package:my_project/features/dictionary/bloc/dictionary_event.dart';
import 'package:my_project/features/dictionary/dictionary.dart';
import 'package:my_project/features/endless_game/endless_game.dart';
import 'package:my_project/features/main_menu/main_menu.dart';

final routes = {
  "/": (context) => MainMenuScreen(),
  "/endless_game": (context) => EndlessGameScreen(),
  "/crossword": (context) => CrosswordScreen(),
  "/dictionary": (context) {
    final wordRepo = RepositoryProvider.of<WordRepository>(context);
    return BlocProvider(
      create: (_) => DictionaryBloc(wordRepository: wordRepo)..add(LoadWords()),
      child: DictionaryScreen(),
    );
  },
};
