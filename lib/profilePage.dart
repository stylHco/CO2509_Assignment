import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  @override
  void initState() {
    super.initState();
    updateName();
  }

  Future<void> updateName() async {
    _name = await GetUserName();
    setState(() {}); // Refresh the UI after getting the name
  }

  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: const Column(
                    children: [
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ]
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:  Theme.of(context).primaryColor,

                      ),
                      child: Icon(
                        Icons.person,
                        size: 70,

                        color:  Theme.of(context).primaryColorDark,


                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Column(
                        children: [
                          if(_name == null)
                            CircularProgressIndicator()
                          else
                            Text(
                              _name??"",
                              style: TextStyle(
                                  fontSize: 35,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          Text(
                            auth.currentUser?.email ?? "--",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title:  Text(
                                    'Log out',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColorDark
                                  ),
                                ),
                                content:  Text(
                                    'Are you sure you want to logout?',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColorDark
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: Navigator
                                        .of(context)
                                        .pop,
                                    child:  Text(
                                        'NO',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: ()  async {
                                      await logout().then((_){
                                        if (!mounted) return;
                                        // go back so can redirect to the home page
                                        Navigator.of(context).pop();
                                      });
                                    },
                                    child:  Text(
                                        'YES',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColorDark
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                        );
                      },
                      child: Row(
                        children: [
                          Text(
                            "Logout",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red
                            ),
                          ),
                          Icon(
                            Icons.exit_to_app,
                            size: 20,
                            color: Colors.red,
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 30),
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                          "Preferences",
                        style: Theme.of(context).textTheme.bodyText1,

                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).primaryColorLight,
                      ),

                      children: <Widget>[
                        ListTile(
                          title: ExpansionTile(
                            title: Text(
                                "Change Theme",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Icon(
                              Icons.chevron_right_rounded,
                              color: Theme.of(context).primaryColorLight,
                            ),


                            children: <Widget>[
                              ListTile(
                                  title: TextButton(
                                    style: ButtonStyle(

                                    ),
                                    onPressed: () async {
                                      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                                    },
                                    child: Text(
                                        "Toggle Theme (light or dark)",
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


// logout procedure
Future<void> logout() async {

  // remove the stored preferences from the device when the user logout
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('theme');


  await FirebaseAuth.instance.signOut();
}

// get the name of the use based on the user that is logged in

Future<String> GetUserName() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref();
  final snapshot =
  await ref.child('users/${auth.currentUser?.uid}/name').get();
  if (snapshot.exists) {
    return snapshot.value.toString();
  }
  return "--";
}
