import 'package:flutter/material.dart';
import 'package:my_project/data/models/word.dart';

class WordItem extends StatelessWidget {
  final Word word;
  final VoidCallback onSpeak;

  const WordItem({
    Key? key,
    required this.word,
    required this.onSpeak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          word.en,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            word.ru,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: onSpeak,
        ),
      ),
    );
  }
}