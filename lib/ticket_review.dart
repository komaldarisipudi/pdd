import 'package:bus/payment.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TicketReviewScreen(
        bookingDetails: {
          'busOperator': 'Example Operator',
          'busType': 'AC Sleeper',
          'origin': 'City A',
          'destination': 'City B',
          'departureTime': '10:00 AM',
          'arrivalTime': '6:00 PM',
          'seatNumber': 'A1',
          'passengerName': 'John Doe',
          'gender': 'Male',
          'age': 30,
          'boardingPoint': 'Main Terminal',
          'boardingTime': '9:30 AM',
          'droppingPoint': 'Bus Stand',
          'droppingTime': '6:30 PM',
        },
      ),
    );
  }
}

class TicketReviewScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  const TicketReviewScreen({Key? key, required this.bookingDetails}) : super(key: key);

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

