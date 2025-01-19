import 'package:flutter/material.dart';

class Activity {
  final int activityId;
  final String activityStatus;
  final bool taskComplete;
  final String? activityPhoto;
  final String? activityIssue;
  final String? feedback;
  final DateTime? acceptDate;
  final DateTime? completionDate;
  final DateTime? inProgressDate;
  final String? declineReason;
  final DateTime? alternativeDate;
  final DateTime createdDate;
  final int bookingId;
  final int scheduleId;
  final int userId;

  Activity({
    required this.activityId,
    this.activityStatus = 'Pending', // Default value
    this.taskComplete = false, // Default value
    this.activityPhoto,
    this.activityIssue,
    this.feedback,
    this.acceptDate,
    this.completionDate,
    this.inProgressDate,
    this.declineReason,
    this.alternativeDate,
    required this.createdDate,
    required this.bookingId,
    required this.scheduleId,
    required this.userId,
  });

  // Convert Activity object to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
      'activityStatus': activityStatus,
      'taskComplete': taskComplete,
      'activityPhoto': activityPhoto,
      'activityIssue': activityIssue,
      'feedback': feedback,
      'acceptDate': acceptDate?.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'inProgressDate': inProgressDate?.toIso8601String(),
      'declineReason': declineReason,
      'alternativeDate': alternativeDate?.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'bookingId': bookingId,
      'scheduleId': scheduleId,
      'userId': userId,
    };
  }

  // Create Activity object from Map
  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      activityId: map['activityId'],
      activityStatus: map['activityStatus'] ?? 'Pending',
      taskComplete: map['taskComplete'] ?? false,
      activityPhoto: map['activityPhoto'],
      activityIssue: map['activityIssue'],
      feedback: map['feedback'],
      acceptDate: map['acceptDate'] != null ? DateTime.parse(map['acceptDate']) : null,
      completionDate: map['completionDate'] != null ? DateTime.parse(map['completionDate']) : null,
      inProgressDate: map['inProgressDate'] != null ? DateTime.parse(map['inProgressDate']) : null,
      declineReason: map['declineReason'],
      alternativeDate: map['alternativeDate'] != null ? DateTime.parse(map['alternativeDate']) : null,
      createdDate: DateTime.parse(map['createdDate']),
      bookingId: map['bookingId'],
      scheduleId: map['scheduleId'],
      userId: map['userId'],
    );
  }
}
