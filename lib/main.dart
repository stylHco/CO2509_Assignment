import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'homePage.dart';
import 'loginSignUp.dart';
import 'moviesPage.dart';
import 'tvSeriesPage.dart';
import 'profilePage.dart';
import 'listsPage.dart';
import 'apiServices.dart';


import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';


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


Future<bool> checkInternetConnection(BuildContext context) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == false) {
    buildAlert(context);
  }
  return (result == true);
}


void buildAlert(BuildContext context) {
         showDialog(
            context: context,
            builder: (_)
          {
             return AlertDialog(
               title: const Text('Network Connection Lost'),
               content: const Text('Check you network and try again'),
               actions: [
                 TextButton(
                   onPressed: Navigator
                       .of(context)
                       .pop,
                   child: const Text('Retry'),
                 )
                 ,TextButton(
                   onPressed: ()=> exit(0),
                   child: const Text('Exit'),
                 ),
               ],
             );
          }
         );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // themeMode: ThemeMode.dark,
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
    );
  }
}

class MainApplication extends StatefulWidget {
  const MainApplication({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkInternetConnection(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOVIES-LIST'),
        backgroundColor: Colors.teal,
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


// check if user is logged in using firebase auth

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use StreamBuilder to listen for changes in the user's sign-in state
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the snapshot has user data, then they are logged in
        if (snapshot.hasData) {
          return const MainApplication(); // Your main page widget
        } else {
          return InitialPage(); // Your login page widget
        }
      },
    );
  }
}
