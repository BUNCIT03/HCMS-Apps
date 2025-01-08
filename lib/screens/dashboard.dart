import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/FirestoreService.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController addField = TextEditingController();

  void openModel() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: addField,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    firestoreService.store(addField.text);

                    Navigator.pop(context);
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('Dashboard'),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: openModel, child: Icon(Icons.add)),
    );
  }
}
