import 'package:flutter/material.dart';
import 'widgets/app_bar.dart';
import 'widgets/filters.dart';

class FilteredGuidePackagePage extends StatelessWidget {
  const FilteredGuidePackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GuideAppBar(),
          GuideFilters(),
        ],
      ),
    );
  }
}
