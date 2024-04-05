// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ThemeProvider extends ChangeNotifier {
//   late ThemeData _selectedTheme;
//   late Typography defaultTypography;
//   late SharedPreferences prefs;
//
// final lightTheme = ThemeData.light().copyWith(
//     primaryColor: Colors.teal,
//     primaryColorLight: Colors.tealAccent,
//
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.teal,
//     ),
//     iconTheme: IconThemeData(
//         color: Colors.grey[300]
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: Colors.teal,
//         selectedItemColor: Colors.tealAccent,
//         unselectedItemColor: Colors.grey[300]
//     ),
//     scaffoldBackgroundColor: Colors.teal[100],
//     textTheme: const TextTheme(
//         bodyText1: TextStyle(
//             color: Colors.black
//         )
//     )
// );
//
// final darkTheme = ThemeData.dark().copyWith(
//     primaryColor: Colors.yellow,
//     primaryColorLight: Colors.yellowAccent,
//     primaryColorDark: Colors.black,
//     cardTheme: CardTheme(
//         color: Colors.grey[300]
//     ),
//     dialogTheme: const DialogTheme(
//       backgroundColor: Colors.grey,
//     ),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Colors.grey,
//     ),
//     iconTheme: IconThemeData(
//         color: Colors.grey[300]
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: Colors.grey,
//         selectedItemColor: Colors.yellow,
//         unselectedItemColor: Colors.grey[300]
//     ),
//     scaffoldBackgroundColor: Colors.black54,
//     textTheme: const TextTheme(
//         bodyText1: TextStyle(
//             color: Colors.white
//         ),
//         bodyText2: TextStyle(
//             color: Colors.white
//         ),
//         headline1: TextStyle(
//             color: Colors.white
//         )
//     ),
//     textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//             primary: Colors.black
//         )
//     ),
//     buttonTheme: const ButtonThemeData(
//         buttonColor: Colors.black45
//     ),
//     listTileTheme: const ListTileThemeData(
//         textColor: Colors.white
//     ),
//     expansionTileTheme: const ExpansionTileThemeData(
//         textColor: Colors.white
//     ),
//     searchBarTheme: SearchBarThemeData(
//         backgroundColor: MaterialStateProperty.all<Color>(
//             Colors.grey.shade600)
//     )
// );
//
//   ThemeProvider(bool darkThemeOn) {
//     _selectedTheme = darkThemeOn ? darkTheme : lightTheme;
//     // Other initialization code
//   }
//
//   Future<void> swapTheme() async {
//     prefs = await SharedPreferences.getInstance();
//
//     if (_selectedTheme == darkTheme) {
//       _selectedTheme = lightTheme;
//       await prefs.setBool("darkTheme", false);
//     } else {
//       _selectedTheme = darkTheme;
//       await prefs.setBool("darkTheme", true);
//     }
//
//     notifyListeners();
//   }
//
//   ThemeData getTheme() => _selectedTheme;
// }
