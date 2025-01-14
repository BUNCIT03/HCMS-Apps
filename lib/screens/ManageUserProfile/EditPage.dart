import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/User.dart';

class EditPage extends StatefulWidget {
  final String username; // To identify the user
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String postalCode;
  final String state;
  final String role;
  final UserController userController; // Controller to handle operations

  EditPage({
    required this.username,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.postalCode,
    required this.state,
    required this.role,
    required this.userController,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;
  late TextEditingController _stateController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _addressController = TextEditingController(text: widget.address);
    _postalCodeController = TextEditingController(text: widget.postalCode);
    _stateController = TextEditingController(text: widget.state);
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        userId: 0, // Ensure this matches your Firestore schema
        username: widget.username,
        password: "", // Password shouldn't change here
        email: _emailController.text.trim(),
        fullName: _fullNameController.text.trim(),
        phoneNum: _phoneNumberController.text.trim(),
        address: _addressController.text.trim(),
        state: _stateController.text.trim(),
        role: widget.role,
      );

      final success = await widget.userController.updateUser(widget.username, updatedUser);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context); // Navigate back after saving
      } else {
        _showErrorDialog('Failed to update profile. Please try again.');
      }
    }
  }

  Future<void> _deleteProfile() async {
    final confirmed = await _showDeleteConfirmationDialog(context);

    if (confirmed) {
      final success = await widget.userController.deleteUser(widget.username);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile deleted successfully!')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login after deletion
      } else {
        _showErrorDialog('Failed to delete profile. Please try again.');
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Profile'),
        content: Text('Are you sure you want to delete your profile? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ??
        false;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: widget.role == 'House Owner' ? Colors.green : Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: widget.role == 'House Owner' ? Colors.green : Colors.purple,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              buildEditableField('Full Name', _fullNameController),
              buildEditableField('Email', _emailController),
              buildEditableField('Phone Number', _phoneNumberController),
              buildEditableField('Address', _addressController),
              Row(
                children: [
                  Expanded(child: buildEditableField('Postal Code', _postalCodeController)),
                  SizedBox(width: 16),
                  Expanded(child: buildEditableField('State', _stateController)),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveProfile,
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
                      onPressed: _deleteProfile,
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
      ),
    );
  }

  Widget buildEditableField(String label, TextEditingController controller) {
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
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your new $label',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
