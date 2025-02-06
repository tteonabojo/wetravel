import 'package:flutter/material.dart';
import 'filter_chip.dart';

class GuideFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GuideFilterChip(label: "도쿄"),
            GuideFilterChip(label: "혼자"),
            GuideFilterChip(label: "2박 3일"),
            GuideFilterChip(label: "액티비티"),
            GuideFilterChip(label: "게스트 하우스"),
          ],
        ),
      ),
    );
  }
}