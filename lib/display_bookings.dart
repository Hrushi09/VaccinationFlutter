import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'hospitals/hospital_list.dart';
import 'login.dart';

class display_bookings extends StatefulWidget {
  const display_bookings({Key? key}) : super(key: key);

  @override
  _display_bookingsState createState() => _display_bookingsState();
}

class _display_bookingsState extends State<display_bookings> {

  List<HospitalList> hospitals = [];

  bookingSubmission(String docID) async {
    try {
      final userID = FirebaseAuth.instance.currentUser?.uid;
      final userRef =
      FirebaseFirestore.instance.collection('users').doc(userID);
      final snapshot = await userRef.get();
      final List<String> bookings = [];

      if (snapshot.exists && snapshot.data()!.containsKey('bookings')) {
        final prevBookings = snapshot['bookings'] ?? [];
        prevBookings.forEach((bId) {
          if (docID != bId) {
            //adding each booked hotel to the list using booking id
            bookings.add(bId);
          }
        });
      }

      //wait untill fetched bookings and merge with the existing ones
      await userRef.set({'bookings': bookings}, SetOptions(merge: true));
      _getBookedHospitals();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }



  _getBookedHospitals() async {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
    final hotelRef = FirebaseFirestore.instance.collection("Hospital_list");
    final snapshot = await userRef.get();
    setState(() {
      hospitals = [];
    });
    if (snapshot.exists && snapshot.data()!.containsKey('bookings')) {
      final List<dynamic> prevBookings = snapshot['bookings'] ?? [];
      List<HospitalList> list = [];
      prevBookings.forEach((bookId) async {
        final hotelSnapshot = await hotelRef.doc(bookId).get();
        if (hotelSnapshot.exists) {
          final data = hotelSnapshot.data();
          var bookingEntity = HospitalList(
            docId: bookId,
            name: data!['name'],
            status: data['status'],
            image: data['image'],
            location: data['location'],
          );
          hospitals.add(bookingEntity);
          setState(() {
            hospitals = hospitals;
          });
        }
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        decoration: BoxDecoration(color: Colors.yellow.shade50),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Iterating through the booked hotels list
                hospitals.isNotEmpty
                    ? ListView.builder(
                    itemCount: hospitals.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final aminity = hospitals[index];
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    aminity.name ?? '',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  Text(
                                    aminity.location ?? '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    aminity.status ?? '',
                                    style: TextStyle(
                                        color: Colors.green.shade900,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                    })

                //Showing alternative when no hotels have been booked or all have been cancelled
                    : const Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'No bookings found for you!',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
