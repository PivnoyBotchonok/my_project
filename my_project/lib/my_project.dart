import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_project/theme/theme_notifier.dart';
import 'package:my_project/routes/routes.dart';
import 'package:my_project/theme/theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyProject extends StatelessWidget {
  const MyProject({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем текущий ThemeMode из ThemeNotifier
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      navigatorObservers: [routeObserver], // Теперь routeObserver правильно объявлен
      title: "MyProject",
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.themeMode, // Используем состояние из ThemeNotifier
    );
  }
}
