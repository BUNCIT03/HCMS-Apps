import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/User.dart';
import 'package:hcms_application/screens/ManageBooking/BookingPage.dart';
import 'package:hcms_application/screens/ManageBooking/UserHomePage.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';

class ReusableBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final UserController userController;
  final BookingController bookingController;
  final User user; // Pass the User object to get userId and username

  const ReusableBottomNavBar({
    required this.currentIndex,
    required this.userController,
    required this.bookingController,
    required this.user, // Use the User object
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
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
        if (index == currentIndex) return; // Prevent reloading the current page

        if (index == 0) {
          // Navigate to UserHomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomePage(
                bookingController,
                userController,
                user.username, // Pass the username from User object
              ),
            ),
          );
        } else if (index == 1) {
          // Navigate to BookingPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(
                userId: user.userId, // Use the actual user ID from User object
                username: user.username, // Pass username from User object
                bookingController: bookingController,
                userController: userController, // Pass the userController
              ),
            ),
          );
        } else if (index == 2) {
          // Navigate to UserProfilePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                userController: userController,
                username: user.username, // Pass the username
              ),
            ),
          );
        }
      },
    );
  }
}
