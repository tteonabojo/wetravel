import 'package:flutter/material.dart';

class IndicatorCircle extends StatelessWidget {
  const IndicatorCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    );
  }
}
