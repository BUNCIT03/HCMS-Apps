import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/domains/User.dart';
import 'package:hcms_application/screens/ManageBooking/HomePage.dart';

class EditBookingPage extends StatefulWidget {
  final Booking booking;
  final BookingController bookingController;
  final UserController userController;
  final User user;

  const EditBookingPage({
    required this.booking,
    required this.bookingController,
    required this.userController,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _placeNameController;
  late TextEditingController _addressController;
  late TextEditingController _instructionController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedCleaner;
  String? _selectedCleaningType;

  final _cleaningTypes = [
    'Basic Housekeeping',
    'Premium Ironing',
    'Spring Cleaning',
    'Move In/Out Cleaning',
  ];

  List<User> _registeredCleaners = [];

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController(text: widget.booking.bookingName);
    _addressController = TextEditingController(text: widget.booking.bookingAddress);
    _instructionController = TextEditingController(text: widget.booking.bookingInstruction ?? '');
    _selectedDate = widget.booking.bookingDate;
    try {
      final timeParts = widget.booking.bookingTime.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
    } catch (e) {
      _selectedTime = TimeOfDay.now();
    }
    _selectedCleaningType = widget.booking.bookingType;
    _selectedCleaner = widget.booking.bookingCleaner;
    _fetchCleaners();
  }

  Future<void> _fetchCleaners() async {
    final users = await widget.userController.fetchAllUsers();
    setState(() {
      _registeredCleaners = users.where((user) => user.role == 'Cleaner').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Booking'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Booking Type',
                border: OutlineInputBorder(),
              ),
              items: _cleaningTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCleaningType = value;
                });
              },
              value: _selectedCleaningType,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _placeNameController,
              decoration: const InputDecoration(
                labelText: 'Place Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Select Booking Date'
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                setState(() {
                  _selectedDate = pickedDate;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedTime == null
                    ? 'Select Booking Time'
                    : _selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime ?? TimeOfDay.now(),
                );
                setState(() {
                  _selectedTime = pickedTime;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Preferred Cleaner',
                border: OutlineInputBorder(),
              ),
              items: _registeredCleaners.map((cleaner) {
                return DropdownMenuItem<int>(
                  value: cleaner.userId,
                  child: Text(cleaner.fullName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCleaner = value;
                });
              },
              value: _selectedCleaner,
              hint: const Text('Choose a cleaner'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionController,
              decoration: const InputDecoration(
                labelText: 'Special Instructions',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _updateBooking,
              child: const Text('Update Booking'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateBooking() async {
    if (_placeNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final success = await widget.bookingController.updateBooking(
      widget.booking.bookingId,
      widget.booking.username,
      _selectedCleaningType!,
      _placeNameController.text,
      _addressController.text,
      '${_selectedDate!.toIso8601String()}',
      _selectedTime!.format(context),
      _selectedCleaner,
      _instructionController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking updated successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserHomePage(
            widget.bookingController,
            widget.userController,
            widget.booking.username,
            widget.user
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update booking')),
      );
    }
  }
}
