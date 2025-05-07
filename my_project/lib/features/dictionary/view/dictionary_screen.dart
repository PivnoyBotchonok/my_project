import 'package:flutter/material.dart';
import 'package:my_project/data/models/word.dart';
import 'package:my_project/features/add_word/add_word.dart';
import 'package:my_project/features/dictionary/logic/dictionary_controller.dart';
import 'package:my_project/features/dictionary/widgets/word_item.dart';
import 'package:my_project/features/dictionary/widgets/word_search.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final DictionaryController _controller = DictionaryController();
  List<Word> _words = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _controller.initTts();
    await _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await _controller.loadWords();
    setState(() {
      _words = words;
      _isLoading = false;
    });
  }

  Future<void> _handleAddWord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWordDialog()),
    );

    if (result != null && result is Word) {
      await _controller.addWord(result);
      await _loadWords();
    }
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: WordSearchDelegate(words: _words),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Словарь'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddWord,
        child: const Icon(Icons.add),
        tooltip: 'Добавить новое слово',
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_words.isEmpty) {
      return const Center(child: Text('Словарь пуст'));
    }

    return ListView.builder(
      itemCount: _words.length,
      itemBuilder: (context, index) => WordItem(
        word: _words[index],
        onSpeak: () => _controller.speak(_words[index].en),
      ),
    );
  }
}
