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
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: () {
                final themeNotifier = Provider.of<ThemeNotifier>(
                  context,
                  listen: false,
                );
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
            return Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(
                      context: context,
                      label: 'Бесконечный \nрежим',
                      onPressed: () async {
                        await Navigator.of(context).pushNamed("/endless_game");
                        // ignore: use_build_context_synchronously
                        context.read<ScoreBloc>().add(LoadScores());
                      },
                      badge: ScoreBadge(score: state.endlessScore),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuButton(
                      context: context,
                      label: 'Кроссворд',
                      onPressed: () async {
                        await Navigator.of(context).pushNamed("/crossword");
                        // ignore: use_build_context_synchronously
                        context.read<ScoreBloc>().add(LoadScores());
                      },
                      badge: ScoreBadge(
                        score: state.crosswordScore,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuButton(
                      context: context,
                      label: 'Словарь',
                      onPressed: () {
                        Navigator.of(context).pushNamed("/dictionary");
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildMenuButton(
                      context: context,
                      label: 'Сброс результатов',
                      onPressed: () {
                        context.read<ScoreBloc>().add(ResetScores());
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
    Widget? badge,
  }) {
    return SizedBox(
      width: 360,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 25),
                minimumSize: const Size(0, 60),
              ),
              onPressed: onPressed,
              child: Text(label, textAlign: TextAlign.center),
            ),
          ),
          if (badge != null) ...[const SizedBox(width: 10), badge],
        ],
      ),
    );
  }
}
