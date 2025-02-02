import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final String? selectedDay;
  final ValueChanged<String> onDaySelected;

  const DaySelector({required this.selectedDay, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['Day 1', 'Day 2', 'Day 3']
          .map((day) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () => onDaySelected(day),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDay == day ? Color(0xFF54595f) : Color(0xFFE9EBEC),
                    foregroundColor: selectedDay == day ? Colors.white : Color(0xFF858c93),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  ),
                  child: Text(day, style: TextStyle(fontSize: 14)),
                ),
              ))
          .toList(),
    );
  }
}
