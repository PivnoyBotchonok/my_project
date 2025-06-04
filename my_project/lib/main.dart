import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:my_project/data/models/score/score.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';
import 'package:my_project/my_project.dart';
import 'package:provider/provider.dart';
import 'package:my_project/theme/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final wordRepository = WordRepository();
  final scoreRepository = ScoreRepository();
  // Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(ScoreAdapter());
  // Открываем box
  await wordRepository.initHive();
  await scoreRepository.init(); 

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: wordRepository),
        RepositoryProvider(create: (_) => scoreRepository),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(), // Используем ThemeNotifier для управления темой
        child: const MyProject(),
      ),
    ),
  );
}
