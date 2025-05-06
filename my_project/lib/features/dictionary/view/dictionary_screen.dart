import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_project/data/models/word.dart';
import 'package:my_project/data/repositories/word_repo.dart';
import 'package:my_project/features/add_word/add_word.dart';
import 'package:my_project/features/dictionary/widgets/word_item.dart';
import 'package:my_project/features/dictionary/widgets/word_search.dart';

class DictionaryScreen extends StatefulWidget {
  @override
  _DictionaryScreenState createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  late final FlutterTts _tts;
  List<Word> _words = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _initializeTts();
    await _loadWords();
  }

  Future<void> _initializeTts() async {
    await _tts.setVoice({"name": "Karen", "locale": "en-AU"});
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _loadWords() async {
    final words = HiveService.getWords();
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
      await HiveService.addWord(result);
      await _loadWords();
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
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
        onSpeak: () => _speak(_words[index].en),
      ),
    );
  }
}