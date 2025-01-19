import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a decline reason and update the booking's status
  Future<bool> addDeclineReason(int bookingId, String reason) async {
    try {
      await _firestore.collection('bookings').doc(bookingId.toString()).update({
        'decline_reason': reason,
        'job_status': 'Declined',
      });
      return true;
    } catch (e) {
      print('Error adding decline reason: $e');
      return false;
    }
  }
}
