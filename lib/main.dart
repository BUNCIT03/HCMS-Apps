import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/screens/ManageBooking/UserHomePage.dart';
import 'controllers/auth_controller.dart';
import 'screens/home_view.dart';
import 'screens/login_view.dart';
import 'screens/registration_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the web configuration
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA9UnlFUCkvd_N2NGXTjvuMXl1Vr7ncWjo",
      authDomain: "hcms-application.firebaseapp.com",
      projectId: "hcms-application",
      storageBucket: "hcms-application.appspot.com",
      messagingSenderId: "1054378321490",
      appId: "1:1054378321490:web:f6ea958486f633db2da18b",
      measurementId: "G-SXJJ411NDE",
    ),
  );
  final controller = AuthController();
  final bookcontroller = Bookingcontroller();

  runApp(MyApp(controller, bookcontroller));
}

class MyApp extends StatelessWidget {
  final AuthController controller;
  final Bookingcontroller bookcontroller;
  const MyApp(this.controller, this.bookcontroller, {super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Cleaner Homepage',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home: HomePage(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firestore MVC App',
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
              future: controller.isUserRegistered(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return snapshot.data == true
                    ? LoginView(controller)
                    : RegistrationView(controller);
              },
            ),
        '/login': (context) => LoginView(controller),
        '/home': (context) => UserHomePage(bookcontroller),
        '/register': (context) => RegistrationView(controller),
      },
    );
  }
}
