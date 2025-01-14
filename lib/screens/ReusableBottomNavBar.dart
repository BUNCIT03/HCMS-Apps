import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/screens/ManageBooking/BookingPage.dart';
import 'package:hcms_application/screens/ManageBooking/UserHomePage.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';

class ReusableBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final UserController userController;
  final Bookingcontroller bookingController;
  final String username;

  const ReusableBottomNavBar({
    required this.currentIndex,
    required this.userController,
    required this.bookingController,
    required this.username,
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserHomePage(
                bookingController,
                userController,
                username,
              ),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(
                userController: userController,
                username: username,
              ),
            ),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfilePage(
                userController: userController,
                username: username,
              ),
            ),
          );
        }
      },
    );
  }
}
