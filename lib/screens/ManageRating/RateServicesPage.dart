import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RateServicesPage extends StatelessWidget {
  final int ratingId;
  final int cleanerId;
  final int houseOwnerId;
  final double ratingScore;
  final String reviewComments;
  final DateTime ratingDate;

  RateServicesPage({
    required this.ratingId,
    required this.cleanerId,
    required this.houseOwnerId,
    required this.ratingScore,
    required this.reviewComments,
    required this.ratingDate,
  });

  Future<void> addRating() async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'ratingId': ratingId,
        'cleanerId': cleanerId,
        'houseOwnerId': houseOwnerId,
        'ratingScore': ratingScore,
        'reviewComments': reviewComments,
        'ratingDate': ratingDate.toIso8601String(),
      });
      print('Rating added successfully.');
    } catch (e) {
      print("Error adding rating: $e");
    }
  }

  Future<void> deleteRating() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('ratings')
          .where('ratingId', isEqualTo: ratingId)
          .get();

      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance.collection('ratings').doc(doc.id).delete();
        print('Rating deleted successfully.');
      }
    } catch (e) {
      print("Error deleting rating: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Services'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: addRating,
              child: Text('Add Rating'),
            ),
            ElevatedButton(
              onPressed: deleteRating,
              child: Text('Delete Rating'),
            ),
          ],
        ),
      ),
    );
  }
}
