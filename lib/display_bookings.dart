// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'hospitals/hospital_list.dart';
// import 'login.dart';
//
// class display_bookings extends StatefulWidget {
//   const display_bookings({Key? key}) : super(key: key);
//
//   @override
//   _display_bookingsState createState() => _display_bookingsState();
// }
//
// class _display_bookingsState extends State<display_bookings> {
//
//   List<HospitalList> hospitals = [];
//
//   bookingSubmission(String docID) async {
//     try {
//       final userID = FirebaseAuth.instance.currentUser?.uid;
//       final userRef =
//       FirebaseFirestore.instance.collection('users').doc(userID);
//       final snapshot = await userRef.get();
//       final List<String> bookings = [];
//
//       if (snapshot.exists && snapshot.data()!.containsKey('bookings')) {
//         final prevBookings = snapshot['bookings'] ?? [];
//         prevBookings.forEach((bId) {
//           if (docID != bId) {
//             //adding each booked hotel to the list using booking id
//             bookings.add(bId);
//           }
//         });
//       }
//
//       //wait untill fetched bookings and merge with the existing ones
//       await userRef.set({'bookings': bookings}, SetOptions(merge: true));
//       _getBookedHospitals();
//     } on FirebaseAuthException catch (e) {
//       print(e);
//     }
//   }
//
//
//
//   _getBookedHospitals() async {
//     final userID = FirebaseAuth.instance.currentUser?.uid;
//     final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
//     final hotelRef = FirebaseFirestore.instance.collection("Hospital_list");
//     final snapshot = await userRef.get();
//     setState(() {
//       hospitals = [];
//     });
//     if (snapshot.exists && snapshot.data()!.containsKey('bookings')) {
//       final List<dynamic> prevBookings = snapshot['bookings'] ?? [];
//       List<HospitalList> list = [];
//       prevBookings.forEach((bookId) async {
//         final hotelSnapshot = await hotelRef.doc(bookId).get();
//         if (hotelSnapshot.exists) {
//           final data = hotelSnapshot.data();
//           var bookingEntity = HospitalList(
//             docId: bookId,
//             name: data!['name'],
//             status: data['status'],
//             image: data['image'],
//             location: data['location'],
//           );
//           hospitals.add(bookingEntity);
//           setState(() {
//             hospitals = hospitals;
//           });
//         }
//       });
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightGreen.shade900,
//         title: Padding(
//           padding: const EdgeInsets.only(left: 18.0),
//           child: Text(
//             'Vaccine Booking',
//             style: TextStyle(
//               color: Colors.blueGrey.shade100,
//               fontSize: 25,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         leading: FlatButton(
//           color: Colors.lightGreen.shade900,
//           child: Icon(
//             Icons.arrow_back,
//             color: Colors.blueGrey.shade100,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           FlatButton(
//             onPressed: (){
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => login()),
//                     (route) => false,);
//             },
//             child: Icon(
//               Icons.logout,
//               color: Colors.blueGrey.shade100,
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         height: double.maxFinite,
//         width: double.maxFinite,
//         decoration: BoxDecoration(color: Colors.yellow.shade50),
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //Iterating through the booked hotels list
//                 hospitals.isNotEmpty
//                     ? ListView.builder(
//                     itemCount: hospitals.length,
//                     shrinkWrap: true,
//                     physics: const ScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final aminity = hospitals[index];
//                       return Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(22.0),
//                               child: Row(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     aminity.name ?? '',
//                                     style: TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         fontStyle: FontStyle.italic),
//                                   ),
//                                   Text(
//                                     aminity.location ?? '',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         fontStyle: FontStyle.italic),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 24),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     aminity.status ?? '',
//                                     style: TextStyle(
//                                         color: Colors.green.shade900,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         fontStyle: FontStyle.italic),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ]);
//                     })
//
//                 //Showing alternative when no hotels have been booked or all have been cancelled
//                     : const Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text(
//                       'No bookings found for you!',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'hospitals/hospital_list.dart';
// import 'login.dart';
//
// class modify_booking extends StatefulWidget {
//   const modify_booking({Key? key}) : super(key: key);
//
//   @override
//   _modify_bookingState createState() => _modify_bookingState();
// }
//
// class _modify_bookingState extends State<modify_booking> {
//
//   List<HospitalList> hospitals = [];
//
//   createAlertDialog(BuildContext context, String? docId) {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Cancellation confirmed'),
//             content: Text(
//                 'Your booking has been cancelled. Looking forward to having you back'),
//             actions: [
//               RaisedButton(
//                 onPressed: () {
//                   bookingSubmission(docId!);
//                 },
//                 color: Colors.blue.shade300,
//                 child: Text("Continue",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     )),
//               )
//             ],
//           );
//         });
//   }
//
//   bookingSubmission(String docID) async {
//     try {
//       final userID = FirebaseAuth.instance.currentUser?.uid;
//       final userRef =
//       FirebaseFirestore.instance.collection('users').doc(userID);
//       final snapshot = await userRef.get();
//       final List<String> bookings = [];
//
//       if (snapshot.exists && snapshot.data()!.containsKey('bookings')) {
//         final prevBookings = snapshot['bookings'] ?? [];
//         prevBookings.forEach((bId) {
//           if (docID != bId) {
//             //adding each booked hotel to the list using booking id
//             bookings.add(bId);
//           }
//         });
//       }
//
//       //wait untill fetched bookings and merge with the existing ones
//       await userRef.set({'bookings': bookings}, SetOptions(merge: true));
//       _getBookedHospitals();
//     } on FirebaseAuthException catch (e) {
//       print(e);
//     }
//   }
//
//
//
//   _getBookedHospitals() async {
//     final userID = FirebaseAuth.instance.currentUser?.uid;
//     final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
//     final hotelRef = FirebaseFirestore.instance.collection("Hospital_list");
//     final snapshot = await userRef.get();
//     setState(() {
//       hospitals = [];
//     });
//     if (snapshot.exists && snapshot.data()!.containsKey('bookings')) {
//       final List<dynamic> prevBookings = snapshot['bookings'] ?? [];
//       List<HospitalList> list = [];
//       prevBookings.forEach((bookId) async {
//         final hotelSnapshot = await hotelRef.doc(bookId).get();
//         if (hotelSnapshot.exists) {
//           final data = hotelSnapshot.data();
//           var bookingEntity = HospitalList(
//             docId: bookId,
//             name: data!['name'],
//             status: data['status'],
//             image: data['image'],
//             location: data['location'],
//           );
//           hospitals.add(bookingEntity);
//           setState(() {
//             hospitals = hospitals;
//           });
//         }
//       });
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightGreen.shade900,
//         title: Padding(
//           padding: const EdgeInsets.only(left: 18.0),
//           child: Text(
//             'Vaccine Booking',
//             style: TextStyle(
//               color: Colors.blueGrey.shade100,
//               fontSize: 25,
//               fontStyle: FontStyle.italic,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         leading: FlatButton(
//           color: Colors.lightGreen.shade900,
//           child: Icon(
//             Icons.arrow_back,
//             color: Colors.blueGrey.shade100,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           FlatButton(
//             onPressed: (){
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (context) => login()),
//                     (route) => false,);
//             },
//             child: Icon(
//               Icons.logout,
//               color: Colors.blueGrey.shade100,
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         height: double.maxFinite,
//         width: double.maxFinite,
//         decoration: BoxDecoration(color: Colors.yellow.shade100),
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //Iterating through the booked hotels list
//                 hospitals.isNotEmpty
//                     ? ListView.builder(
//                     itemCount: hospitals.length,
//                     shrinkWrap: true,
//                     physics: const ScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final aminity = hospitals[index];
//                       return Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 child: Image.network(
//                                     aminity.image ?? 'images/hotel1.JPG'),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(22.0),
//                               child: Row(
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     aminity.name ?? '',
//                                     style: TextStyle(
//                                         fontSize: 22,
//                                         fontWeight: FontWeight.bold,
//                                         fontStyle: FontStyle.italic),
//                                   ),
//                                   Text(
//                                     aminity.location ?? '',
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         fontStyle: FontStyle.italic),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(left: 24),
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment:
//                                 CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     aminity.status ?? '',
//                                     style: TextStyle(
//                                         color: Colors.green.shade900,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         fontStyle: FontStyle.italic),
//                                   ),
//                                   Padding(
//                                     padding:
//                                     const EdgeInsets.only(right: 24),
//                                     child: RaisedButton(
//                                       onPressed: () {
//                                         createAlertDialog(
//                                             context, aminity.docId);
//                                       },
//                                       color: Colors.redAccent.shade100,
//                                       child: Text(
//                                         'Modify',
//                                         style: TextStyle(fontSize: 18),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ]);
//                     })
//
//                 //Showing alternative when no hotels have been booked or all have been cancelled
//                     : const Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text(
//                       'No bookings found for you!',
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 22,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_booking/hospitals/appointment_entity.dart';

import 'login.dart';

class display_bookings extends StatefulWidget {
  const display_bookings({Key? key}) : super(key: key);

  @override
  _display_bookingsState createState() => _display_bookingsState();
}

class _display_bookingsState extends State<display_bookings> {
  List<AppointmentEntity> appointmentList = [];

  @override
  void initState() {
    _displayBooking();
    super.initState();
  }

  _displayBooking() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      final mainQuery = FirebaseFirestore.instance
          .collection("bookings")
          .where("userid", isEqualTo: user!.uid);

      final result = await mainQuery.get();
      List<AppointmentEntity> list = [];
      final docs = result.docs;
      for (var element in docs) {
        final snapshot = element.data();
        if (snapshot.isNotEmpty) {
          final entity = AppointmentEntity();
          entity.docId = element.id;
          entity.age = snapshot['age'];
          entity.bookingDate = snapshot['bookingdate'];
          entity.bookingTime = snapshot['bookingtime'];
          entity.firstName = snapshot['firstname'];
          entity.lastName = snapshot['lastname'];
          entity.gender = snapshot['gender'];
          entity.hospitalImage = snapshot['image'];
          entity.latitude = snapshot['hospital_latlng'].latitude;
          entity.longitude = snapshot['hospital_latlng'].longitude;
          entity.hospitalName = snapshot['hospital_name'];
          entity.hospitalStatus = snapshot['hospital_status'];
          entity.hospitalAddress = snapshot['hospital_address'];
          entity.isAccept = snapshot['isAccept'];
          entity.isCancelled = snapshot['isCancelled'];
          entity.userId = snapshot['userid'];
          list.add(entity);
        }
      }

      setState(() {
        appointmentList = list;
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormatter = DateFormat('hh-mm a');
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
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => login()),
                  (route) => false,
                );
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
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.yellow.shade100),
          child: appointmentList.isNotEmpty
              ? ListView.builder(
                  itemCount: appointmentList.length,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        width: 380,
                        height: 300,
                        //color: Colors.indigo.shade200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Name : ${appointmentList[index].firstName} ${appointmentList[index].lastName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Hospital Name : ${appointmentList[index].hospitalName}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Address : ${appointmentList[index].hospitalAddress}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Booking Date : ${formatter.format(appointmentList[index].bookingDate!.toDate())}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Booking Time : ${timeFormatter.format(appointmentList[index].bookingTime!.toDate())}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Status : ${appointmentList[index].isAccept ? "Accepted" : appointmentList[index].isCancelled ? "Cancelled" : "Pending"}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),

                        decoration: BoxDecoration(
                            color: Colors.indigo.shade200,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                  offset: Offset(2.0, 2.0))
                            ]),
                      ),
                    );
                  })
              : Center(
                  child: Text(
                    'No Booked Appointments'
                  )//CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
