import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms_application/domains/Booking.dart';

class BookingController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new booking
  Future<bool> addBooking(Booking booking) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(booking.bookingId.toString())
          .set(booking.toMap());
      return true;
    } catch (e) {
      print('Error adding booking: $e');
      return false;
    }
  }

  // Fetch bookings by username
  Future<List<Booking>> getBookingsByUsername(String username) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('username', isEqualTo: username)
          .get();

      return querySnapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  // Fetch a single booking by its ID
  Future<Booking?> getBookingById(int bookingId) async {
    try {
      final doc = await _firestore.collection('bookings').doc(bookingId.toString()).get();
      if (doc.exists) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error fetching booking by ID: $e');
      return null;
    }
  }

  // Update a booking
  Future<bool> updateBooking(
    int bookingId,
    String username,
    String bookingType,
    String bookingName,
    String bookingAddress,
    String scheduledDate,
    String bookingTime,
    int? bookingCleaner,
    String specialInstructions,
  ) async {
    try {
      await _firestore.collection('bookings').doc(bookingId.toString()).update({
        'username': username,
        'bookingType': bookingType,
        'bookingName': bookingName,
        'bookingAddress': bookingAddress,
        'scheduledDate': scheduledDate,
        'bookingTime': bookingTime,
        'bookingCleaner': bookingCleaner,
        'specialInstructions': specialInstructions,
      });
      return true;
    } catch (e) {
      print('Error updating booking: $e');
      return false;
    }
  }

  // Delete a booking
  Future<bool> deleteBooking(int bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId.toString()).delete();
      return true;
    } catch (e) {
      print('Error deleting booking: $e');
      return false;
    }
  }

  // Fetch all bookings
  Future<List<Booking>> getAllBookings() async {
    try {
      final querySnapshot = await _firestore.collection('bookings').get();
      return querySnapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching all bookings: $e');
      return [];
    }
  }

  // Fetch bookings by a specific date
  Future<List<Booking>> getBookingsByDate(DateTime date) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('scheduledDate', isEqualTo: date.toIso8601String())
          .get();

      return querySnapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching bookings by date: $e');
      return [];
    }
  }
  // Fetch bookings where the cleaner is preferred
  Future<List<Booking>> getBookingsByCleaner(int cleanerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('bookingCleaner', isEqualTo: cleanerId)
          .get();

      return querySnapshot.docs
          .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching bookings for cleaner: $e');
      return [];
    }
  }
}
