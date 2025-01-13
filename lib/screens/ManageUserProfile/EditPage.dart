import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String postalCode;
  final String state;
  final String role;

  EditPage({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.postalCode,
    required this.state,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: role == 'House Owner' ? Colors.green : Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 16),
            buildEditableField('Full Name', fullName),
            buildEditableField('Password', ''),
            buildEditableField('Email', email),
            buildEditableField('Phone Number', phoneNumber),
            buildEditableField('Address', address),
            Row(
              children: [
                Expanded(child: buildEditableField('Postal Code', postalCode)),
                SizedBox(width: 16),
                Expanded(child: buildEditableField('State', state)),
              ],
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save profile logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      'Delete Profile',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditableField(String label, String value) {
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
          TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your new $label',
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to delete your profile?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Perform delete logic
            },
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
