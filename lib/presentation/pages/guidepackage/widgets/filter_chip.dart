import 'package:flutter/material.dart';

class GuideFilterChip extends StatelessWidget {
  final String label;

  GuideFilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Chip(
        label: Text(label),
        backgroundColor: const Color.fromRGBO(12, 13, 14, 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}