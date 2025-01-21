import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Urls.dart';
import 'payment.dart';  // Import the PaymentPage

class TicketReviewScreen extends StatefulWidget {
  final String passengerName;
  final int passengerAge;
  final String passengerGender;

  const TicketReviewScreen({
    Key? key,
    required this.passengerName,
    required this.passengerAge,
    required this.passengerGender,
  }) : super(key: key);

  @override
  _TicketReviewScreenState createState() => _TicketReviewScreenState();
}

class _TicketReviewScreenState extends State<TicketReviewScreen> {
  Map<String, dynamic> bookingDetails = {
    'busOperator': 'Example Operator',
    'busType': 'AC Sleeper',
    'origin': 'City A',
    'destination': 'City B',
    'departureTime': '10:00 AM',
    'arrivalTime': '6:00 PM',
    'seatNumber': 'A2',
    'boardingPoint': 'Main Terminal',
    'boardingTime': '9:30 AM',
    'droppingPoint': 'Bus Stand',
    'droppingTime': '6:30 PM',
  };

  Future<void> _fetchBookingDetails() async {
    final response = await http.get(Uri.parse('${Url.Urls}/api/available/last'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final seatResponse = await http.get(Uri.parse('${Url.Urls}/seats_fetch'));

      if (seatResponse.statusCode == 200) {
        final seatData = json.decode(seatResponse.body);
        final seatNumber = seatData['seats'];

        setState(() {
          bookingDetails = {
            'busOperator': 'Example Operator',
            'busType': 'AC Sleeper',
            'origin': data['start'],
            'destination': data['end'],
            'departureTime': '6:00 AM',
            'arrivalTime': '6:00 PM',
            'seatNumber': seatNumber.toString(),
            'boardingPoint': data['boarding'],
            'boardingTime': '6:00 AM',
            'droppingPoint': data['ending'],
            'droppingTime': '6:00 PM',
          };
        });
      } else {
        throw Exception('Failed to fetch seat details');
      }
    } else {
      throw Exception('Failed to load booking details');
    }
  }

  Future<void> _fetchTravelTime() async {
    final String start = bookingDetails['origin'];
    final String end = bookingDetails['destination'];

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/get/travel_time'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'start': start, 'end': end}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final travelTime = data['travel_time'];
        final endingTime = data['ending_time'];

        setState(() {
          bookingDetails['departureTime'] = travelTime;
          bookingDetails['arrivalTime'] = endingTime;
          bookingDetails['boardingTime'] = travelTime;
          bookingDetails['droppingTime'] = endingTime;
        });
      } else {
        print('Error fetching travel time: ${response.body}');
      }
    } catch (e) {
      print('Error fetching travel time: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails().then((_) {
      _fetchTravelTime();
    });
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
              'Passenger: ${widget.passengerName} (${widget.passengerGender}, ${widget.passengerAge} years)',
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
                      builder: (context) => PaymentPage(
                        passengerName: widget.passengerName,
                        passengerGender: widget.passengerGender,
                        passengerAge: widget.passengerAge,
                      ),
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
