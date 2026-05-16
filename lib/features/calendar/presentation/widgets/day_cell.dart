import 'package:flutter/material.dart';

class DayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isPast;

  const DayCell({
    super.key,
    required this.date,
    this.isSelected = false,
    this.isToday = false,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isSelected 
            ? (isPast ? Colors.grey : Colors.black) 
            : (isToday ? Colors.grey.shade200 : Colors.transparent),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected ? Colors.white : (isPast ? Colors.grey : Colors.black),
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isPast && !isSelected)
              const Icon(Icons.lock_outline, size: 10, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
