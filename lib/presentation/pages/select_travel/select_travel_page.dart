import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/select_travel/widgets/travel_type.dart';

class SelectTravelPage extends StatelessWidget {
  const SelectTravelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TravelType(type: '기존여행\n계속하기'),
            TravelType(type: '새로운여행\n시작하기'),
          ],
        ),
      ),
    );
  }
}

class NewTripPage extends StatelessWidget {
  const NewTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... 기존 UI 코드
            ],
          ),
        ),
      ),
    );
  }
}
