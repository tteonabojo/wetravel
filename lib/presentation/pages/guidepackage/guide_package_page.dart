import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/guidepackage/widgets/filterd_package_list_page.dart';
import 'widgets/app_bar.dart';
import 'widgets/filters.dart';

class GuidePackagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          GuideAppBar(),
          GuideFilters(),
          FilteredPackageListWidget(
            height: 300,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
