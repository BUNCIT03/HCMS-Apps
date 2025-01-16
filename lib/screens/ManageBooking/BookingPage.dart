import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/screens/ManageBooking/UserHomePage.dart';
import 'package:hcms_application/controllers/UserController.dart';
import 'package:hcms_application/domains/Booking.dart';

class BookingPage extends StatefulWidget {
  final int userId;
  final String username;
  final BookingController bookingController;
  final UserController userController;

  const BookingPage({
    required this.userId,
    required this.username,
    required this.bookingController,
    required this.userController,
    super.key,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCleaner;
  final String _preferredCleanerOption = 'Random';
  String? _selectedCleaningType;

  final List<String> _cleaningTypes = [
    'Basic Housekeeping',
    'Premium Ironing',
    'Spring Cleaning',
    'Move In/Out Cleaning',
  ];

  // add price of cleaning types
  final Map<String, double> _servicePrices = {
    'Basic Housekeeping': 50.0,
    'Premium Ironing': 70.0,
    'Spring Cleaning': 100.0,
    'Move In/Out Cleaning': 150.0,
  };

  final List<String> _registeredCleaners = [
    'Cleaner A',
    'Cleaner B',
    'Cleaner C'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCleaningType == null
            ? 'Choose Cleaning Service'
            : 'Booking'),
        backgroundColor: Colors.green,
      ),
      body: _selectedCleaningType == null
          ? _buildServiceSelectionPage()
          : _buildBookingForm(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Book Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
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
          } else if (index == 2) {
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
          }
        },
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
                _selectedCleaningType = type;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cleaning_services, size: 40, color: Colors.green),
                  SizedBox(height: 8),
                  Text(
                    type,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
    // State price after user choose bookingType
    final double? price = _selectedCleaningType != null
        ? _servicePrices[_selectedCleaningType!]
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown for cleaning type
          DropdownButton<String>(
            value: _selectedCleaningType,
            hint: Text('Select Cleaning Type'),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCleaningType = newValue;
              });
            },
            // add price
            items: _servicePrices.keys.map((String key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(key),
              );
            }).toList(),
          ),

          // Display the price only if price is selected
          if (price != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Price: \$${price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),

          const SizedBox(height: 16),
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
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Preferred Cleaner',
              border: OutlineInputBorder(),
            ),
            items: _registeredCleaners.map((cleaner) {
              return DropdownMenuItem(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text('Book Now'),
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
      bookingCleaner: null,
      bookingInstruction: _instructionController.text,
      lateCancelation: false,
      createdDate: DateTime.now(),
      scheduleId: 1,
      userId: widget.userId,
      username: widget.username,
      price: _servicePrices[_selectedCleaningType!] ?? 0.0,
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
