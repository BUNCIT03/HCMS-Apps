import 'package:flutter/material.dart';
import 'package:hcms_application/middlewares/PaymentGateway.dart';
import 'package:hcms_application/controllers/PaymentController.dart';

class PaymentPage extends StatefulWidget {
  final PaymentController paymentController;

  const PaymentPage({
    required this.paymentController,
    super.key,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isProcessing = false; // Menambahkan status untuk proses pembayaran

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue with Stripe'),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed with Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Menambahkan indikator proses pembayaran
            if (_isProcessing) CircularProgressIndicator(),
            if (!_isProcessing)
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isProcessing = true; // Menandai proses pembayaran dimulai
                  });

                  try {
                    // Panggil StripeService untuk pembayaran
                    await StripeService.instance.makePayment();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Successful!')),
                    );

                    // Setelah pembayaran berhasil, arahkan ke halaman PaymentProcessPage
                    Navigator.pushNamed(
                      context,
                      '/payment-process', // Halaman tujuan
                      arguments: {
                        'paymentStatus': 'Success', // Kirim status pembayaran
                      },
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Payment Failed: $e')),
                    );

                    // Kirim status gagal ke halaman PaymentProcessPage
                    Navigator.pushNamed(
                      context,
                      '/payment-process', // Halaman tujuan
                      arguments: {
                        'paymentStatus': 'Failed', // Status gagal
                      },
                    );
                  } finally {
                    setState(() {
                      _isProcessing =
                          false; // Menandai proses pembayaran selesai
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Pay with Stripe'),
              ),
          ],
        ),
      ),
    );
  }
}
