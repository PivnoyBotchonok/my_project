import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int score;
  final Color? color;

  const ScoreBadge({super.key, required this.score, this.color});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? Colors.amber;
    final Color iconColor = color == Colors.green ? Colors.green[800]! : Colors.yellow;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: iconColor),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
