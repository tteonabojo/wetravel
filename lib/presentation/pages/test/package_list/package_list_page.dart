import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/test/package_list/package_list_view_model.dart';

class PackageListPage extends StatelessWidget {
  const PackageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('패키지 목록'),
      ),
      body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final packages = ref.watch(packageListViewModel);
        if (packages == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final package = packages[index];
            return Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.network(
                      package.imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(package.title),
                      Text(package.location),
                      Text(package.description!),
                      Text(package.duration!),
                    ],
                  ))
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
