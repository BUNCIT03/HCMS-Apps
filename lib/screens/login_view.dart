import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/ScheduleController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/domains/User.dart';
import 'package:hcms_application/screens/ManageBooking/HomePage.dart';
import 'package:hcms_application/screens/ManageCleanerSchedule/CleanerHomePage.dart';

class LoginView extends StatefulWidget {
  final UserController userController;

  const LoginView(this.userController, {Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final success = await widget.userController.loginUser(username, password);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        final User? user = await widget.userController.fetchUserByUsername(username);
        if (user != null) {
          // Navigate based on user role
          if (user.role == 'Cleaner') {
            Navigator.pushReplacement(
              context,
               MaterialPageRoute(
                builder: (context) => CleanerHomePage(
                  bookingController: BookingController(), // Create an instance of the ScheduleController
                  userController: widget.userController,
                  username: user.username,
                  cleanerId: user.userId, // Pass the cleaner's userId
                ),
              ),
            );
          } else if (user.role == 'House Owner') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomePage(
                  BookingController(),
                  widget.userController,
                  user.username,
                  user
                ),
              ),
            );
          } else {
            _showErrorDialog('Unknown user role. Please contact support.');
          }
        } else {
          _showErrorDialog('User details not found. Please try again.');
        }
      } else {
        _showErrorDialog('Invalid username or password. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _loginUser,
                      child: const Text('Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Don\'t have an account? Register here',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
