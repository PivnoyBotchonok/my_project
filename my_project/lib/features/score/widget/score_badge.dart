import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final int score;
  final Color? color;

  const ScoreBadge({super.key, required this.score, this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Цвет фона для светлой темы или если явно задан цвет
    final Color backgroundColor = color ?? Colors.amber;

    // Цвет иконки — зелёный оттенок если цвет зеленый, иначе жёлтый
    final Color iconColor =
        color == Colors.green ? Colors.green[800]! : Colors.yellow;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.transparent : backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow:
            isDark
                ? null
                : const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        border: isDark ? Border.all(color: backgroundColor, width: 1.5) : null,
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
