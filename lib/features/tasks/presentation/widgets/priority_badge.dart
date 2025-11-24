import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onaidocs/features/tasks/domain/entities/task.dart';

class PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (priority) {
      case TaskPriority.high:
        backgroundColor = const Color(0xFFD92D20);
        textColor = Colors.white;
        label = 'Высокий';
        break;
      case TaskPriority.medium:
        backgroundColor = const Color(0xFFFEF3F2);
        backgroundColor = const Color(0xFFFFF4E5);
        textColor = const Color(0xFFB98900);
        label = 'Средний';
        break;
      case TaskPriority.low:
        backgroundColor = const Color(0xFFE6F7FF);
        textColor = const Color(0xFF0094FF);
        label = 'Низкий';
        break;
    }

    if (priority == TaskPriority.high) {
       backgroundColor = const Color(0xFFD92D20); 
       textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
