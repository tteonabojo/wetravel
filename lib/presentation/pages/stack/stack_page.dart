import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/guide/guide_page.dart';
import 'package:wetravel/presentation/pages/main/main_page.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_header.dart';
import 'package:wetravel/presentation/pages/select_travel/select_travel_page.dart';
import 'package:wetravel/presentation/pages/stack/widgets/custom_bottom_navigation_bar.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

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
    _selectedIndex = widget.initialIndex; // 초기 인덱스 설정
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final isGuideAsync = ref.watch(isGuideProvider);

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
                MainHeader(),
              ],
            ),
          ),
          body: isGuideAsync.when(
            data: (isGuide) {
              final List<Widget> pages = [
                MainPage(),
                SelectTravelPage(),
                GuidePage(isGuide: isGuide),
              ];

              return IndexedStack(
                index: _selectedIndex,
                children: pages,
              );
            },
            loading: () => SizedBox.shrink(),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ));
  }
}
