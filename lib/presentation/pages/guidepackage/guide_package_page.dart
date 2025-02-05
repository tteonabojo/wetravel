import 'package:flutter/material.dart';
import 'widgets/app_bar.dart';
import 'widgets/filters.dart';
import 'widgets/package_card.dart';

class GuidePackagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GuideAppBar(),
          GuideFilters(),
          // Padding(
          //   padding: const EdgeInsets.only(right: 16.0, top: 8.0),
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: CircleAvatar(
          //       radius: 20,
          //       backgroundColor: Colors.grey[200],
          //       child: IconButton(
          //         icon: Icon(Icons.sort, color: Colors.black),
          //         onPressed: () {},
          //       ),
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: ListView(
          //     padding: EdgeInsets.symmetric(vertical: 8.0),
          //     children: [],
          //   ),
          // ),
        ],
      ),
    );
  }
}
