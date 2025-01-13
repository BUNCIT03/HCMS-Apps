import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms_application/domains/Booking.dart';

class Bookingcontroller {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new booking to Firestore
  Future<bool> addBooking(Booking booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
      return true;
    } catch (e) {
      print('Error adding booking: $e');
      return false;
    }
  }

  // Fetch all bookings (optional, for admin or user history)
  Future<List<Booking>> getBookings() async {
    try {
      final querySnapshot = await _firestore.collection('bookings').get();
      return querySnapshot.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }
}
