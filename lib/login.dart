import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vaccine_booking/admin_home_screen.dart';
import 'package:vaccine_booking/signup.dart';
import 'dart:ui';
import 'facebookLogin.dart';
import 'home_screen.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofillHints: [AutofillHints.email],
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          labelText: 'Enter email',
          hintText: 'Enter Your User email'),
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your Email Address";
        }
        // conditional requirements for the mail
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid Email Address");
        }
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = TextFormField(
      decoration: InputDecoration(
        border:
            OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
        labelText: 'Password',
        hintText: 'Enter Password',
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      validator: (value) {
        //conditional requirements for password
        RegExp regexp = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Please enter your Password";
        }
        if (!regexp.hasMatch(value)) {
          return ("Please enter a valid Password");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
    );

    final loginButton = Material(
      child: MaterialButton(
        onPressed: () {
          _setLoadingState(true);
          if (_formKey.currentState!.validate()) {
            signIn(emailController.text, passwordController.text);
          }
        },
        color: Colors.cyan.shade200,
        child: Text(
          'Sign In',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
      ),
    );

    final forgotButton = TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/forgot_password');
      },
      child: Text(
        'Forgot Password? Click here',
        style: TextStyle(
            backgroundColor: Colors.yellow.shade100,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen.shade900,
          title: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              'Vaccine Booking',
              style: TextStyle(
                color: Colors.blueGrey.shade100,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: FlatButton(
            color: Colors.lightGreen.shade900,
            child: Icon(
              Icons.arrow_back,
              color: Colors.blueGrey.shade100,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            // FlatButton(
            //   onPressed: () {},
            //   child: Icon(
            //     Icons.logout,
            //     color: Colors.blueGrey.shade100,
            //   ),
            // ),
          ],
        ),
        body: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(color: Colors.yellow.shade100),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      height: 150,
                      width: 130,
                      child: Image(
                        image: AssetImage('images/logo.jpeg'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 35,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: RaisedButton(
                        color: Colors.transparent,
                        onPressed: () {
                          _signInWithFaceBook();
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SizedBox(
                                    height: 50,
                                    width: 35,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image(
                                        image:
                                            AssetImage('images/facebook.png'),
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 180,
                              child: Text(
                                'Sign in with Facebook',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 20),
                    child: Text(
                      'Or use your credentials',
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    width: 260,
                    child: emailField,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 260,
                      child: passwordField,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : loginButton,
                  ),
                  forgotButton,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New user?',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setLoadingState(bool isShow) {
    setState(() {
      isLoading = isShow;
    });
  }

  _signInWithFaceBook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    _auth.signInWithCredential(facebookAuthCredential).then((value) {
      Fluttertoast.showToast(msg: "Login SuccessFull With FaceBook");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const homeScreen()));
    });
  }

  Future<void> signIn(String email, String password) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              _setLoadingState(false),
              if (email == "admin@gmail.com")
                {
                  Fluttertoast.showToast(msg: "Admin Login SuccessFull"),
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const admin_home_screen())),
                }
              else
                {
                  Fluttertoast.showToast(msg: "Login SuccessFull"),
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const homeScreen())),
                }
            })
        .catchError((e) {
      _setLoadingState(false);
      Fluttertoast.showToast(msg: e!.message);
    });
  }
}
  
