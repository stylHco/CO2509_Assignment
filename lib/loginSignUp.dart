import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constands.dart';
import 'main.dart';

import 'package:shared_preferences/shared_preferences.dart';


// make the login page
class InitialPage extends StatelessWidget {

  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // check if the device is connected to the network
    checkInternetConnection(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SelectionContainer.disabled(
              child: Padding(
                padding: EdgeInsets.only(top: 65),
                child: Text(
                  "MOVIES \n LISTS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60.0,
                  ),
                ),
              ),
            ),
            Column(
              children:
              [
                  Container(
                  width: 500,
                  height: 400,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child:
                          Image.asset(
                            filmImageUrl,
                          )
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            padding: EdgeInsets.only(top: 20),
                            child:
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  // redirect to login page
                                  MaterialPageRoute(builder: (context) => const LoginForm()),
                                );
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: Colors.red)
                                  ),
                              ),
                                  // background color that is the themes primary color
                                  backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor)
                              ),
                              child: Text(
                                "GET STARTED",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).primaryColorDark
                                ),
                              ),

                            )
                        ),
                      ),
                    ],
                  ),
                ),
                // to create new account
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:20),
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpForm()),
                      );
                    },
                    // redirect to the new account sign up page
                    child: Text(
                      "create account",
                      style: TextStyle(
                         fontSize: 15,
                         decoration: TextDecoration.underline,
                         fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor

                      ),
                    ),
                  ),
                )
              ]
            )
          ],
        ),
      ),
    );
  }
}


// the signup form
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}


class _SignUpFormState extends State<SignUpForm> {

  // temporary store  all the data in variables from the input fields
  String _email = '';
  String _password = '';
  String _name = '';
  String _repeatPassword = '';
  // this global key is used to make sure that the form is unique for validations
  // i used this website for this part
  //  https://docs.flutter.dev/cookbook/forms/validation
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MOVIES-LIST'),
      ),
      body: Stack(
            children: <Widget> [
              Positioned.fill(
                  child: Image.asset(
                    movieImageUrl,
                    // make it full height maintain the aspect ratio and go outside the container
                    fit: BoxFit.fitHeight,
                  )
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    // make the height of the container to be adjusted based on the content
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Theme.of(context).primaryColor
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColorDark

                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context).primaryColorDark
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Enter an email';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _email = value!;
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context).primaryColorDark
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Enter a name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _name = value!;
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                          obscureText: true,
                                          // to make some animation for the input
                                          // fields
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context).primaryColorDark
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Enter a password';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _password = value!;
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        TextFormField(
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'Repeat Password',
                                            labelStyle: TextStyle(
                                                color: Theme.of(context).primaryColorDark
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Repeat the password';
                                            }

                                            return null;
                                          },
                                          onSaved: (value) {
                                            _repeatPassword = value!;
                                          },
                                        ),
                                        SizedBox(height: 20.0),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,
                                            margin: EdgeInsets.symmetric(horizontal: 30),
                                            padding: EdgeInsets.only(top: 20),
                                            child:
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(50.0),
                                                          side: BorderSide(color: Colors.red)
                                                      )
                                                  ),
                                                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.teal)
                                              ),
                                              onPressed: () async {
                                                // check if the values are valid and only then save the form,
                                                if (_formKey.currentState!.validate()) {
                                                  _formKey.currentState!.save();

                                                  // check if password is not the same as the repeat password
                                                  if(_password != _repeatPassword){
                                                    showDialog(
                                                        context: context,
                                                        builder: (_){
                                                          return AlertDialog(
                                                            title:  Text(
                                                                'ERROR on Password',
                                                              style: TextStyle(
                                                                  color: Theme.of(context).primaryColorDark
                                                              ),
                                                            ),
                                                            content:  Text(
                                                                'The passwords does not much. Try again',
                                                              style: TextStyle(
                                                                  color: Theme.of(context).primaryColorDark
                                                              ),),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: Navigator
                                                                    .of(context)
                                                                    .pop,
                                                                child:  Text(
                                                                    'OK',
                                                                  style: TextStyle(
                                                                      color: Theme.of(context).primaryColorDark
                                                                  ),),
                                                              )
                                                            ],
                                                          );
                                                        }
                                                    );
                                                  }
                                                  else {

                                                    try {

                                                      await auth.createUserWithEmailAndPassword(
                                                        email: _email,
                                                        password: _password,
                                                      );

                                                      DatabaseReference ref = FirebaseDatabase.instance.ref("users");

                                                      // map the user data
                                                      Map <String, dynamic> userData = {
                                                        auth.currentUser!.uid: {
                                                          "name": _name
                                                        }
                                                      };

                                                      // then makes sure that waits the await function
                                                      // and only after continues with the rest

                                                      await ref.update(userData).then((_){

                                                        if (!mounted) return;
                                                        // go back so can redirect to the home page
                                                        Navigator.of(context).pop();

                                                      // show this if everything is works as expected
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return AlertDialog(
                                                                title:  Text(
                                                                    'SIGN UP',
                                                                  style: TextStyle(
                                                                      color: Theme.of(context).primaryColorDark
                                                                  ),
                                                                ),
                                                                content:  Text(
                                                                    'You successfully created an account',
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
                                                                        'CLOSE',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context).primaryColorDark
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                        );
                                                      });


                                                      // catch any error that may accuse
                                                    } catch (error) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return AlertDialog(
                                                            title:  Text('SIGN UP ERROR',
                                                              style: TextStyle(
                                                                  color: Theme.of(context).primaryColorDark
                                                              ),),
                                                            content: Text('ERROR: $error',
                                                              style: TextStyle(
                                                                  color: Theme.of(context).primaryColorDark
                                                              ),),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child:  Text('CLOSE',
                                                                  style: TextStyle(
                                                                      color: Theme.of(context).primaryColorDark
                                                                  ),),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    }

                                                    }
                                                  }
                                              },
                                              child: Text(
                                                'SIGN UP',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ]
        ),
    );
  }
}


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  _LoginFormState createState() => _LoginFormState();
}


class _LoginFormState extends State<LoginForm> {
  String _email = '';
  String _password = '';

// this global key is used to make sure that the form is unique for validations
  // i used this website for this part
  //  https://docs.flutter.dev/cookbook/forms/validation
  final _formKey = GlobalKey<FormState>();
  // the authendication in firebase
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MOVIES-LIST'),
      ),
      body: Stack(
        children: <Widget> [
          Positioned.fill(
              child: Image.asset(
                movieImageUrl,
                // make it full height maintain the aspect ratio and go outside the container
                fit: BoxFit.fitHeight,
              )
          ),
          Center(
            child: Column(
              // make the height of the container to be adjusted based on the content
              mainAxisSize: MainAxisSize.min,
              children:[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                      color: Theme.of(context).primaryColorLight

                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorDark
                                ),
                                keyboardType: TextInputType.emailAddress,
                                decoration:  InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColorDark
                                  ),

                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter an email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorDark
                                ),
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColorDark
                                  ),
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColorDark
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter a password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value!;
                                },
                              ),
                              SizedBox(height: 20.0),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    padding: EdgeInsets.only(top: 20),
                                    child:
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  side: BorderSide(color: Colors.red)

                                              )
                                          ), backgroundColor: MaterialStatePropertyAll<Color>(Colors.teal)
                                      ),
                                      onPressed: () async {
                                        // check if the values are valid and only then save the form,
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          try {

                                            await auth.signInWithEmailAndPassword(
                                              email: _email,
                                              password: _password,
                                            );

                                            // store and initialize the theme
                                            // in share preferences as local storage
                                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('theme', 'light')

                                                .then((_){
                                              if (!mounted) return;




                                              // go back so can redirect to the home page
                                              Navigator.of(context).pop();
                                            });


                                            // prints if eny error occurs
                                          } catch (error) {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title:  Text('SIGN IN ERROR',
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColorDark
                                                    ),),
                                                  content: Text('ERROR: $error',
                                                    style: TextStyle(
                                                        color: Theme.of(context).primaryColorDark
                                                    ),),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child:  Text('CLOSE',
                                                        style: TextStyle(
                                                            color: Theme.of(context).primaryColorDark
                                                        ),),
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }

                                        }

                                      },
                                      child: Text(
                                          'LOGIN',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}



