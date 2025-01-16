class Payment {
  final int paymentId;
  final double totalAmount;
  final List<String> availablePaymentMethods;
  String selectedPaymentMethod;
  String paymentStatus;
  final int gatewayPaymentId;
  final DateTime timestamp;
  final int userId;
  String errorCode;
  String gatewayResponse;

  Payment({
    required this.paymentId,
    required this.totalAmount,
    required this.availablePaymentMethods,
    this.selectedPaymentMethod = '',
    this.paymentStatus = 'Pending',
    required this.gatewayPaymentId,
    required this.timestamp,
    required this.userId,
    this.errorCode = '',
    this.gatewayResponse = '',
  });

  // Validates that the payment amount is greater than 0
  bool validateAmount() {
    return totalAmount > 0;
  }

  // Updates the status of the payment
  void updateStatus(String newStatus) {
    paymentStatus = newStatus;
  }

  // Checks if the payment status is "Completed"
  bool isCompleted() {
    return paymentStatus == 'Completed';
  }

  // Logs an error with the code and response message
  void logError(String code, String response) {
    errorCode = code;
    gatewayResponse = response;
  }
}
