import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class admin_home_screen extends StatefulWidget {
  const admin_home_screen({Key? key}) : super(key: key);

  @override
  _admin_home_screenState createState() => _admin_home_screenState();
}

class _admin_home_screenState extends State<admin_home_screen> {
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 50.0,bottom: 10),
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/admin_pending');
                    },
                    child: Container(
                      height: 150,
                      width: 380,
                      color: Colors.green.shade100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Display all pending Appointments',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 30
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 50.0,bottom: 10),
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/admin_confirmed');
                    },
                    child: Container(
                      height: 150,
                      width: 380,
                      color: Colors.red.shade100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Display all confirmed Appointments',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 30
                            ),),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 50.0,bottom: 10),
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/admin_cancelled');
                    },
                    child: Container(
                      height: 150,
                      width: 380,
                      color: Colors.blue.shade100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Display all Cancelled Appointments',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 30
                            ),),
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
    );
  }
}
