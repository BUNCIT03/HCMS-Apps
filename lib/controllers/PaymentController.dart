import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hcms_application/domains/Payment.dart';
import 'package:hcms_application/middlewares/PaymentGateway.dart';

class PaymentController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Validate payment input
  bool validatePaymentInput(Map<String, dynamic> paymentDetails) {
    if (paymentDetails['user_id'] == null ||
        paymentDetails['booking_id'] == null ||
        paymentDetails['total_amount'] == null ||
        paymentDetails['total_amount'] <= 0) {
      return false;
    }
    return true;
  }

  // Process payment
  Future<Map<String, dynamic>> processPayment(
      Map<String, dynamic> paymentDetails) async {
    if (!validatePaymentInput(paymentDetails)) {
      return {
        'success': false,
        'message': "Invalid payment details. Please re-enter."
      };
    }

    try {
      // Panggil fungsi untuk memproses pembayaran dari PaymentGateway.dart tanpa await
      await StripeService.instance.makePayment();
       
      // Simpan data pembayaran ke Firestore setelah pembayaran berhasil
      addPayment(Payment(
        paymentId: DateTime.now().millisecondsSinceEpoch,
        totalAmount: paymentDetails['total_amount'],
        availablePaymentMethods:
            paymentDetails['available_payment_methods'] ?? [],
        selectedPaymentMethod: paymentDetails['selected_payment_method'] ?? '',
        paymentStatus: 'Completed',
        gatewayPaymentId: DateTime.now().millisecondsSinceEpoch,
        timestamp: DateTime.now(),
        userId: paymentDetails['user_id'],
        errorCode: '',
        gatewayResponse: 'Payment successful',
      ));

      return {'success': true, 'message': 'Payment processed successfully.'};
    } catch (e) {
      print('Error processing payment: $e');
      return {
        'success': false,
        'message': 'An error occurred during payment processing.'
      };
    }
  }

  // Add a new payment to Firebase
  Future<void> addPayment(Payment payment) async {
    try {
      await _firestore
          .collection('payments')
          .doc(payment.paymentId.toString())
          .set({
        'paymentId': payment.paymentId,
        'totalAmount': payment.totalAmount,
        'availablePaymentMethods': payment.availablePaymentMethods,
        'selectedPaymentMethod': payment.selectedPaymentMethod,
        'paymentStatus': payment.paymentStatus,
        'gatewayPaymentId': payment.gatewayPaymentId,
        'timestamp': payment.timestamp.toIso8601String(),
        'userId': payment.userId,
        'errorCode': payment.errorCode,
        'gatewayResponse': payment.gatewayResponse,
      });
    } catch (e) {
      print('Error adding payment: $e');
    }
  }

  // Retrieve payment status
  Future<String> retrievePaymentStatus(int paymentId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('payments')
          .doc(paymentId.toString())
          .get();
      if (doc.exists) {
        return doc['paymentStatus'];
      } else {
        return 'Payment not found';
      }
    } catch (e) {
      print('Error retrieving payment status: $e');
      return 'Error';
    }
  }

  // Get a payment from Firebase by ID
  Future<Payment?> getPayment(int paymentId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('payments')
          .doc(paymentId.toString())
          .get();
      if (doc.exists) {
        return Payment(
          paymentId: doc['paymentId'],
          totalAmount: doc['totalAmount'],
          availablePaymentMethods:
              List<String>.from(doc['availablePaymentMethods']),
          selectedPaymentMethod: doc['selectedPaymentMethod'],
          paymentStatus: doc['paymentStatus'],
          gatewayPaymentId: doc['gatewayPaymentId'],
          timestamp: DateTime.parse(doc['timestamp']),
          userId: doc['userId'],
          errorCode: doc['errorCode'],
          gatewayResponse: doc['gatewayResponse'],
        );
      } else {
        print('Payment not found');
        return null;
      }
    } catch (e) {
      print('Error retrieving payment: $e');
      return null;
    }
  }

  // Delete a payment from Firebase
  Future<void> deletePayment(int paymentId) async {
    try {
      await _firestore
          .collection('payments')
          .doc(paymentId.toString())
          .delete();
    } catch (e) {
      print('Error deleting payment: $e');
    }
  }

  // Get all payments for a specific user
  Future<List<Payment>> getUserPayments(int userId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: userId)
          .get();

      return query.docs
          .map((doc) => Payment(
                paymentId: doc['paymentId'],
                totalAmount: doc['totalAmount'],
                availablePaymentMethods:
                    List<String>.from(doc['availablePaymentMethods']),
                selectedPaymentMethod: doc['selectedPaymentMethod'],
                paymentStatus: doc['paymentStatus'],
                gatewayPaymentId: doc['gatewayPaymentId'],
                timestamp: DateTime.parse(doc['timestamp']),
                userId: doc['userId'],
                errorCode: doc['errorCode'],
                gatewayResponse: doc['gatewayResponse'],
              ))
          .toList();
    } catch (e) {
      print('Error getting user payments: $e');
      return [];
    }
  }
}
