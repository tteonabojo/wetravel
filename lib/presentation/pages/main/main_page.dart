import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  /// 메인 페이지
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // MainHeader(),
            MainBanner(),
            SizedBox(height: 20),
            MainRecentlyPackages(),
            MainPopularPackages(),
          ],
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

