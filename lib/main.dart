import 'package:flutter/material.dart';
import 'Page1.dart';
import 'Page2.dart';
import 'Page3.dart';
import 'Page4.dart';
import 'Page5.dart';
import 'api-call.dart';

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainApplication(),
    );
  }
}

class MainApplication extends StatefulWidget {
  const MainApplication({super.key});

  @override
  _MainApplication createState() => _MainApplication();
}

class _MyHomePag_MainApplicationState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    SearchPage(),
    MoviesPage(),
    TVSeriesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOVIES-LIST'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        elevation: 10,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favourites),
            label: 'MOVIES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'TV-SERIES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'LISTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
