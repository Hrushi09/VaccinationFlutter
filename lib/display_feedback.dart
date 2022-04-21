import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'hospitals/feedback_entity.dart';
import 'login.dart';

class display_feedback extends StatefulWidget {
  const display_feedback({Key? key}) : super(key: key);

  @override
  _display_feedbackState createState() => _display_feedbackState();
}

class _display_feedbackState extends State<display_feedback> {

  final auth = FirebaseAuth.instance;
  List<FeedbackEntity> feedbackList = [];

  @override
  void initState() {
    _displayFeedback();
    super.initState();
  }


  _displayFeedback() async {
    try {
      final mainQuery = FirebaseFirestore.instance
          .collection("feedback");
      FirebaseFirestore.instance.collection("feedback").get().then((value)
      {
        String email = value.docs[0].get("email");
      });

      final result = await mainQuery.get();
      List<FeedbackEntity> list = [];
      final docs = result.docs;
      for (var element in docs) {
        final snapshot = element.data();
        if (snapshot.isNotEmpty) {
          final entity = FeedbackEntity();
          entity.docId = element.id;
          entity.firstName = snapshot['firstname'];
          entity.message = snapshot['message'];
          list.add(entity);
        }
      }

      setState(() {
        feedbackList = list;
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }


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
          child: SafeArea(
            child: feedbackList.isNotEmpty
                ? ListView.builder(
              itemCount: feedbackList.length,
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
                            'Name : ${feedbackList[index].firstName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Message :  ${feedbackList[index].message}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
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
                    'No Feedbacks'
                )//CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
