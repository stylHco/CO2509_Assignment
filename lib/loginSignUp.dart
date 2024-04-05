import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constands.dart';
import 'main.dart';


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
                                  MaterialPageRoute(builder: (context) => const LoginForm()),
                                );
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(color: Colors.red)
                                  )
                              )),
                              child: Text(
                                "GET STARTED",
                                style: TextStyle(
                                  fontSize: 30
                                ),
                              ),

                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(
                        fontSize: 20
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
                    child: Text(
                      "create account",
                      style: TextStyle(
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
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



class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}


class _SignUpFormState extends State<SignUpForm> {
  String _email = '';
  String _password = '';
  String _name = '';
  String _repeatPassword = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                              color: Colors.tealAccent
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
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
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
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            labelText: 'Name',
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
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
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
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'Repeat Password',
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
                                                  )),
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
                                                            title: const Text(
                                                                'ERROR on Password'),
                                                            content: const Text(
                                                                'The passwords does not much. Try again'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: Navigator
                                                                    .of(context)
                                                                    .pop,
                                                                child: const Text(
                                                                    'OK'),
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

                                                      await ref.update(userData).then((_){

                                                        if (!mounted) return;
                                                        // go back so can redirect to the home page
                                                        Navigator.of(context).pop();

                                                      // show this if everything is works as expected
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    'SIGN UP'),
                                                                content: const Text(
                                                                    'You successfully created an account'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed: Navigator
                                                                        .of(context)
                                                                        .pop,
                                                                    child: const Text(
                                                                        'CLOSE'),
                                                                  )
                                                                ],
                                                              );
                                                            }
                                                        );
                                                      });


                                                    } catch (error) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return AlertDialog(
                                                            title: const Text('SIGN UP ERROR'),
                                                            content: Text('ERROR: $error'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Text('CLOSE'),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                    color: Colors.tealAccent
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
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
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
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
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
                                          )),
                                      onPressed: () async {
                                        // check if the values are valid and only then save the form,
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          try {

                                            await auth.signInWithEmailAndPassword(
                                              email: _email,
                                              password: _password,
                                            ).then((_){
                                              if (!mounted) return;

                                              // go back so can redirect to the home page
                                              Navigator.of(context).pop();
                                            });


                                          } catch (error) {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: const Text('SIGN IN ERROR'),
                                                  content: Text('ERROR: $error'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: const Text('CLOSE'),
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



