import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/score/score_repo.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';
import 'package:my_project/libs/crossword_generator.dart';

class CrosswordScreen extends StatefulWidget {
  const CrosswordScreen({super.key});

  @override
  State<CrosswordScreen> createState() => _CrosswordScreenState();
}

class _CrosswordScreenState extends State<CrosswordScreen> {
  List<Word> _words = [];
  List<Map<String, String>>? _crosswordData;
  bool _isLoading = false;
  String? _error;
  Function? _revealCurrentCellLetter;
  final ScoreRepository _scoreRepository = ScoreRepository();
  final String _highlightedWordDescription = '';

  @override
  void initState() {
    super.initState();
    _scoreRepository.init();
  }

  Future<void> _loadWords() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final words = await HiveService.getWords();
      final randomWords = await compute(_getRandomWords, words);
      final crosswordData = await compute(_prepareCrosswordData, randomWords);

      setState(() {
        _words = randomWords;
        _crosswordData = crosswordData;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  static List<Word> _getRandomWords(List<Word> allWords) {
    final shuffled = List<Word>.from(allWords)..shuffle();
    return shuffled.take(10).toList();
  }

  static List<Map<String, String>> _prepareCrosswordData(List<Word> words) {
    return words.map((word) {
      // Берем первые 3 слова из описания
      final wordsList = word.ru.split(' ');
      final shortDescription = wordsList.take(3).join(' ');
      final dots = wordsList.length > 3 ? '...' : '';

      return {
        'answer': word.en.toLowerCase(),
        'description': '$shortDescription$dots',
      };
    }).toList();
  }

  final CrosswordStyle _style = CrosswordStyle(
    currentCellColor: const Color.fromARGB(255, 84, 255, 129),
    wordHighlightColor: const Color.fromARGB(255, 200, 255, 200),
    wordCompleteColor: const Color.fromARGB(255, 255, 249, 196),
    cellTextStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    descriptionButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      minimumSize: const Size(50, 50),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      textStyle: const TextStyle(
        fontSize: 20, // Уменьшаем размер шрифта
        overflow: TextOverflow.visible,
      ),
      alignment: Alignment.center, // Выравнивание по центру
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Генерация кроссворда')),
        body: Center(
          child: ElevatedButton(
            onPressed: _loadWords,
            child: const Text('Сгенерировать кроссворд'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Кроссворд"),
        actions: [
          if (_crosswordData != null) ...[
            IconButton(
              icon: const Icon(Icons.help),
              onPressed: () => _revealCurrentCellLetter?.call(),
            ),
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadWords),
          ],
        ],
      ),
      body: InteractiveViewer(
        panEnabled: true,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 2.5,
        child: CrosswordWidget(
          words: _crosswordData!,
          style: _style,
          onRevealCurrentCellLetter: (revealFn) {
            _revealCurrentCellLetter = revealFn;
          },
          onCrosswordCompleted: () async {
            // Добавьте async
            try {
              await _scoreRepository.incrementCrosswordScore();
              if (mounted) {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
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
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ошибка: ${e.toString()}')),
                );
              }
            }
          },
        ),
      ),
      bottomNavigationBar:
          _highlightedWordDescription.isNotEmpty
              ? CrosswordNavigationBar(
                description: _highlightedWordDescription,
                onPrevious: () {},
                onNext: () {},
                style: _style,
              )
              : null,
    );
  }
}
