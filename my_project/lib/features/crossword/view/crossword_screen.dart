import 'package:crossword_generator/crossword_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';// Импорт кастомного виджета
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';

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

  @override
  void initState() {
    super.initState();
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
    return words
        .map(
          (word) => {'answer': word.en.toLowerCase(), 'description': word.ru},
        )
        .toList();
  }

  Widget _buildCrossword() {
    if (_crosswordData == null) return const SizedBox();

    return InteractiveViewer(
      panEnabled: true,
      boundaryMargin: const EdgeInsets.all(80),
      minScale: 0.5,
      maxScale: 2.5,
      child: CrosswordWidget( // Используй свой кастомный виджет здесь
        words: _crosswordData!,
        style: CrosswordStyle(
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
            textStyle: const TextStyle(fontSize: 25),
          ),
          cellBuilder: (context, cell, isSelected, isHighlighted, isCompleted) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color:
                    isCompleted
                        ? const Color.fromARGB(255, 255, 249, 196)
                        : isSelected
                        ? const Color.fromARGB(255, 84, 255, 129)
                        : isHighlighted
                        ? const Color.fromARGB(255, 200, 255, 200)
                        : Colors.white,
              ),
              child: Text(
                cell.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          },
        ),
        onRevealCurrentCellLetter: (revealCurrentCellLetter) {
          _revealCurrentCellLetter = revealCurrentCellLetter;
        },
        onCrosswordCompleted: () {
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : _words.isEmpty
              ? Center(
                child: ElevatedButton(
                  onPressed: _loadWords,
                  child: const Text('Сгенерировать кроссворд'),
                ),
              )
              : _buildCrossword(),
    );
  }
}
