import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';
import 'package:my_project/features/crossword/bloc/crossword_bloc.dart';
import 'package:my_project/libs/crossword_generator.dart';

class CrosswordScreen extends StatelessWidget {
  CrosswordScreen({super.key});

  final CrosswordStyle _style = CrosswordStyle(
    currentCellColor: const Color.fromARGB(255, 84, 255, 129),
    wordHighlightColor: const Color.fromARGB(255, 200, 255, 200),
    wordCompleteColor: const Color.fromARGB(255, 255, 249, 196),
    cellTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    descriptionButtonStyle: ElevatedButton.styleFrom(
      //backgroundColor: Colors.blue,
      minimumSize: const Size(50, 50),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      textStyle: const TextStyle(fontSize: 20, overflow: TextOverflow.visible),
      alignment: Alignment.center,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final wordRepo = context.read<WordRepository>();
    final scoreRepo = context.read<ScoreRepository>();
    scoreRepo.init();

    return BlocProvider(
      create: (_) => CrosswordBloc(wordRepository: wordRepo),
      child: BlocBuilder<CrosswordBloc, CrosswordState>(
        builder: (context, state) {
          Function? _revealCurrentCellLetter;
          String _highlightedWordDescription = '';

          if (state is CrosswordLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is CrosswordError) {
            return Scaffold(
              body: Center(child: Text('Ошибка: ${state.message}')),
            );
          }

          if (state is CrosswordInitial) {
            return Scaffold(
              appBar: AppBar(title: const Text('Генерация кроссворда')),
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CrosswordBloc>().add(LoadCrossword());
                  },
                  child: const Text('Сгенерировать кроссворд'),
                ),
              ),
            );
          }

          if (state is CrosswordLoaded) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Кроссворд"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () => _revealCurrentCellLetter?.call(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.read<CrosswordBloc>().add(LoadCrossword()),
                  ),
                ],
              ),
              body: InteractiveViewer(
                panEnabled: true,
                boundaryMargin: const EdgeInsets.all(80),
                minScale: 0.5,
                maxScale: 2.5,
                child: CrosswordWidget(
                  words: state.crosswordData,
                  style: _style,
                  onRevealCurrentCellLetter: (fn) {
                    _revealCurrentCellLetter = fn;
                  },
                  onCrosswordCompleted: () async {
                    try {
                      await scoreRepo.incrementCrosswordScore();
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Поздравляем!'),
                            content: const Text('Вы успешно завершили кроссворд!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ошибка: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
              ),
              bottomNavigationBar: _highlightedWordDescription.isNotEmpty
                  ? CrosswordNavigationBar(
                      description: _highlightedWordDescription,
                      onPrevious: () {},
                      onNext: () {},
                      style: _style,
                    )
                  : null,
            );
          }

          return const SizedBox.shrink(); // fallback
        },
      ),
    );
  }
}
