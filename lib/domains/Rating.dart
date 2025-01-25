class Rating {
  // Attributes
  final int ratingId;
  final int cleanerId;
  final int houseOwnerId;
  final double ratingScore;
  final String reviewComments;
  final DateTime ratingDate;

  Rating({
    required this.ratingId,
    required this.cleanerId,
    required this.houseOwnerId,
    required this.ratingScore,
    required this.reviewComments,
    required this.ratingDate,
  });

  // Methods
  void save() {
    print("Saving rating $ratingId to the database...");
  }

  void update() {
    print("Updating rating $ratingId in the database...");
  }

  void delete() {
    print("Deleting rating $ratingId from the database...");
  }

  void linkToService(int serviceId) {
    print("Linking rating $ratingId to service $serviceId...");
  }
}
