// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vaccine_booking/home_screen.dart';
import 'package:vaccine_booking/hospitals/appointment_entity.dart';
import 'package:vaccine_booking/hospitals/hospital_list.dart';
import 'package:vaccine_booking/signup.dart';
import 'package:vaccine_booking/user_details.dart';

import 'admin_cancelled.dart';
import 'admin_confirmed.dart';
import 'admin_home_screen.dart';

//import 'book_appointment.dart';
import 'admin_pending.dart';
import 'booking_confirmation.dart';
import 'display_bookings.dart';
import 'display_feedback.dart';
import 'feedback.dart';
import 'forgot_password.dart';
import 'hospitals_screen.dart';
import 'login.dart';
import 'modify_booking.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // Providing keys for page routing and showing initial path
        initialRoute: '/login',
        routes: {
          '/booking_confirmation': (context) => booking_confirmation(),
          '/forgot_password': (context) => forgot_password(),
          //'/book_appointment': (context) => book_appointment(),
          '/modify_booking': (context) => modify_booking(),
          '/admin_confirmed': (context) => admin_confirmed(),
          '/admin_pending': (context) => admin_pending(),
          '/admin_cancelled': (context) => admin_cancelled(),
          '/feedback': (context) => feedback(),
          '/signup': (context) => signup(),
          '/display_bookings': (context) => display_bookings(),
          '/display_feedback': (context) => display_feedback(),
          '/user_details': (context) => user_details(),
          '/hospitals_screen': (context) => hospitals_screen(),
          '/admin_home_screen': (context) => admin_home_screen(),
          '/homeScreen': (context) => homeScreen(),
          '/login': (context) => login(),
        },

        //generating arguments to use in hospital Details page
        onGenerateRoute: (settings) {
          // If you push the PassArguments route
          if (settings.name == '/list') {
            // Cast the arguments to the correct
            // type: ScreenArguments.
            final arg = settings.arguments as HospitalList;
            // Then, extract the required data from
            // the arguments and pass the data to the
            // correct screen.
            return MaterialPageRoute(
              builder: (context) {
                return user_details(
                  docId: arg.docId ?? '',
                  name: arg.name ?? '',
                  //status: arg.status ?? ',
                  image: arg.image ?? '',
                  location: arg.location ?? '',
                  appointmentEntity: arg.appointmentEntity,
                );
              },
            );
          }
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
