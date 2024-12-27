import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LIst_Of_Passengers.dart';
import 'Urls.dart';

class DroppingPointSelectionPage extends StatefulWidget {
  const DroppingPointSelectionPage({Key? key}) : super(key: key);

  @override
  _DroppingPointSelectionPageState createState() =>
      _DroppingPointSelectionPageState();
}

class _DroppingPointSelectionPageState
    extends State<DroppingPointSelectionPage> {
  String? _droppingPoint;

  // Example booking details to be passed
  final Map<String, String> bookingDetails = {
    'busOperator': 'Example Operator',
    'busType': 'AC Sleeper',
    'origin': 'City A',
    'destination': 'City B',
    'departureTime': '10:00 AM',
    'arrivalTime': '6:00 PM',
    'seatNumber': 'A1',
    'passengerName': 'John Doe',
    'gender': 'Male',
    'age': '30',
    'boardingPoint': 'Main Terminal',
    'boardingTime': '9:30 AM',
    'droppingPoint': '',
    'droppingTime': '',
  };

  @override
  void initState() {
    super.initState();
    _fetchLastEnding(); // Fetch the last ending point when the page is initialized
  }

  // Fetch the last dropping point from the API
  Future<void> _fetchLastEnding() async {
    final response = await http.get(Uri.parse('${Url.Urls}/get/last_ending'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      setState(() {
        _droppingPoint = data['ending'];
      });
    } else {
      setState(() {
        _droppingPoint = 'No available records found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dropping Point Selection'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Dropping Point',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Check if dropping point is available or show loading
            _droppingPoint == null
                ? const Center(child: CircularProgressIndicator())
                : DroppingPointCard(
              name: _droppingPoint!,
              onSelect: () {
                // Navigate to PassengerListScreen (without passing any parameters)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PassengerListScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class DroppingPointCard extends StatelessWidget {
  final String name;
  final VoidCallback onSelect;

  const DroppingPointCard({
    Key? key,
    required this.name,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: onSelect,
                child: const Icon(
                  Icons.circle, // Dot symbol
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
