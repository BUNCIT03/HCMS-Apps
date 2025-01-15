import 'package:flutter/material.dart';

class GenerateReportPage extends StatefulWidget {
  const GenerateReportPage({super.key});

  @override
  _GenerateReportPageState createState() => _GenerateReportPageState();
}

class _GenerateReportPageState extends State<GenerateReportPage> {
  final List<String> sections = [
    "Locations",
    "Cleaning Frequency",
    "Cleaning Supplies",
    "Areas to Focus On",
    "Special Instructions",
    "Staff Experience Level",
  ];

  final List<bool> selectedSections = List.generate(6, (index) => false);

  void toggleSection(int index) {
    setState(() {
      selectedSections[index] = !selectedSections[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generate Report"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => _buildFilterSheet(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Advanced Sections to Include",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: sections.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(sections[index]),
                    trailing: Checkbox(
                      value: selectedSections[index],
                      onChanged: (value) => toggleSection(index),
                      activeColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Generate Report logic
                // Placeholder: Print selected sections
                final selected = sections
                    .asMap()
                    .entries
                    .where((entry) => selectedSections[entry.key])
                    .map((entry) => entry.value)
                    .toList();
                print("Selected Sections: $selected");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Generate Report"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSheet() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filters",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: "Date Range",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: "Cleaner Availability",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: "Service Type",
              border: OutlineInputBorder(),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }
}
