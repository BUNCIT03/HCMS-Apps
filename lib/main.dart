import 'package:flutter/material.dart';
import './screens/HomePage.dart';
import './screens/ManageRating/RateServicesPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//HomePage dan RateService
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(
              ratingId: 1,
              cleanerId: 101,
              houseOwnerId: 201,
              ratingScore: 4.5,
              reviewComments: "Great service!",
              ratingDate: DateTime.now(),
            ),
        '/rateServices': (context) => RateServicesPage(
              ratingId: 1,
              cleanerId: 101,
              houseOwnerId: 201,
              ratingScore: 4.5,
              reviewComments: "Great service!",
              ratingDate: DateTime.now(),
            ),
      },
    );
  }
}
