import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/domains/User.dart';
import 'package:hcms_application/screens/ManageBooking/EditBookingPage.dart';
import 'package:hcms_application/screens/ReusableBottomNavBar.dart';
import 'package:intl/intl.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';
import 'BookingPage.dart';

class UserHomePage extends StatefulWidget {
  final BookingController bookingController;
  final UserController userController;
  final String username;
  final User user;

  const UserHomePage(
      this.bookingController, this.userController, this.username, this.user);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedTab = 0; // 0: Ongoing, 1: Completed
  List<Booking> _ongoingBookings = [];
  List<Booking> _completedBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
    });
    final bookings =
        await widget.bookingController.getBookingsByUsername(widget.username);

    setState(() {
      _ongoingBookings =
          bookings.where((booking) => !booking.lateCancelation).toList();
      _completedBookings =
          bookings.where((booking) => booking.lateCancelation).toList();
      _isLoading = false;
    });
  }

  Future<void> _confirmCancellation(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Cancellation'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final success =
          await widget.bookingController.deleteBooking(booking.bookingId);
      if (success) {
        _fetchBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking canceled successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to cancel booking')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to HCMS'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hi, ${widget.username}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                // Notifications Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Your bookings for Taman Beruas have been declined by cleaner',
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: const Size(80, 40),
                                ),
                                onPressed: () {
                                  // Handle Edit Booking
                                },
                                child: const Text(
                                  'EDIT',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Booking Tabs (Ongoing/Completed)
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
                                color: _selectedTab == 0
                                    ? Colors.green
                                    : Colors.grey,
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
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => setState(() => _selectedTab = 1),
                        child: Column(
                          children: [
                            Text(
                              'COMPLETED',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 1
                                    ? Colors.green
                                    : Colors.grey,
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
                const SizedBox(height: 16),

                // Booking List Section Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'My Bookings',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                // Booking List
                Expanded(
                  child: _selectedTab == 0
                      ? _buildBookingList(_ongoingBookings, isOngoing: true)
                      : _buildBookingList(_completedBookings, isOngoing: false),
                ),
              ],
            ),
      bottomNavigationBar: ReusableBottomNavBar(
        currentIndex: 0, // Set the active tab index
        userController: widget.userController,
        bookingController: widget.bookingController,
        user: widget.user, // Pass the User object
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings, {required bool isOngoing}) {
    if (bookings.isEmpty) {
      return Center(
        child: Text(
          isOngoing ? 'No ongoing bookings' : 'No completed bookings',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(
          booking.bookingName,
          booking.bookingType,
          booking.bookingAddress,
          DateFormat('dd MMM yyyy, hh:mm a').format(booking.bookingDate),
          'RM ${booking.bookingId % 500 + 100}.00', // Example price logic
          isOngoing ? 'Edit' : 'Completed',
          isOngoing ? 'Cancel' : 'Rate',
          Colors.green,
          isOngoing ? Colors.red : Colors.yellow,
          isOngoing
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBookingPage(
                        booking: booking,
                        bookingController: widget.bookingController,
                        userController: widget.userController,
                        user: widget.user,
                      ),
                    ),
                  ).then((_) {
                    // Refresh bookings after editing
                    _fetchBookings();
                  });
                }
              : null,
          isOngoing
              ? () async {
                  await _confirmCancellation(booking);
                }
              : () {
                  // Handle Rate action
                },
        );
      },
    );
  }

  Widget _buildBookingCard(
    String title,
    String bookingType,
    String location,
    String date,
    String price,
    String leftButtonText,
    String rightButtonText,
    Color leftButtonColor,
    Color rightButtonColor,
    VoidCallback? leftButtonAction,
    VoidCallback? rightButtonAction,
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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              bookingType,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(location),
              ],
            ),
            const SizedBox(height: 8),
            Text(date),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: leftButtonColor,
                  ),
                  onPressed: leftButtonAction,
                  child: Text(
                    leftButtonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: rightButtonColor,
                  ),
                  onPressed: rightButtonAction,
                  child: Text(
                    rightButtonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
