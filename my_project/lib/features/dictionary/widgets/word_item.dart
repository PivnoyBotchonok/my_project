import 'package:flutter/material.dart';
import 'package:my_project/data/models/word/word.dart';

class WordItem extends StatelessWidget {
  final Word word;
  final VoidCallback onSpeak;

  const WordItem({
    super.key,
    required this.word,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: theme.cardColor,  // цвет карточки из темы
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          word.en,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            word.ru,
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.volume_up, color: theme.iconTheme.color),
          onPressed: onSpeak,
        ),
      ),
    );
  }
}
