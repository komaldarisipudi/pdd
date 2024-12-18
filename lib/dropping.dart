import 'package:flutter/material.dart';
import 'ticket_review.dart';

class DroppingPointSelectionPage extends StatelessWidget {
  const DroppingPointSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example booking details to be passed
    final bookingDetails = {
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
      'droppingPoint': '',
      'droppingTime': '',
    };

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
            DroppingPointCard(
              name: 'Rama Talkies, Opp Ambedkar Bhavan',
              arrivalTime: '6:30 PM',
              onSelect: () {
                // Update dropping point details dynamically
                bookingDetails['droppingPoint'] = 'Rama Talkies, Opp Ambedkar Bhavan';
                bookingDetails['droppingTime'] = '6:30 PM';

                // Navigate to Ticket Review Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketReviewScreen(bookingDetails: bookingDetails),
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
  final String arrivalTime;
  final VoidCallback onSelect;

  const DroppingPointCard({
    Key? key,
    required this.name,
    required this.arrivalTime,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Arrival Time: $arrivalTime',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
