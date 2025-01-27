import 'package:flutter/material.dart';

class TravelType extends StatelessWidget {
  final String type;
  const TravelType({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: Text(type)),
    );
  }
}
