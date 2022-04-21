import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:vaccine_booking/hospitals/appointment_entity.dart';
import 'package:vaccine_booking/hospitals/feedback_entity.dart';

import 'login.dart';

class admin_pending extends StatefulWidget {


  @override
  _admin_pendingState createState() => _admin_pendingState();
}

class _admin_pendingState extends State<admin_pending> {
  final auth = FirebaseAuth.instance;
  List<AppointmentEntity> appointmentList = [];

  @override
  void initState() {
    _displayBooking();
    super.initState();

  }

  _displayBooking() async {
    try {
      final mainQuery = FirebaseFirestore.instance
          .collection("bookings")
          .where("isAccept", isEqualTo: false)
          .where("isCancelled", isEqualTo: false);
      FirebaseFirestore.instance.collection("bookings").get().then((value)
      {
        String email = value.docs[0].get("email");
      });

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
          entity.email = snapshot['email'];
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
          decoration: BoxDecoration(color: Colors.yellow.shade100),
          child: SafeArea(
            child: appointmentList.isNotEmpty
                ? ListView.builder(
                    itemCount: appointmentList.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 315,
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
                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: RaisedButton(
                                      onPressed: () {
                                        _acceptAppointment(
                                            appointmentList[index]);
                                        String? email =
                                            appointmentList[index].email;
                                        print(email);
                                        sendNotification(email);
                                      },
                                      padding: const EdgeInsets.all(10),
                                      textColor: Colors.black,
                                      color: Colors.green,
                                      child: Text('Confirm'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        130.0, 10.0, 8.0, 10),
                                    child: RaisedButton(
                                      onPressed: () {
                                        _cancelledAppointment(
                                            appointmentList[index]);
                                      },
                                      padding: const EdgeInsets.all(10),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      child: Text('Cancel'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.shade100,
                              border: Border.all(
                                color: Colors.black,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    offset: Offset(2.0, 2.0))
                              ]),
                        ),
                      );
                    },
                  )
                : const Center(
                child: Text(
                    'No Pending Appointments'
                )//CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  _acceptAppointment(AppointmentEntity appointmentEntity) async {
    final data = <String, dynamic>{};
    data['isAccept'] = true;

    if (appointmentEntity.docId != null &&
        appointmentEntity.docId!.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(appointmentEntity.docId)
          .set(data, SetOptions(merge: true));
    }
    setState(() {
      appointmentList.remove(appointmentEntity);
    });
  }

  _cancelledAppointment(AppointmentEntity appointmentEntity) async {
    final data = <String, dynamic>{};
    data['isCancelled'] = true;

    if (appointmentEntity.docId != null &&
        appointmentEntity.docId!.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("bookings")
          .doc(appointmentEntity.docId)
          .set(data, SetOptions(merge: true));
    }
    setState(() {
      appointmentList.remove(appointmentEntity);
    });
  }

  sendNotification(String? emailName) async {
    final Email email = Email(
      body:
      "<h1>Your appointment for vaccination has been CONFIRMED.</h1>\n<p>Thank you for booking."
          "</p>\n<p>For more information about covid vaccination visit the following link: "
          "<a>https://www.cdc.gov/vaccines/hcp/vis/index.html</a>"
          "</p>\n<p>This an auto generated response. Please do no reply to this.Thanks,Your Health team</p>",
      subject: 'Vaccine Booking Confirmation',
      recipients: [emailName ?? ""],
      isHTML: true,
    );

    await FlutterEmailSender.send(email);
  }

  // Future<void> sendNotification(String email) async {
  //   await auth
  //       .sendPasswordResetEmail(email: email)
  //       .catchError((e) {
  //
  //     Fluttertoast.showToast(msg: e!.message);
  //   });
  // }
}
