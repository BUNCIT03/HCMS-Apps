import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/User.dart';
import 'package:hcms_application/screens/ReusableBottomNavBar.dart';
import 'EditPage.dart';

class UserProfilePage extends StatefulWidget {
  final UserController userController;
  final String username;

  UserProfilePage({
    required this.userController,
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserDetails();
  }

  Future<User> _fetchUserDetails() async {
    final user =
        await widget.userController.fetchUserByUsername(widget.username);
    if (user != null) {
      return user;
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('MY ACCOUNT'),
              backgroundColor: Colors.green,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('MY ACCOUNT'),
              backgroundColor: Colors.green,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('MY ACCOUNT'),
              backgroundColor: Colors.green,
            ),
            body: _buildUserProfile(context, user),
            bottomNavigationBar: ReusableBottomNavBar(
              currentIndex: 2, // Highlight the "Profile" tab
              userController: widget.userController,
              bookingController: BookingController(),
              user: user, // Pass the User object
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('MY ACCOUNT'),
              backgroundColor: Colors.green,
            ),
            body: Center(child: Text('No user data found.')),
          );
        }
      },
    );
  }

  Widget _buildUserProfile(BuildContext context, User user) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      user.role == 'House Owner' ? Colors.green : Colors.purple,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user.fullName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          username: widget.username, // Pass the username dynamically
                          fullName: user.fullName,
                          email: user.email,
                          phoneNumber: user.phoneNum,
                          address: user.address,
                          postalCode: "12345", // Update dynamically if needed
                          state: user.state,
                          role: user.role,
                          userController: widget.userController, // Pass the UserController
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user.role == 'House Owner'
                        ? Colors.green
                        : Colors.purple,
                  ),
                  child: Text('Edit', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          buildDetailField('Full Name', user.fullName, user.role),
          buildDetailField('Phone Number', user.phoneNum, user.role),
          buildDetailField('Email', user.email, user.role),
          buildDetailField('Address', user.address, user.role),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color:
                    user.role == 'House Owner' ? Colors.green : Colors.purple,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              user.role,
              style: TextStyle(
                color:
                    user.role == 'House Owner' ? Colors.green : Colors.purple,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailField(String label, String value, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: role == 'House Owner' ? Colors.green : Colors.purple,
              ),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
