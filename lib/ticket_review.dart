import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Urls.dart';
import 'payment.dart';  // Make sure to import the PaymentPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TicketReviewScreen(),
    );
  }
}

class TicketReviewScreen extends StatefulWidget {
  const TicketReviewScreen({Key? key}) : super(key: key);

  @override
  _TicketReviewScreenState createState() => _TicketReviewScreenState();
}

class _TicketReviewScreenState extends State<TicketReviewScreen> {
  // Booking details that will be updated after fetching from the API
  Map<String, dynamic> bookingDetails = {
    'busOperator': 'Example Operator',
    'busType': 'AC Sleeper',
    'origin': 'City A',
    'destination': 'City B',
    'departureTime': '10:00 AM',
    'arrivalTime': '6:00 PM',
    'seatNumber': 'A2',
    'passengerName': 'Komal',
    'gender': 'Male',
    'age': 20,
    'boardingPoint': 'Main Terminal',
    'boardingTime': '9:30 AM',
    'droppingPoint': 'Bus Stand',
    'droppingTime': '6:30 PM',
  };

  // Fetch the last available record from the API
  Future<void> _fetchBookingDetails() async {
    final response = await http.get(Uri.parse('${Url.Urls}/api/available/last'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        bookingDetails = {
          'busOperator': 'Example Operator', // Add appropriate values from the response
          'busType': 'AC Sleeper',           // Replace with any appropriate data
          'origin': data['start'],
          'destination': data['end'],
          'departureTime': '10:00 AM',  // You might want to fetch this too if it's available
          'arrivalTime': '6:00 PM',     // Update accordingly
          'seatNumber': 'A2',
          'passengerName': 'Komal',
          'gender': 'Male',
          'age': 20,
          'boardingPoint': data['boarding'],
          'boardingTime': '9:30 AM',  // Or fetch from response if available
          'droppingPoint': data['ending'],
          'droppingTime': '6:30 PM',  // Update accordingly
        };
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();  // Fetch the data when the screen is initialized
  }

  Widget _buildLocationInfo(String location, String time) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blue),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildPointInfo(String title, String point, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Text(point, style: const TextStyle(color: Colors.black)),
            const SizedBox(width: 16),
            Text(time, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${bookingDetails['busOperator']} (${bookingDetails['busType']})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLocationInfo(
              bookingDetails['origin'],
              bookingDetails['departureTime'],
            ),
            const SizedBox(height: 8),
            _buildLocationInfo(
              bookingDetails['destination'],
              bookingDetails['arrivalTime'],
            ),
            const SizedBox(height: 16),
            Text(
              'Seat Number: ${bookingDetails['seatNumber']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Passenger: ${bookingDetails['passengerName']} (${bookingDetails['gender']}, ${bookingDetails['age']} years)',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildPointInfo(
              'Boarding Point:',
              bookingDetails['boardingPoint'],
              bookingDetails['boardingTime'],
            ),
            const SizedBox(height: 16),
            _buildPointInfo(
              'Dropping Point:',
              bookingDetails['droppingPoint'],
              bookingDetails['droppingTime'],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentPage(),
                    ),
                  );
                },
                child: const Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
