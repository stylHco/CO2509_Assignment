import 'dart:io';

import 'package:battery/battery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // initilize the app with the firebase
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


Future<bool> checkButtery(BuildContext context) async {
  // on opening of the app check the buttery and shows a dialog if is < 30%
  var _battery = Battery();

  print("heere");
  int butterLevel = await _battery.batteryLevel;

  if (butterLevel < 30){
    AllertForButtery(context);
  }

  return true;
}


void AllertForButtery(BuildContext context) {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  Firebase.initializeApp().then((_) {
    // Show the alert
    showDialog(
      context: context, // Use a predefined context or pass it as an argument
      builder: (_) => AlertDialog(
        title:  Text(
            'Low Battery Alert',
          style: TextStyle(
            color: Theme.of(context).primaryColorDark
          ),
        ),
        content:  Text(
            'Your battery level is below 30%. Consider using dark mode',
          style: TextStyle(
              color: Theme.of(context).primaryColorDark
          ),
        ),
        actions: [
          TextButton(
            onPressed:Navigator
                .of(context)
                .pop,
            child:  Text(
                'OK',
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark
              ),
            ),
          ),
        ],
      ),
    );
  });
}



class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs) {
    _selectedTheme = _prefs.getBool('darkTheme') ?? false ? darkTheme : lightTheme;
  }

  ThemeData getTheme() => _selectedTheme;

  void toggleTheme() {
    _selectedTheme = _selectedTheme == lightTheme ? darkTheme : lightTheme;
    _prefs.setBool('darkTheme', _selectedTheme == darkTheme);
    notifyListeners();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // shared preferences to store locally the decision of the theme
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final SharedPreferences prefs = snapshot.data!;
        return ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(prefs),
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return MaterialApp(
                darkTheme: darkTheme,
                theme: themeProvider.getTheme(),
                home: AuthWrapper(),
              );
            },
          ),
        );
      },
    );
  }
}

class MainApplication extends StatefulWidget {
  MainApplication({Key? key}) : super(key: key);

  @override
  _MainApplicationState createState() => _MainApplicationState();
}

class _MainApplicationState extends State<MainApplication> {
  bool butteryChecked = false;
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
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
    // check the connection constantly
    checkInternetConnection(context);
    // make sure that only going to check the buttery once.
    if(!butteryChecked){
      checkButtery(context);
      butteryChecked = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOVIES-LIST'),
        // backgroundColor: Colors.teal,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // selectedItemColor: Colors.tealAccent,
        // unselectedItemColor: Colors.grey[300],
        // backgroundColor: Colors.teal,
        elevation: 10,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        // bottom navigation items for each page
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
        // If the snapshot has user data, then is logged in
        if (snapshot.hasData) {
          return  MainApplication(); // main application
        } else {
          return InitialPage(); // login page
        }
      },
    );
  }
}



final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.teal,
    primaryColorLight: Colors.tealAccent,
    primaryColorDark: Colors.black,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
    ),
    iconTheme: IconThemeData(
        color: Colors.grey[300]
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.teal,
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey[300]
    ),
    scaffoldBackgroundColor: Colors.teal[100],
    textTheme:  TextTheme(
        bodyText1: TextStyle(
            color: Colors.black
        ),
        bodyText2: TextStyle(
            color: Colors.black
        ),
        headline1: TextStyle(
            color: Colors.black
        ),
    )
);

// dark theme data

final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.yellow,
    primaryColorLight: Colors.yellowAccent,
    primaryColorDark: Colors.black,
    cardTheme: CardTheme(
        color: Colors.grey[300]
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.grey,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
    ),
    iconTheme: IconThemeData(
        color: Colors.grey[300]
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey[300]
    ),
    scaffoldBackgroundColor: Colors.black54,
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            color: Colors.white
        ),
        bodyText2: TextStyle(
            color: Colors.white
        ),
        headline1: TextStyle(
            color: Colors.white
        )
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            primary: Colors.black
        )
    ),
    buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black45
    ),
    listTileTheme: const ListTileThemeData(
        textColor: Colors.white
    ),
    expansionTileTheme: const ExpansionTileThemeData(
        textColor: Colors.white
    ),
    searchBarTheme: SearchBarThemeData(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.grey.shade600)
    )
);