import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
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
                      color: Colors.tealAccent,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 70,

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
                              title: const Text(
                                  'Log out'),
                              content: const Text(
                                  'Are you sure you want to logout?'),
                              actions: [
                                TextButton(
                                  onPressed: Navigator
                                      .of(context)
                                      .pop,
                                  child: const Text(
                                      'NO'
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
                                  child: const Text(
                                      'YES'),
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
            )
          ],
        ),
      ),
        backgroundColor: Colors.teal[100]
    );

  }
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

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
