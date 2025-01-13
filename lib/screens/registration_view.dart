// view/registration_view.dart
import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/auth_controller.dart';
import 'package:hcms_application/domains/user_model.dart';

class RegistrationView extends StatelessWidget {
  final AuthController controller;

  RegistrationView(this.controller);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final user = UserModel()
                  ..username = _usernameController.text
                  ..password = _passwordController.text;
                final success = await controller.registerUser(user);
                if (success) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed')),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
