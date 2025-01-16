import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/PaymentController.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/domains/Booking.dart';

class CheckoutPage extends StatelessWidget {
  final BookingController bookingController;
  final PaymentController paymentController; //add payment
  final Booking booking;

  const CheckoutPage({
    required this.bookingController,
    required this.paymentController,
    required this.booking, // accept booking data
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menggunakan data dari objek booking
            SummaryRow(
                label: 'Booking ID', value: booking.bookingId.toString()),
            SummaryRow(label: 'Booking Type', value: booking.bookingType),
            SummaryRow(label: 'Booking Name', value: booking.bookingName),
            Divider(thickness: 1, height: 30),
            // Contoh Total, Anda bisa menambahkan logika perhitungan
            SummaryRow(
              label: 'Total',
              value: booking.bookingType == 'Basic Housekeeping'
                  ? 'RM 50'
                  : 'RM 100',
              isBold: true,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/payment');
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
