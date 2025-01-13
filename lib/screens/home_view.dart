// view/home_view.dart
import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/auth_controller.dart';

class HomeView extends StatelessWidget {
  final AuthController controller;

  HomeView(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await controller.logoutUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Center(child: Text('Welcome to the Home Page!')),
    );
  }
}
