import 'package:Sample/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Sample/registration_page.dart';
import 'package:Sample/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  bool isGoogleSignIn = false;
  String errorMessage = '';
  String successMessage = '';
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _emailId;
  String _password;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Charusat E-learn'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Charusat E-learn',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),

                Form(
                    key: _formStateKey,
                    autovalidate: true,

                child: Column(
                  children: <Widget>[
                    Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: validateEmail,
                            onSaved: (value) {
                              _emailId = value;
                            },
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailIdController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blue,
                            width: 2,
                            style: BorderStyle.solid)
                      ),
                      labelText: 'Email Id',
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  ),
                  Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextFormField(
                    validator: validatePassword,
                            onSaved: (value) {
                              _password = value;
                            },
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(
                            color: Colors.blue,
                            width: 2,
                            style: BorderStyle.solid)
                      ),
                      labelText: 'Password',
                      icon: Icon(
                        Icons.email,
                        color: Colors.blue,
                      ),
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  ),
                  ],
                ),
                ),
                /*FlatButton(
                  onPressed: (){
                    //forgot password screen
                  },
                  textColor: Colors.blue,
                  child: Text('Forgot Password'),
                ),*/
                (errorMessage != ''
                      ? Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        )
                      : Container()),
                Container(
                  height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        //print(_emailIdController.text);
                       // print(_passwordController.text);
                        if (_formStateKey.currentState.validate()) {
                              _formStateKey.currentState.save();
                              signIn(_emailId, _password).then((user) {
                                if (user != null) {
                                  print('Logged in successfully.');
                                  setState(() {
                                    Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  });
                                } else {
                                  print('Error while Login.');
                                }
                              });
                            }
                      },
                    )),
                

                (successMessage != ''
                  ? Text(
                  successMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                )
                : Container()),

                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                         width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ),
                      Text('or'),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.orange,
                      child: Text('Login via Google'),
                      onPressed: () {
                        //print(_emailIdController.text);
                       // print(_passwordController.text);
                        googleSignin(context).then((user) {
                      if (user != null) {
                        print('Logged in successfully.');
                        setState(() {
                          isGoogleSignIn = true;
                          Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        });
                      } else {
                        print('Error while Login.');
                      }
                    });
                      },
                    )),

                Container(
                  child: Row(
                    children: <Widget>[
                      Text('Does not have account?'),
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => RegistrationPage(),
                              ),
                            );
                          //signup screen
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                )),

              ],
            )));
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  Future<FirebaseUser> googleSignin(BuildContext context) async {
    FirebaseUser currentUser;
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      print(currentUser);
      print("User Name  : ${currentUser.displayName}");
    } catch (e) {
      handleError(e);
    }
    return currentUser;
  }

  Future<bool> googleSignout() async {
    await auth.signOut();
    await googleSignIn.signOut();
    return true;
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
        });
        break;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return 'Password is empty!!!';
    }
    return null;
  }
}