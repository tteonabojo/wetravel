import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/guidepackage/guide_package_page.dart';

class MainPage extends StatefulWidget {
  /// 메인 페이지
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // GuidePackagePage로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GuidePackagePage()),
            );
          },
          child: Text('가이드 패키지 페이지로 이동'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

