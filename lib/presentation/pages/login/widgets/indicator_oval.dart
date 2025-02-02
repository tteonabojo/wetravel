import 'package:flutter/material.dart';

class IndicatorOval extends StatelessWidget {
  const IndicatorOval({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
