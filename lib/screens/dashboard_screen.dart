import 'package:cabzing/app_text.dart';
import 'package:cabzing/screens/profile_page.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(
      child: AppText(
          text: 'Home Page',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white),
    ),
    const Center(
      child: AppText(
          text: 'Chat Page',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white),
    ),
    const Center(
      child: AppText(
          text: 'Notification Page',
          size: 20,
          weight: FontWeight.w600,
          textColor: Colors.white),
    ),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildBottomNavItem(String assetPath, int index) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            _selectedIndex == index ? Colors.white : const Color(0xff323232),
            BlendMode.srcIn,
          ),
          child: Image.asset(
            assetPath,
            width: 24,
            height: 24,
          ),
        ),
        if (_selectedIndex == index)
          Positioned(
            bottom: -15,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: buildBottomNavItem('assets/images/home.png', 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavItem('assets/images/route-square.png', 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavItem('assets/images/notification-bing.png', 2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavItem('assets/images/profile.png', 3),
            label: '',
          ),
        ],
      ),
    );
  }
}
