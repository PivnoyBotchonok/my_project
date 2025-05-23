import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/features/score/bloc/score_bloc.dart';
import 'package:my_project/features/score/bloc/score_event.dart';
import 'package:my_project/features/score/bloc/score_state.dart';
import 'package:my_project/features/score/widget/score_badge.dart';
import 'package:my_project/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreRepo = context.read<ScoreRepository>();

    return BlocProvider(
      create: (_) => ScoreBloc(repository: scoreRepo)..add(LoadScores()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Выберите режим'),
          actions: [
            IconButton(
              icon: Icon(
                // Определяем иконку в зависимости от текущей темы
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny // Иконка для темной темы
                    : Icons.nightlight_round, // Иконка для светлой темы
              ),
              onPressed: () {
                // Переключаем тему через ThemeNotifier
                final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
                themeNotifier.toggleTheme();
              },
            ),
          ],
        ),
        body: BlocBuilder<ScoreBloc, ScoreState>(
          builder: (context, state) {
            if (state is! ScoreLoaded) {
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 25),
                        ),
                        onPressed: () async {
                          await Navigator.of(context).pushNamed("/endless_game");
                          context.read<ScoreBloc>().add(LoadScores());
                        },
                        child: const Text('Бесконечный режим'),
                      ),
                      const SizedBox(width: 10),
                      ScoreBadge(score: state.endlessScore),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 25),
                        ),
                        onPressed: () async {
                          await Navigator.of(context).pushNamed("/crossword");
                          context.read<ScoreBloc>().add(LoadScores());
                        },
                        child: const Text('Кроссворд'),
                      ),
                      const SizedBox(width: 10),
                      ScoreBadge(
                        score: state.crosswordScore,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/dictionary");
                    },
                    child: const Text('Словарь'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ScoreBloc>().add(ResetScores());
                    },
                    child: const Text("Сброс результатов"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
