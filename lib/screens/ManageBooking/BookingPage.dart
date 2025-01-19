import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'package:hcms_application/domains/User.dart';
import 'package:hcms_application/screens/ManageBooking/HomePage.dart';
import 'package:hcms_application/screens/ManageUserProfile/UserProfilePage.dart';
import 'package:hcms_application/screens/ReusableBottomNavBar.dart';

class BookingPage extends StatefulWidget {
  final int userId;
  final String username;
  final BookingController bookingController;
  final UserController userController;
  final User user;

  const BookingPage({
    required this.userId,
    required this.username,
    required this.bookingController,
    required this.userController,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedCleaner; // Store cleaner userId
  String? _selectedCleaningType;

  final List<Map<String, dynamic>> _cleaningTypes = [
    {'name': 'Basic Housekeeping', 'icon': Icons.home, 'color': Colors.blue},
    {'name': 'Premium Ironing', 'icon': Icons.iron, 'color': Colors.orange},
    {'name': 'Spring Cleaning', 'icon': Icons.eco, 'color': Colors.green},
    {'name': 'Move In/Out Cleaning', 'icon': Icons.move_to_inbox, 'color': Colors.purple},
  ];

  List<User> _registeredCleaners = [];

  @override
  void initState() {
    super.initState();
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
        title: Text(_selectedCleaningType == null ? 'Choose Cleaning Service' : 'Booking'),
        backgroundColor: Colors.green,
      ),
      body: _selectedCleaningType == null ? _buildServiceSelectionPage() : _buildBookingForm(),
      bottomNavigationBar: ReusableBottomNavBar(
        currentIndex: 0, // Set the active tab index
        userController: widget.userController,
        bookingController: widget.bookingController,
        user: widget.user, 
      ),
    );
  }

  Widget _buildServiceSelectionPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: _cleaningTypes.map((type) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCleaningType = type['name'];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: type['color'],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(type['icon'], size: 40, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    type['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBookingForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Type: $_selectedCleaningType',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _placeNameController,
            decoration: InputDecoration(
              labelText: 'Place Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
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
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
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
            trailing: Icon(Icons.access_time),
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              setState(() {
                _selectedTime = pickedTime;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
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
            hint: Text('Choose a cleaner'),
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
            onPressed: _createBooking,
            child: Text('Book Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createBooking() async {
    if (_placeNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final booking = Booking(
      bookingId: DateTime.now().millisecondsSinceEpoch,
      bookingType: _selectedCleaningType!,
      bookingName: _placeNameController.text,
      bookingAddress: _addressController.text,
      bookingDate: _selectedDate!,
      bookingTime: _selectedTime!.format(context),
      bookingCleaner: _selectedCleaner,
      bookingInstruction: _instructionController.text,
      lateCancelation: false,
      createdDate: DateTime.now(),
      scheduleId: 1,
      userId: widget.userId,
      username: widget.username,
    );

    final success = await widget.bookingController.addBooking(booking);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successfully created!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserHomePage(
            widget.bookingController,
            widget.userController,
            widget.username,
            widget.user,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking')),
      );
    }
  }
}
