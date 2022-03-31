import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgot_password extends StatefulWidget {
  const forgot_password({Key? key}) : super(key: key);

  @override
  _forgot_passwordState createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {

  final _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      decoration: InputDecoration(
          border:
          OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          labelText: 'Enter Email',
          hintText: 'Enter Your E-mail'),
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your Email Address";
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid Email Address");
        }
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final resetField = Material(
      child: MaterialButton(
        onPressed: () {
          if(_formKey.currentState!.validate()) {
            reset(emailController.text);
          }
        },
        color: Colors.cyan.shade100,
        child: Text(
          'Reset',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );

    return MaterialApp(
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
                FlatButton(
                  onPressed: (){},
                  child: Icon(
                    Icons.logout,
                    color: Colors.blueGrey.shade100,
                  ),
                ),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 48,left: 35),
                          child: Text(
                            ('Fill the details to reset your password'),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Container(
                          width: 260,
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: emailField
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
                            child: resetField
                        ),
                      ]
                  ),
                ),
              ),
            )
        )
    );
  }

  Future<void> reset(String email) async {
    await _auth
    // we will directly send mail to their mail to reset
        .sendPasswordResetEmail(email: email)
        .then((uid) => {
      Fluttertoast.showToast(msg: "Check your E-mail for reset"),
      // Navigator.push(context,
      //   MaterialPageRoute(builder: (context) => Login()),
      //),
    })
        .catchError((e) {

      Fluttertoast.showToast(msg: e!.message);
    });
  }
}
