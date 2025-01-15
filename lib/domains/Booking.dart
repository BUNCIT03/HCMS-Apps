class Booking {
  final int bookingId;
  final String bookingType;
  final String bookingName;
  final String bookingAddress;
  final DateTime bookingDate;
  final String bookingTime;
  final int? bookingCleaner;
  final String? bookingInstruction;
  final bool lateCancelation;
  final DateTime createdDate;
  final int scheduleId;
  final int userId;
  final String username;

  Booking({
    required this.bookingId,
    required this.bookingType,
    required this.bookingName,
    required this.bookingAddress,
    required this.bookingDate,
    required this.bookingTime,
    this.bookingCleaner,
    this.bookingInstruction,
    this.lateCancelation = false,
    required this.createdDate,
    required this.scheduleId,
    required this.userId,
    required this.username,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'bookingType': bookingType,
      'bookingName': bookingName,
      'bookingAddress': bookingAddress,
      'bookingDate': bookingDate.toIso8601String(),
      'bookingTime': bookingTime,
      'bookingCleaner': bookingCleaner,
      'bookingInstruction': bookingInstruction,
      'lateCancelation': lateCancelation,
      'createdDate': createdDate.toIso8601String(),
      'scheduleId': scheduleId,
      'userId': userId,
      'username': username,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'],
      bookingType: map['bookingType'],
      bookingName: map['bookingName'],
      bookingAddress: map['bookingAddress'],
      bookingDate: DateTime.parse(map['bookingDate']),
      bookingTime: map['bookingTime'],
      bookingCleaner: map['bookingCleaner'],
      bookingInstruction: map['bookingInstruction'],
      lateCancelation: map['lateCancelation'] ?? false,
      createdDate: DateTime.parse(map['createdDate']),
      scheduleId: map['scheduleId'],
      userId: map['userId'],
      username: map['username'],
    );
  }
}
