import 'package:flutter/material.dart';
import 'package:my_project/libs/crossword_generator.dart';

class CrosswordNavigationBar extends StatelessWidget {
  final String description;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final CrosswordStyle style;

  const CrosswordNavigationBar({
    required this.description,
    required this.onPrevious,
    required this.onNext,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: onPrevious,
              child: Icon(Icons.chevron_left),
              style: style.descriptionButtonStyle,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current clue:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onNext,
              child: Icon(Icons.chevron_right),
              style: style.descriptionButtonStyle,
            ),
          ],
        ),
      ),
    );
  }
}