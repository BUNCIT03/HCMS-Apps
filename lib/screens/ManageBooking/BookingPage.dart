import 'package:flutter/material.dart';
import 'package:hcms_application/controllers/BookingController.dart';
import 'package:hcms_application/domains/Booking.dart';
import 'UserHomePage.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final Bookingcontroller _bookingController = Bookingcontroller();
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  String _preferredCleanerOption = 'Random'; // Default selection
  String? _selectedCleaner;
  List<String> _registeredCleaners = [
    'Andi',
    'Maria',
    'John',
    'Nina'
  ]; // Example cleaners

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please fill out your booking data!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Booking Type: Basic Housekeeping',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // Place Name
            TextField(
              controller: _placeNameController,
              decoration: InputDecoration(
                labelText: 'Place Name *',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Address
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            // Scheduled Service Date
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
            // Preferred Cleaner Section
            Text(
              'Preferred Cleaner *',
              style: TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                // Random Cleaner Checkbox
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
                // Custom Cleaner Checkbox
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
            if (_preferredCleanerOption == 'Random') ...[
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'We provide the best cleaner to help you! Sit back, relax, and let our trusted professionals take care of your needs.',
                  style: TextStyle(color: Colors.green[800], fontSize: 14),
                ),
              ),
            ],
            if (_preferredCleanerOption == 'Custom') ...[
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
            ],
            SizedBox(height: 16),
            // Special Instructions
            TextField(
              controller: _specialInstructionsController,
              decoration: InputDecoration(
                labelText: 'Special Instructions',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24),
            // Booking Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () async {
                final booking = Booking(
                  placeName: _placeNameController.text,
                  address: _addressController.text,
                  scheduledDate: _dateController.text,
                  preferredCleanerOption: _preferredCleanerOption,
                  selectedCleaner: _selectedCleaner,
                  specialInstructions: _specialInstructionsController.text,
                );

                final success = await _bookingController.addBooking(booking);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking Successful!')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserHomePage(_bookingController)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to book. Please try again.')),
                  );
                }
              },
              child: Text(
                'Booking Now',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Highlight the "Book Now" tab
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
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
                  builder: (context) => UserHomePage(_bookingController)),
            );
          } else if (index == 1) {}
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BookingPage(),
    debugShowCheckedModeBanner: false,
  ));
}
