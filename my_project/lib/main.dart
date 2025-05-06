import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:my_project/data/models/word.dart';
import 'package:my_project/my_project.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WordAdapter());
  runApp(const MyProject());
}

