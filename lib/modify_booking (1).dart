import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_booking/hospitals/appointment_entity.dart';
import 'package:vaccine_booking/hospitals/hospital_list.dart';

import 'login.dart';

class modify_booking extends StatefulWidget {
  const modify_booking({Key? key}) : super(key: key);

  @override
  _modify_bookingState createState() => _modify_bookingState();
}

class _modify_bookingState extends State<modify_booking> {
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
          .where("userid", isEqualTo: user!.uid)
          .where("isAccept", isEqualTo: false)
          .where("isCancelled", isEqualTo: false);

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
                          // color: Colors.grey,

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
                                        Navigator.pushNamed(
                                            this.context, '/list',
                                            arguments: HospitalList(
                                              docId:
                                                  appointmentList[index].docId,
                                              name: appointmentList[index]
                                                  .hospitalName,
                                              status: appointmentList[index]
                                                  .hospitalStatus,
                                              image: appointmentList[index]
                                                  .hospitalImage,
                                              location: appointmentList[index]
                                                  .hospitalAddress,
                                              appointmentEntity:
                                                  appointmentList[index],
                                            ));
                                      },
                                      padding: const EdgeInsets.all(10),
                                      textColor: Colors.black,
                                      color: Colors.indigo.shade400,
                                      child: Text('Modify'),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        130.0, 10.0, 8.0, 10),
                                    child: RaisedButton(
                                      onPressed: () {
                                        _deleteAppointment(
                                            appointmentList[index]);
                                      },
                                      padding: const EdgeInsets.all(10),
                                      textColor: Colors.white,
                                      color: Colors.red,
                                      child: Text('Delete'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade100,
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
                    },
                  )
                : Center(
                    child: Text(
                      'No Pending Appointments'
                    )//CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  _deleteAppointment(AppointmentEntity appointmentEntity) async {
    await FirebaseFirestore.instance
        .collection("bookings")
        .doc(appointmentEntity.docId)
        .delete();
    appointmentList.remove(appointmentEntity);
    setState(() {});
  }
}
