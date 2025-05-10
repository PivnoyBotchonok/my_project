import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:my_project/data/models/score/score.dart';
import 'package:my_project/data/models/word.dart';
import 'package:my_project/data/repositories/word_repo.dart';
import 'package:my_project/my_project.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  Hive.registerAdapter(ScoreAdapter());
  // Открываем box
  await HiveService.getWords();
  runApp(const MyProject());
}
