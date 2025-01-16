import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/PaymentController.dart';
import 'package:hcms_application/screens/ManagePayment/CheckoutPage.dart';
import 'package:hcms_application/screens/ManagePayment/PaymentPage.dart';
import 'package:hcms_application/screens/ManagePayment/PaymentProcessPage.dart';
import 'package:hcms_application/screens/ManageUser/RegisterPage.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/screens/login_view.dart';

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserController userController = UserController();
  final BookingController bookingController = BookingController();
  final PaymentController paymentController = PaymentController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HCMS Apps',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: SplashScreen(userController: userController),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(userController),
        '/register': (context) => RegisterPage(userController),
        '/checkout': (context) => CheckoutPage(
          paymentController: paymentController,
          bookingController: bookingController,
          booking: ModalRoute.of(context)?.settings.arguments as Booking,
        ),
        '/payment': (context) => PaymentPage(paymentController: paymentController),
        '/payment-process': (context) => PaymentProcessPage(paymentController: paymentController,),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  final UserController userController;

  const SplashScreen({required this.userController, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: userController.isUserRegistered("test_username"), // Example logic
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginView(userController),
              ),
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPage(userController),
              ),
            );
          });
        }
        return Scaffold(
          body: Center(
            child: Text('Redirecting...'),
          ),
        );
      },
    );
  }
}
