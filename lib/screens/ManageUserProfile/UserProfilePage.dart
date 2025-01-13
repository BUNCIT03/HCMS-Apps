import 'package:flutter/material.dart';
import 'EditPage.dart';

class UserProfilePage extends StatelessWidget {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String address;
  final String role;

  UserProfilePage({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MY ACCOUNT'),
        backgroundColor: role == 'House Owner' ? Colors.green : Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: role == 'House Owner' ? Colors.green : Colors.purple,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    fullName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPage(
                            fullName: fullName,
                            email: email,
                            phoneNumber: phoneNumber,
                            address: address,
                            postalCode: "21050", // Placeholder value
                            state: "Terengganu", // Placeholder value
                            role: role,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: role == 'House Owner' ? Colors.green : Colors.purple,
                    ),
                    child: Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            buildDetailField('Full Name', fullName),
            buildDetailField('Phone Number', phoneNumber),
            buildDetailField('Email', email),
            buildDetailField('Address', address),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: role == 'House Owner' ? Colors.green : Colors.purple,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                role,
                style: TextStyle(
                  color: role == 'House Owner' ? Colors.green : Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Highlight the "Profile" tab
        selectedItemColor: role == 'House Owner' ? Colors.green : Colors.purple,
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
          // Handle navigation
        },
      ),
    );
  }

  Widget buildDetailField(String label, String value) {
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
