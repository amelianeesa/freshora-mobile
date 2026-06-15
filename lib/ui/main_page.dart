import 'package:flutter/material.dart';
import 'home_page.dart';
import 'service_page.dart';
import 'history_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ServicePage(),
    HistoryPage(),
    Scaffold(body: Center(child: Text("Profile Page"))), // Bagian Orang 1
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF6A0DAD), // Warna Ungu Utama
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() { _currentIndex = index; });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Service'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Tracking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}