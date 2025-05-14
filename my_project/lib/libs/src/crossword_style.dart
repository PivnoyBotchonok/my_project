import 'package:flutter/material.dart';

class CrosswordStyle {
  final Color currentCellColor;
  final Color wordHighlightColor;
  final Color wordCompleteColor;
  final TextStyle cellTextStyle;
  final ButtonStyle descriptionButtonStyle;
  final Widget Function(BuildContext context, String cell, bool isSelected, bool isHighlighted, bool isCompleted)? cellBuilder;
  

  const CrosswordStyle({
    this.currentCellColor = const Color.fromARGB(255, 84, 255, 129),
    this.wordHighlightColor = const Color.fromARGB(255, 200, 255, 200),
    this.wordCompleteColor = const Color.fromARGB(255, 255, 249, 196),
    this.cellTextStyle = const TextStyle(fontWeight: FontWeight.bold),
    this.descriptionButtonStyle = const ButtonStyle(
      backgroundColor: MaterialStatePropertyAll(Colors.blue),
      foregroundColor: MaterialStatePropertyAll(Colors.white),
      padding: MaterialStatePropertyAll(EdgeInsets.all(16)),
      shape: MaterialStatePropertyAll(CircleBorder()),
    ),
    this.cellBuilder,
  });
}
