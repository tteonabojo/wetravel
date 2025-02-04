import 'package:flutter/material.dart';

class MainLabel extends StatelessWidget {
  final String label;
  // TODO: navigator 인자로 받아야함
  const MainLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     // TODO: navigator 연결 필요
          //     print('need action');
          //   },
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text(
          //         '더보기',
          //         style: TextStyle(color: Colors.blueAccent),
          //       ),
          //       Icon(
          //         Icons.navigate_next,
          //         color: Colors.blueAccent,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
