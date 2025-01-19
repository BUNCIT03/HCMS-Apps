import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/screens/ManageCleanerActivityUpdate/ActivityPage.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';
import 'package:intl/intl.dart';

class CleanerHomePage extends StatefulWidget {
  final BookingController bookingController;
  final UserController userController;
  final String username;
  final int cleanerId;

  CleanerHomePage({
    required this.bookingController,
    required this.userController,
    required this.username,
    required this.cleanerId,
  });

  @override
  _CleanerHomePageState createState() => _CleanerHomePageState();
}

class _CleanerHomePageState extends State<CleanerHomePage> {
  List<Booking> _availableBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvailableBookings();
  }

  Future<void> _fetchAvailableBookings() async {
    setState(() {
      _isLoading = true;
    });

    final bookings =
        await widget.bookingController.getBookingsByCleaner(widget.cleanerId);

    setState(() {
      _availableBookings = bookings;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to HCMS'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hi, ${widget.username}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Available Bookings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                Expanded(
                  child: _availableBookings.isEmpty
                      ? const Center(
                          child: Text(
                            'No bookings available.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _availableBookings.length,
                          itemBuilder: (context, index) {
                            final booking = _availableBookings[index];
                            return _buildBookingCard(
                              booking.bookingName,
                              booking.bookingAddress,
                              DateFormat('dd MMM yyyy, hh:mm a')
                                  .format(booking.bookingDate),
                              booking.bookingType,
                              'RM ${booking.bookingId % 500 + 100}.00',
                              () => _acceptBooking(booking.bookingId),
                              () => _declineBooking(booking.bookingId),
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Stay on CleanerHomePage
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ActivityPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(
                  userController: widget.userController,
                  username: widget.username,
                  isCleaner: true, // Pass role context
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBookingCard(
    String title,
    String address,
    String date,
    String type,
    String price,
    VoidCallback onAccept,
    VoidCallback onDecline,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Type: $type',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('ACCEPT',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDecline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('DECLINE',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptBooking(int bookingId) async {
    // Logic to handle accepting a booking
  }

  Future<void> _declineBooking(int bookingId) async {
    // Logic to handle declining a booking
  }
}