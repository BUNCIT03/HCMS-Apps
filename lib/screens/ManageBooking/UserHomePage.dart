import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';
import 'BookingPage.dart';

class UserHomePage extends StatefulWidget {
  final BookingController bookingController;
  final UserController userController;
  final String username;

  const UserHomePage(
      this.bookingController, this.userController, this.username);

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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Hi, ${widget.username}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
                Expanded(
                  child: _selectedTab == 0
                      ? _buildBookingList(_ongoingBookings, isOngoing: true)
                      : _buildBookingList(_completedBookings, isOngoing: false),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Book Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BookingPage(
                  userId: 1, // Replace with actual userId
                  username: widget.username,
                  bookingController: widget.bookingController,
                  userController: widget.userController, // Pass the userController
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserProfilePage(
                  userController: widget.userController,
                  username: widget.username,
                ),
              ),
            );
          }
        },
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
          'RM150.00', // Example price, replace with actual logic
          booking.bookingAddress,
          booking.bookingDate.toString(),
          isOngoing ? 'Edit' : 'Completed',
          isOngoing ? 'Cancel' : 'Rate',
          Colors.green,
          isOngoing ? Colors.red : Colors.yellow,
          isOngoing
              ? () {
                  // Handle Edit action
                }
              : null,
          isOngoing
              ? () async {
                  // Handle Cancel action
                  final success = await widget.bookingController
                      .deleteBooking(booking.bookingId);
                  if (success) {
                    _fetchBookings();
                  }
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
    String price,
    String location,
    String date,
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: leftButtonColor,
                      ),
                      onPressed: leftButtonAction,
                      child: Text(leftButtonText),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: rightButtonColor,
                      ),
                      onPressed: rightButtonAction,
                      child: Text(rightButtonText),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
