import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'HomePage.dart';

class EditBookingPage extends StatefulWidget {
  final Bookingcontroller bookingController;
  final UserController userController;
  final String bookingId; // Add bookingId to identify the booking
  final String username;
  final String bookingType; // Existing booking type
  final String placeName; // Existing booking details
  final String address;
  final String scheduledDate;
  final String preferredCleanerOption;
  final String? selectedCleaner;
  final String specialInstructions;

  const EditBookingPage({
    required this.bookingController,
    required this.userController,
    required this.bookingId,
    required this.username,
    required this.bookingType,
    required this.placeName,
    required this.address,
    required this.scheduledDate,
    required this.preferredCleanerOption,
    this.selectedCleaner,
    required this.specialInstructions,
    Key? key,
  }) : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _placeNameController;
  late TextEditingController _addressController;
  late TextEditingController _dateController;
  late TextEditingController _specialInstructionsController;

  String? _selectedBookingType; // Dropdown selection for booking type
  String _preferredCleanerOption = 'Random'; // Default
  String? _selectedCleaner;
  List<String> _cleaningOptions = [
    'Basic Housekeeping',
    'Premium Ironing',
    'Spring Cleaning',
    'Move in/out Cleaning',
  ]; // Booking types
  List<String> _registeredCleaners = [
    'Andi',
    'Maria',
    'John',
    'Nina'
  ]; // Example cleaners

  @override
  void initState() {
    super.initState();
    _placeNameController = TextEditingController(text: widget.placeName);
    _addressController = TextEditingController(text: widget.address);
    _dateController = TextEditingController(text: widget.scheduledDate);
    _specialInstructionsController =
        TextEditingController(text: widget.specialInstructions);
    _selectedBookingType = widget.bookingType;
    _preferredCleanerOption = widget.preferredCleanerOption;
    _selectedCleaner = widget.selectedCleaner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserHomePage(
                  widget.bookingController,
                  widget.userController,
                  widget.username,
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit your booking details below:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Booking Type *',
                border: OutlineInputBorder(),
              ),
              value: _selectedBookingType,
              items: _cleaningOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBookingType = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _placeNameController,
              decoration: InputDecoration(
                labelText: 'Place Name *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Scheduled Service Date *',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _dateController.text =
                      '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Preferred Cleaner *',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Random'),
                    value: 'Random',
                    groupValue: _preferredCleanerOption,
                    onChanged: (value) {
                      setState(() {
                        _preferredCleanerOption = value!;
                        _selectedCleaner = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Custom'),
                    value: 'Custom',
                    groupValue: _preferredCleanerOption,
                    onChanged: (value) {
                      setState(() {
                        _preferredCleanerOption = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_preferredCleanerOption == 'Custom')
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Cleaner',
                  border: OutlineInputBorder(),
                ),
                items: _registeredCleaners.map((cleaner) {
                  return DropdownMenuItem<String>(
                    value: cleaner,
                    child: Text(cleaner),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCleaner = value;
                  });
                },
                value: _selectedCleaner,
                isExpanded: true,
                hint: Text('Choose a cleaner'),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _specialInstructionsController,
              decoration: InputDecoration(
                labelText: 'Special Instructions',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Changes'),
          content: Text('Are you sure you want to save these changes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                final success = await widget.bookingController.updateBooking(
                  widget.bookingId, // Pass bookingId
                  widget.username,
                  _selectedBookingType!,
                  _placeNameController.text,
                  _addressController.text,
                  _dateController.text,
                  _preferredCleanerOption,
                  _selectedCleaner,
                  _specialInstructionsController.text,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Booking details updated successfully!')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserHomePage(
                        widget.bookingController,
                        widget.userController,
                        widget.username,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Failed to update booking. Please try again.')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
