import 'package:flutter/material.dart';
import 'package:my_project/data/models/word/word.dart';

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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newWord = Word(
                id: DateTime.now().millisecondsSinceEpoch, // Генерируем уникальный ID
                en: _enController.text,
                ru: _ruController.text,// Пустая строка, так как tr не используется
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