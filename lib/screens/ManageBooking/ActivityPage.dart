import 'package:flutter/material.dart';
import 'Homepage.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 0),
                  child: Column(
                    children: [
                      Text(
                        'ONGOING',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _selectedTab == 0 ? Colors.purple : Colors.grey,
                        ),
                      ),
                      if (_selectedTab == 0)
                        Container(
                          height: 3,
                          width: 100,
                          color: Colors.purple,
                        )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: Column(
                    children: [
                      Text(
                        'COMPLETED',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              _selectedTab == 1 ? Colors.purple : Colors.grey,
                        ),
                      ),
                      if (_selectedTab == 1)
                        Container(
                          height: 3,
                          width: 100,
                          color: Colors.purple,
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child:
                _selectedTab == 0 ? _buildOngoingList() : _buildCompletedList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage()),
            // );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ActivityPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildOngoingList() {
    return ListView(
      children: [
        _buildActivityCard(
            'KAMPUNG BERUAS', 'RM156.00', 'PEKAN', '12 NOV 2024', true),
        _buildActivityCard(
            'TAMAN BERUAS LOT', 'RM200.00', 'PEKAN', '13 DIS 2024', true),
        _buildActivityCard(
            'PANTAI LAGENDA', 'RM354.00', 'PEKAN', '13 DIS 2024', true),
      ],
    );
  }

  Widget _buildCompletedList() {
    return ListView(
      children: [
        _buildActivityCard(
            'KAMPUNG BERUAS', 'RM156.00', 'PEKAN', '12 NOV 2024', false),
        _buildActivityCard(
            'TAMAN BERUAS LOT', 'RM200.00', 'PEKAN', '13 DIS 2024', false),
        _buildActivityCard(
            'PANTAI LAGENDA', 'RM354.00', 'PEKAN', '13 DIS 2024', false),
      ],
    );
  }

  Widget _buildActivityCard(String title, String price, String location,
      String date, bool isOngoing) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(location),
              ],
            ),
            SizedBox(height: 8),
            Text(date),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOngoing ? Colors.purple : Colors.grey,
                  ),
                  onPressed: isOngoing
                      ? () {
                          // Handle Complete action
                        }
                      : null,
                  child: Text(isOngoing ? 'Complete' : 'Completed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
