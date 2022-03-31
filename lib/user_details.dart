import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'login.dart';

class user_details extends StatefulWidget {

  final String name, location, image, docId;
  const user_details(
      {Key? key,
        required this.name,
        required this.location,
        required this.docId,
        required this.image})
      : super(key: key);

  static const routeName = '/list';

  @override
  _user_detailsState createState() => _user_detailsState();
}

class _user_detailsState extends State<user_details> {

  final _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TimeOfDay ? time = const TimeOfDay(hour: 16, minute: 20);
  DateTime _dateTime = DateTime.now();

  final TextEditingController firstnameController = new TextEditingController();
  final TextEditingController lastnameController = new TextEditingController();
  final TextEditingController age = new TextEditingController();
  final TextEditingController gender = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    final firstnameField = TextFormField(
      decoration: InputDecoration(
          border:
          OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          labelText: 'Enter First Name',
          hintText: 'Enter Your first Name'),
      autofocus: false,
      controller: firstnameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your First Name";
        }
      },
      onSaved: (value) {
        firstnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final lastnameField = TextFormField(
      decoration: InputDecoration(
          border:
          OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          labelText: 'Enter Last Name',
          hintText: 'Enter Your last name'),
      autofocus: false,
      controller: lastnameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your Last name";
        }
      },
      onSaved: (value) {
        lastnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final ageField = TextFormField(
      decoration: InputDecoration(
        border:
        OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
        labelText: 'Age',
        hintText: 'Enter Age',
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      autofocus: false,
      obscureText: true,
      controller: age,
      validator: (value) {
        RegExp regexp = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Please enter your Age";
        }
      },
      onSaved: (value) {
        age.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final genderField = TextFormField(
      decoration: InputDecoration(
        border:
        OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
        labelText: 'Enter Gender',
        hintText: 'Confirm Gender',
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      autofocus: false,
      obscureText: true,
      controller: gender,
      validator: (value) {
        RegExp regexp = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Please enter your Gender";
        }
      },
      onSaved: (value) {
        gender.text = value!;
      },
      textInputAction: TextInputAction.done,
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
              //Navigator.pushNamed(context, '/home');
              Navigator.pop(context);
            },
          ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => login()),
                      (route) => false,);
              },
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
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: firstnameField
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: lastnameField
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ageField
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: genderField
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                'Select booking date: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                _dateTime == null
                                    ? 'Select date'
                                    : DateFormat('dd-MMMM-yyyy').format(_dateTime),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 380,
                            child: RaisedButton(
                                color: Colors.green,
                                child: Text('Select a date'),
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: _dateTime == null
                                          ? DateTime.now()
                                          : _dateTime,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2023))
                                      .then((date) {
                                    setState(() {
                                      _dateTime = date!;
                                    });
                                  });
                                }),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              child: Text(
                                'Select booking time: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                time == null
                                    ? 'Select time slot'
                                    : '${time!.hour.toString()}:${time!.minute.toString()}',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 380,
                            child: FloatingActionButton(
                                child: const Icon(
                                  Icons.access_time_outlined,
                                ),
                                onPressed: () async{
                                  TimeOfDay ? newTime = await showTimePicker(context: context,
                                      initialTime: time!);
                                  if(newTime != null) {
                                    setState(() {
                                      time = newTime;
                                    });
                                  };
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 380,
                      child: RaisedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, '/booking_confirmation');
                          }
                        },
                        color: Colors.cyan.shade600,
                        child: Text(
                          'Book Appointment',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 380,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home_screen');
                        },
                        color: Colors.red.shade300,
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
