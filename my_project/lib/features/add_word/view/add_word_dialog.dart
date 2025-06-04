import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/data/models/word/word.dart';
import 'package:my_project/data/repositories/word/word_repo.dart';

class AddWordDialog extends StatefulWidget {
  const AddWordDialog({super.key});

  @override
  _AddWordDialogState createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _enController = TextEditingController();
  final _ruController = TextEditingController();

  @override
  void dispose() {
    _enController.dispose();
    _ruController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить новое слово'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _enController,
              decoration: InputDecoration(
                labelText: 'Английское слово',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите слово';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _ruController,
              decoration: InputDecoration(
                labelText: 'Перевод на русский',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите перевод';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final wordRepo = context.read<WordRepository>();
              final exists = await wordRepo.wordExists(_enController.text);

              if (exists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Это слово уже есть в словаре')),
                );
                return;
              }

              final newWord = Word(
                id: 0,
                en: _enController.text,
                ru: _ruController.text,
              );
              Navigator.of(context).pop(newWord);
            }
          },
          child: Text('Добавить'),
        ),
      ],
    );
  }
}
