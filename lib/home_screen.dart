import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_booking/login.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final List<String> slideimage = [
    'images/image1.jpg',
    'images/image2.jpg',
    'images/image3.jpeg',
    'images/image4.jpg'
  ];

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      CarouselSlider(
                          options: CarouselOptions(
                              height: 300,
                              autoPlay: true,
                              //enableInfiniteScroll: true,
                              enlargeCenterPage: true),
                          items: slideimage
                              .map((e) => ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          e,
                                          width: double.maxFinite,
                                          height: double.maxFinite,
                                          //fit: BoxFit.fill,
                                          fit: BoxFit.contain,
                                        )
                                      ],
                                    ),
                                  ))
                              .toList()),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.redAccent.shade400),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 5.0),
                    child: Container(
                      height: 120,
                      width: 300,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/display_bookings');
                        },
                        color: Colors.transparent,
                        child: Text(
                          'Display Bookings',
                          style: TextStyle(
                            color: Colors.yellow.shade200,
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                          color: Colors.cyan.shade400
                            ),
                        child: Container(
                          height: 150,
                          width: 150,
                          color: Colors.transparent,
                          margin: EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/modify_booking');
                            },
                            color: Colors.transparent,
                            child: Text(
                              'Edit/Modify Appointment',
                              style: TextStyle(
                                color: Colors.yellow.shade200,
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.indigo.shade400),
                        child: Container(
                          height: 150,
                          width: 150,
                          margin: EdgeInsets.all(8.0),
                          color: Colors.transparent,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/hospitals_screen');
                            },
                            color: Colors.transparent,
                            child: Text(
                              'Book new Appointment',
                              style: TextStyle(
                                color: Colors.yellow.shade200,
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('For any queries'),
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            'Contact us',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.lightBlueAccent,
                              fontStyle: FontStyle.italic,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
