import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final int ratingId;
  final int cleanerId;
  final int houseOwnerId;
  final double ratingScore;
  final String reviewComments;
  final DateTime ratingDate;

  HomePage({
    required this.ratingId,
    required this.cleanerId,
    required this.houseOwnerId,
    required this.ratingScore,
    required this.reviewComments,
    required this.ratingDate,
  });

  Future<void> fetchRatings() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('houseOwnerId', isEqualTo: houseOwnerId)
          .get();

      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    } catch (e) {
      print("Error fetching ratings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, User $houseOwnerId!'),
            ElevatedButton(
              onPressed: fetchRatings,
              child: Text('Fetch Ratings'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/rateServices'),
              child: Text('Rate Services'),
            ),
          ],
        ),
      ),
    );
  }
}
