import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';
import 'package:my_project/features/endless_game/bloc/bloc/game_bloc.dart';
import 'package:my_project/features/endless_game/widgets/option_button.dart';
import 'package:my_project/features/score/widget/score_badge.dart';
import 'package:my_project/theme/theme.dart';

class EndlessGameScreen extends StatelessWidget {
  const EndlessGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Word>>(
      future: context.read<WordRepository>().getWords(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return BlocProvider(
          create:
              (context) => GameBloc(
                words: snapshot.data!,
                scoreRepository: context.read<ScoreRepository>(),
              )..add(GameInit()),
          child: const _GameView(),
        );
      },
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бесконечный режим'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => context.read<GameBloc>().add(LanguageToggled()),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final score =
                context.read<GameBloc>().state is GameLoaded
                    ? (context.read<GameBloc>().state as GameLoaded).score
                    : 0;
            context.read<ScoreRepository>().updateEndlessScore(score);
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          if (state is GameLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GameLoaded) {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.isRussianMode
                            ? state.currentWord.ru
                            : state.currentWord.en,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 150),
                      ...List.generate(state.options.length, (i) {
                        final color = _getColorForIndex(context, i, state);
                        return Column(
                          children: [
                            OptionButton(
                              text: state.options[i],
                              color: color,
                              onPressed:
                                  () => context.read<GameBloc>().add(
                                    AnswerSelected(i),
                                  ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 50,
                  child: ScoreBadge(score: state.score),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Color _getColorForIndex(BuildContext context, int index, GameLoaded state) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    final baseColor =
        theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ??
        (brightness == Brightness.dark ? Colors.grey[850]! : Colors.white);

    final correctColor = AppTheme.successColor(brightness);
    final wrongColor = AppTheme.errorColor(brightness);

    if (state.selectedIndex == null) return baseColor;
    if (index == state.correctOptionIndex && index == state.selectedIndex) {
      return correctColor;
    }
    if (state.wrongAttempts.contains(index)) return wrongColor;
    return baseColor;
  }
}
