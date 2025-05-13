import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/features/dictionary/widgets/word_item.dart';

class WordSearchDelegate extends SearchDelegate<Word> {
  final List<Word> words;
  final FlutterTts _tts = FlutterTts();

  WordSearchDelegate({required this.words}) {
    _tts.setLanguage('en-US');
  }

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, Word.empty()),
      );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    final results = words.where((word) {
      final en = word.en.toLowerCase();
      final ru = word.ru.toLowerCase();
      final searchQuery = query.toLowerCase();
      return en.contains(searchQuery) || ru.contains(searchQuery);
    }).toList();

    return results.isEmpty
        ? const Center(child: Text('Ничего не найдено'))
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) => WordItem(
              word: results[index],
              onSpeak: () => _tts.speak(results[index].en),
            ),
          );
  }
}