import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'homePage.dart';
import 'moviesPage.dart';
import 'tvSeriesPage.dart';
import 'profilePage.dart';
import 'listsPage.dart';
import 'apiServices.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
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
  _MainApplicationState createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    MoviesPage(),
    TvSeriesPage(),
    ListsPage(),
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
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey[300],
        backgroundColor: Colors.teal,
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
            icon: Icon(Icons.movie_sharp),
            label: 'MOVIES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv_sharp),
            label: 'TV-SERIES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
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
