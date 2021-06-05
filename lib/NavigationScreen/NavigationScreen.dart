import 'package:ebay_clone/Screens/DashboardScreen.dart';
import 'package:ebay_clone/Screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _currentIndex = 0;
  static final List<Widget> _pageWidgets = [
    HomeScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidgets[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurple,
        onTap: bottomNavTap,
        currentIndex: _currentIndex,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
      ),
    );
  }

  void bottomNavTap(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
