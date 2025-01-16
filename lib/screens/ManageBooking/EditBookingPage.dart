import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';

class EditBookingPage extends StatefulWidget {
  final BookingController bookingController;
  final int bookingId;
  final String username;
  final String bookingType;
  final String bookingName;
  final String address;
  final DateTime scheduledDate;
  final String bookingTime;
  final int duration; // New attribute for duration
  final String specialInstructions;

  const EditBookingPage({
    required this.bookingController,
    required this.bookingId,
    required this.username,
    required this.bookingType,
    required this.bookingName,
    required this.address,
    required this.scheduledDate,
    required this.bookingTime,
    required this.duration,
    required this.specialInstructions,
    super.key,
  });

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _instructionController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedBookingType;
  int? _selectedDuration;
  final List<String> _bookingTypes = ['Standard', 'Deep Clean'];
  final List<int> _durations = List.generate(11, (index) => index + 2); // 2 to 12 hours

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bookingName);
    _addressController = TextEditingController(text: widget.address);
    _instructionController = TextEditingController(text: widget.specialInstructions);
    _selectedDate = widget.scheduledDate;
    _selectedTime = _parseTime(widget.bookingTime);
    _selectedBookingType = widget.bookingType;
    _selectedDuration = widget.duration;
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Booking Type',
                border: OutlineInputBorder(),
              ),
              items: _bookingTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBookingType = value;
                });
              },
              value: _selectedBookingType,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Booking Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
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
              decoration: InputDecoration(
                labelText: 'Duration (Hours)',
                border: OutlineInputBorder(),
              ),
              items: _durations.map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text('$duration hours'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
              value: _selectedDuration,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionController,
              decoration: InputDecoration(
                labelText: 'Special Instructions',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _updateBooking,
              child: const Text('Update Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBooking() async {
    // Validate input fields
    if (_selectedBookingType == null ||
        _nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null ||
        _selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // Update booking details
    final success = await widget.bookingController.updateBooking(
      widget.bookingId,
      widget.username,
      _selectedBookingType!,
      _nameController.text,
      _addressController.text,
      '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
      _selectedTime!.format(context),
      null, // No cleaner selected
      _instructionController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking updated successfully!')),
      );
      Navigator.pop(context); // Navigate back after successful update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update booking')),
      );
    }
  }
}
