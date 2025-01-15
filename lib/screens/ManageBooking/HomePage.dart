import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/domains/User.dart';

class UserHomePage extends StatefulWidget {
  final BookingController bookingController;
  final UserController userController;
  final User user; // Pass User instead of just username

  UserHomePage({
    required this.bookingController,
    required this.userController,
    required this.user,
  });

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedTab = 0; // 0: Ongoing, 1: Completed
  List<Booking> _ongoingBookings = [];
  List<Booking> _completedBookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    final bookings =
        await widget.bookingController.getBookingsByUsername(widget.user.username);

    setState(() {
      _ongoingBookings =
          bookings.where((booking) => !booking.lateCancelation).toList();
      _completedBookings =
          bookings.where((booking) => booking.lateCancelation).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to HCMS'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hi, ${widget.user.username}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 0),
                  child: Column(
                    children: [
                      Text(
                        'ONGOING',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 0 ? Colors.green : Colors.grey,
                        ),
                      ),
                      if (_selectedTab == 0)
                        Container(
                          height: 3,
                          width: 100,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: Column(
                    children: [
                      Text(
                        'COMPLETED',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _selectedTab == 1 ? Colors.green : Colors.grey,
                        ),
                      ),
                      if (_selectedTab == 1)
                        Container(
                          height: 3,
                          width: 100,
                          color: Colors.green,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: _selectedTab == 0
                ? _buildBookingList(_ongoingBookings)
                : _buildBookingList(_completedBookings),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return Center(
        child: Text('No bookings available'),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return ListTile(
          title: Text(booking.bookingName),
          subtitle: Text(booking.bookingAddress),
          trailing: Text(booking.bookingDate.toIso8601String()),
        );
      },
    );
  }
}
