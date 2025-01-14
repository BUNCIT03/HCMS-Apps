import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/screens/ManageBooking/ActivityPage.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';

class HomePage extends StatefulWidget {
  final Bookingcontroller bookingController;
  final UserController userController;
  final String username;

  HomePage(this.bookingController, this.userController, this.username);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to HCMS'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: false,
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
          // Notifications Section
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Available Booking Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Available Booking',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildBookingCard(
                    'KAMPUNG BERUAS', 'RM156.00', 'PEKAN', '12 NOV 2024'),
                _buildBookingCard(
                    'TAMAN BERUAS LOT', 'RM200.00', 'PEKAN', '13 DIS 2024'),
                _buildBookingCard(
                    'PANTAI LAGENDA', 'RM354.00', 'PEKAN', '13 DIS 2024'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
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
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage(
            //     userController: widget.userController,
            //       username: widget.username)),
            // );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ActivityPage()),
            );
          }else{
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

  Widget _buildBookingCard(
      String title, String price, String location, String date) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      onPressed: () {
                        // Handle Accept action
                      },
                      child: Text('ACCEPT'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        // Handle Decline action
                      },
                      child: Text('DECLINE'),
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

// void main() {
//   runApp(MaterialApp(
//     home: HomePage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
