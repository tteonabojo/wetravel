import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/guide/guide_package_list_page.dart';
import 'package:wetravel/presentation/pages/main/main_page.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_header.dart';
import 'package:wetravel/presentation/pages/my_page/my_page.dart';
import 'package:wetravel/presentation/pages/new_trip/new_trip_page.dart';
import 'package:wetravel/presentation/pages/stack/widgets/custom_bottom_navigation_bar.dart';

class StackPage extends ConsumerStatefulWidget {
  final int initialIndex; // 초기 인덱스

  const StackPage({
    super.key,
    this.initialIndex = 0, // 기본값은 0
  });

  @override
  ConsumerState<StackPage> createState() => _StackPageState();
}

class _StackPageState extends ConsumerState<StackPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Column(
            children: [
              SizedBox(height: statusBarHeight),
              MainHeader(selectedIndex: _selectedIndex),
            ],
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const MainPage(),
            const NewTripPage(),
            const GuidePackageListPage(),
            MyPage(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          context: context,
          ref: ref,
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
