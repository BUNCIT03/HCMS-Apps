import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms_application/domains/Schedule.dart';

class ScheduleController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch bookings assigned to a specific cleaner
  Future<List<Schedule>> getSchedulesByCleaner(int cleanerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('schedules')
          .where('user_id', isEqualTo: cleanerId)
          .get();

      return querySnapshot.docs
          .map((doc) => Schedule.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }

  // Update job status for a schedule
  Future<bool> updateJobStatus(int scheduleId, String status) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId.toString()).update({
        'job_status': status,
      });
      return true;
    } catch (e) {
      print('Error updating job status: $e');
      return false;
    }
  }
}
