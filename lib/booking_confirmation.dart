import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class booking_confirmation extends StatefulWidget {
  const booking_confirmation({Key? key}) : super(key: key);

  @override
  _booking_confirmationState createState() => _booking_confirmationState();
}

class _booking_confirmationState extends State<booking_confirmation> {
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
                  padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 30.0,top: 50.0),
                  child: Container(
                    width: 340,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      border: Border.all(
                        color: Colors.black,
                        width: 6,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Thank you for booking your appointment with us. '
                          '\nYour appointment is pending with the hospital. \n\n'
                          'Once confirmed you will get an e-mail.',
                      style: TextStyle(
                        fontSize: 25
                      ),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 30.0,top: 50.0),
                  child: Container(
                    width: 340,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.red,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Note: If the appointment is accepted please make sure to carry a valid ID proof to the Hospital. \n\n'
                          '(Eg: Health card, Passport etc.)',
                        style: TextStyle(
                          color: Colors.red,
                            fontSize: 18
                        ),),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 330,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/homeScreen');
                      },
                      color: Colors.green.shade300,
                      child: Text(
                        'Back to Main menu',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 25,
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
