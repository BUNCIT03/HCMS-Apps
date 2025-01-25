import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/screens/ManageUser/RegisterPage.dart';
import 'screens/login_view.dart';

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
  const MyApp({super.key});
//HomePage dan RateService
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginView(userController),
        '/register': (context) => RegisterPage(userController),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  final UserController userController;

  const SplashScreen({required this.userController, Key? key})
      : super(key: key);

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
