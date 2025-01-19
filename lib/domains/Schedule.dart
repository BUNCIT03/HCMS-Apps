class Schedule {
  final int scheduleId;
  final DateTime scheduleDate;
  final String scheduleTime;
  final String jobStatus; // Example: 'Pending', 'Completed', 'Declined'
  final DateTime createdDate;
  final int userId;

  Schedule({
    required this.scheduleId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.jobStatus,
    required this.createdDate,
    required this.userId,
  });

  // Convert Schedule object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'schedule_id': scheduleId,
      'schedule_date': scheduleDate.toIso8601String(),
      'schedule_time': scheduleTime,
      'job_status': jobStatus,
      'created_date': createdDate.toIso8601String(),
      'user_id': userId,
    };
  }

  // Convert Firestore map to a Schedule object
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      scheduleId: map['schedule_id'],
      scheduleDate: DateTime.parse(map['schedule_date']),
      scheduleTime: map['schedule_time'],
      jobStatus: map['job_status'],
      createdDate: DateTime.parse(map['created_date']),
      userId: map['user_id'],
    );
  }
}
