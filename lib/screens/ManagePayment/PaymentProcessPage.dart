import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/PaymentController.dart';

class PaymentProcessPage extends StatelessWidget {
  final PaymentController paymentController;

  const PaymentProcessPage({
    required this.paymentController,
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    // catch argument 'paymentStatus' send from PaymentPage.dart
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final paymentStatus = arguments?['paymentStatus'] ?? 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Status'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              paymentStatus == 'Success' ? Icons.check_circle : Icons.error,
              size: 100,
              color: paymentStatus == 'Success' ? Colors.green : Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'Payment $paymentStatus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // back to PaymentPage
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
