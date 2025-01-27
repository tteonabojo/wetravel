import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_inactive),
            activeIcon: Icon(Icons.airplanemode_active),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_inactive),
            activeIcon: Icon(Icons.airplanemode_active),
            label: '',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color(0xFF03C3A7),
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
