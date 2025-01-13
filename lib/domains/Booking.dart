class Booking {
  final String placeName;
  final String address;
  final String scheduledDate;
  final String preferredCleanerOption;
  final String? selectedCleaner;
  final String? specialInstructions;

  Booking({
    required this.placeName,
    required this.address,
    required this.scheduledDate,
    required this.preferredCleanerOption,
    this.selectedCleaner,
    this.specialInstructions,
  });
  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'address': address,
      'scheduledDate': scheduledDate,
      'preferredCleanerOption': preferredCleanerOption,
      'selectedCleaner': selectedCleaner,
      'specialInstructions': specialInstructions,
    };
  }

  // Convert Firestore document to Booking object
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      placeName: map['placeName'],
      address: map['address'],
      scheduledDate: map['scheduledDate'],
      preferredCleanerOption: map['preferredCleanerOption'],
      selectedCleaner: map['selectedCleaner'],
      specialInstructions: map['specialInstructions'],
    );
  }
}
