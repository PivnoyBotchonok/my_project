import 'package:flutter/material.dart';
import 'package:my_project/main.dart';
import 'package:my_project/routes/routes.dart';

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: "MyProject",
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            minimumSize: const Size(200, 50),
            padding: const EdgeInsets.all(20),
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
        appBarTheme: AppBarTheme(centerTitle: true),
      ),
    );
  }
}
