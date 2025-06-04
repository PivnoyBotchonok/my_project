import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/features/add_word/add_word.dart';
import 'package:my_project/features/dictionary/bloc/dictionary_bloc.dart';
import 'package:my_project/features/dictionary/bloc/dictionary_event.dart';
import 'package:my_project/features/dictionary/bloc/dictionary_state.dart';
import 'package:my_project/features/dictionary/widgets/word_item.dart';
import 'package:my_project/features/dictionary/widgets/word_search.dart';

class DictionaryScreen extends StatelessWidget {
  DictionaryScreen({super.key});

  final FlutterTts _tts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Словарь'),
        actions: [
          BlocBuilder<DictionaryBloc, DictionaryState>(
            builder: (context, state) {
              if (state is DictionaryLoaded) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: WordSearchDelegate(words: state.words),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<DictionaryBloc, DictionaryState>(
        builder: (context, state) {
          if (state is DictionaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DictionaryError) {
            return Center(child: Text('Ошибка: ${state.message}'));
          } else if (state is DictionaryLoaded) {
            if (state.words.isEmpty) {
              return const Center(child: Text('Словарь пуст'));
            }
            return ListView.builder(
              itemCount: state.words.length,
              itemBuilder:
                  (context, index) => WordItem(
                    word: state.words[index],
                    onSpeak: () => _tts.speak(state.words[index].en),
                  ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => AddWordDialog(),
          );

          if (result != null && result is Word) {
            context.read<DictionaryBloc>().add(AddNewWord(result));
          }
        },
        tooltip: 'Добавить новое слово',
        child: const Icon(Icons.add),
      ),
    );
  }
}
