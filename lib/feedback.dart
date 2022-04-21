

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'hospitals/feedback_entity.dart';
import 'login.dart';

class feedback extends StatefulWidget {
  final String name, location, status, image, docId;
  final FeedbackEntity? feedbackEntity;

  const feedback({
    Key? key,
    required this.name,
    required this.status,
    required this.location,
    required this.docId,
    required this.image,
    this.feedbackEntity,
  }) : super(key: key);

  static const routeName = '/list';

  @override
  _feedbackState createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  final _auth = FirebaseAuth.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController firstnameController = new TextEditingController();
  final TextEditingController messageController = new TextEditingController();
  FeedbackEntity feedbackEntity = FeedbackEntity();
  bool isShowLoading = false;

  @override
  void initState() {
    if (widget.feedbackEntity != null) {
      feedbackEntity = widget.feedbackEntity!;
      firstnameController.text = widget.feedbackEntity!.firstName ?? "";
      messageController.text = widget.feedbackEntity!.message ?? "";
      setState(() {});
    }
    super.initState();
  }

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

    final messageField = TextFormField(
      decoration: InputDecoration(
          border:
          OutlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
          labelText: 'Enter Feedback',
          hintText: 'Enter Your message'),
      autofocus: false,
      controller: messageController,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your feedback";
        }
      },
      onSaved: (value) {
        messageController.text = value!;
      },
      textInputAction: TextInputAction.next,
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(8), child: firstnameField),
                  Padding(padding: EdgeInsets.all(8), child: messageField),
                  isShowLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 380,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loaderState(true);
                            _feedback();
                          }
                        },
                        color: Colors.cyan.shade600,
                        child: Text(
                          'Submit Feedback',
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

  _loaderState(bool isShow) {
    setState(() {
      isShowLoading = isShow;
    });
  }

  _feedback() async {
    final data = <String, dynamic>{};
    data['firstname'] = firstnameController.text;
    data['message'] = messageController.text;
    data['userid'] = FirebaseAuth.instance.currentUser!.uid;

    if (feedbackEntity.docId != null &&
        feedbackEntity.docId!.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("feedback")
          .doc(feedbackEntity.docId)
          .set(data, SetOptions(merge: true));
      _loaderState(false);
    } else {
      var element =
      await FirebaseFirestore.instance.collection("feedback").add(data);
      feedbackEntity.docId = element.id;
      _loaderState(false);
    }
    Navigator.pushNamed(context, '/homeScreen');
  }
}
