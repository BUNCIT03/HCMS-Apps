import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/screens/ManageBooking/EditBookingPage.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';
import 'BookingPage.dart';

class UserHomePage extends StatefulWidget {
  final Bookingcontroller bookingController;
  final UserController userController;
  final String username;

  UserHomePage(this.bookingController, this.userController, this.username);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedTab = 0; // 0: Ongoing, 1: Completed

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
              'Hi, ${widget.username}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Your booking for Taman Beruas has been declined by cleaner.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    // Navigate to EditBookingPage with example data
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBookingPage(
                          bookingController: widget.bookingController,
                          userController: widget.userController,
                          bookingId: '1',
                          username: widget.username,
                          bookingType: 'Basic Housekeeping',
                          placeName: 'Taman Beruas',
                          address: '123 Street, City',
                          scheduledDate: '12/12/2024',
                          preferredCleanerOption: 'Random',
                          specialInstructions:
                              'Please use eco-friendly products.',
                          selectedCleaner: null,
                        ),
                      ),
                    );
                  },
                  child: Text('EDIT'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            child:
                _selectedTab == 0 ? _buildOngoingList() : _buildCompletedList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
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
                  userController: widget.userController,
                  username: widget.username,
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

  Widget _buildOngoingList() {
    // Example data
    return ListView(
      children: [
        _buildBookingCard(
          'Kampung Beruas',
          'RM156.00',
          'Pekan',
          '12 Nov 2024',
          'Edit',
          'Delete',
          Colors.green,
          Colors.red,
          () {
            // Edit action
          },
          () {
            // Delete action
          },
        ),
      ],
    );
  }

  Widget _buildCompletedList() {
    // Example data
    return ListView(
      children: [
        _buildBookingCard(
          'UMP Pekan',
          'RM2300.00',
          'Pekan',
          '16 Nov 2024',
          'Completed',
          'Rate',
          Colors.green,
          Colors.yellow,
          null,
          () {
            // Rate action
          },
        ),
      ],
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(location),
              ],
            ),
            SizedBox(height: 8),
            Text(date),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    SizedBox(width: 8),
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
