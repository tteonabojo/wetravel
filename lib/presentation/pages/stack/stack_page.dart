import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/main/main_page.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_header.dart';
import 'package:wetravel/presentation/pages/mypage/mypage.dart';
import 'package:wetravel/presentation/pages/new_trip/new_trip_page.dart';
import 'package:wetravel/presentation/pages/saved_plans/saved_plans_page.dart';
import 'package:wetravel/presentation/pages/stack/widgets/custom_bottom_navigation_bar.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class StackPage extends ConsumerStatefulWidget {
  final int initialIndex;

  const StackPage({
    super.key,
    this.initialIndex = 0,
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
    final isGuideAsync = ref.watch(isGuideProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Column(
            children: [
              SizedBox(height: statusBarHeight),
              const MainHeader(),
            ],
          ),
        ),
        body: isGuideAsync.when(
          data: (isGuide) {
            final List<Widget> pages = [
              MainPage(),
              const NewTripPage(),
              const SavedPlansPage(),
              MyPage(),
            ];

            return IndexedStack(
              index: _selectedIndex,
              children: pages,
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) =>
              Center(child: Text('stack page Error: $error')),
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
