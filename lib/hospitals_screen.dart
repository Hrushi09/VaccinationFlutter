import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'hospitals/hospital_list.dart';
import 'login.dart';

class hospitals_screen extends StatefulWidget {
  const hospitals_screen({Key? key}) : super(key: key);

  @override
  _hospitals_screenState createState() => _hospitals_screenState();
}

class _hospitals_screenState extends State<hospitals_screen> {

  List<HospitalList> hospitals = [];
  final profBookingID = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    _getPreMadeData();
    super.initState();
  }

  _getPreMadeData() async {
    try {
      hospitals = [];
      // get a reference to the desired document / perform a query.
      final profileRef = FirebaseFirestore.instance.collection("Hospital_List");
      // get a SnapShot of the data.
      final snapshot = await profileRef.get();
      List<HospitalList> list = [];
      if (snapshot.docs.isNotEmpty) {
        for (var element in snapshot.docs) {
          if (element.exists) {
            final data = element.data();
            var bookingEntity = HospitalList(
              docId: element.id,
              name: data['name'],
              status: data['status'],
              image: data['image'],
              location: data['location'],
            );
            list.add(bookingEntity);
          }
        }
      }
      setState(() {
        hospitals = list;
      });
      print('updated hospitals');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Hospitals allHospitalss = new Hospitals();
    // print("hospitals ${allHospitals.hospitals}");
    print('hospitals ${hospitals}');
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
        body:

        Container(
          height: double.maxFinite,
          width: double.maxFinite,
          decoration: BoxDecoration(color: Colors.yellow.shade100),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    child: hospitals.isNotEmpty
                        ? ListView.builder(
                        itemCount: hospitals.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final aminity = hospitals[index];
                          return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child:
                                    Image.network(aminity.image ?? 'images/image1.JPG'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    aminity.name ?? '',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    aminity.location ?? '',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 12),
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 24),
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/list', arguments: HospitalList(
                                              docId: aminity.docId,
                                              name: aminity.name,
                                              status: aminity.status,
                                              image: aminity.image,
                                              location: aminity.location,
                                            )
                                            );
                                          },
                                          color: Colors.cyan.shade600,
                                          child: Text(
                                            'Select',
                                            style:
                                            TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]);
                        })
                        : const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )

                ]),
          ),
        )
      // }
      // },
      //)
    );
  }

  /*onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => hospitals_screen()),
          //Navigator.pushNamed(context, '/screen');
        );
        break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => home()),
              (route) => false,
        );
    }
  }*/
}
