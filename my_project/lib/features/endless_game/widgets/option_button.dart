import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  const OptionButton({
    required this.text,
    required this.onPressed,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(200, 50),
        textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
      ),
      child: Text(text),
    );
  }
}
