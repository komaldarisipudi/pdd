import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Urls.dart';
import 'Waitinglist.dart';

class Waitinggg extends StatefulWidget {
  final String from;
  final String to;
  final String date;

  const Waitinggg({
    Key? key,
    required this.from,
    required this.to,
    required this.date,
  }) : super(key: key);

  @override
  _WaitingggState createState() => _WaitingggState();
}

class _WaitingggState extends State<Waitinggg> {
  int _seats = 1; // Initial seat selection
  final int _totalSeats = 15; // Total available seats

  void _increaseSeats() {
    if (_seats < _totalSeats) {
      setState(() {
        _seats++;
      });
    }
  }

  void _decreaseSeats() {
    if (_seats > 1) {
      setState(() {
        _seats--;
      });
    }
  }

  void _addToWaitingList() async {
    // Prepare the data to send in the request
    Map<String, String> data = {
      'from': widget.from,
      'to': widget.to,
      'date': widget.date,
      'seats': '$_seats',
      'probability': '${(_seats / _totalSeats) * 100}%', // Send the calculated probability
      'availability': (_seats == _totalSeats) ? 'Yes' : 'No', // Bus availability based on seats selected
    };

    // Define the URL for your Flask backend
    String url = '${Url.Urls}/add_to_waiting_list'; // Replace with your server URL

    try {
      // Send the POST request to the Flask backend
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json', // Set content type to JSON
        },
        body: json.encode(data), // Send the data as a JSON object
      );

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to Waiting List')),
        );

        // Navigate to WaitingListScreen after success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WaitingListScreen()), // Replace with your WaitingListScreen
        );
      } else {
        // Handle error response from Flask
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to Waiting List')),
        );
      }
    } catch (e) {
      // Handle any errors that occur during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // Calculate percentage of seats selected
    double percentage = (_seats / _totalSeats) * 100;

    // Determine bus availability based on the percentage of seats selected
    String busAvailability = percentage == 100 ? 'Yes' : 'No';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waiting List'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'From: ${widget.from}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'To: ${widget.to}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${widget.date}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Seats:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decreaseSeats,
                  color: Colors.red,
                ),
                Text(
                  '$_seats',
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _increaseSeats,
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Display the probability percentage
            Text(
              'Probability: ${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display the availability of the bus
            Text(
              'Bus Availability: $busAvailability',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Add "Add to Waiting List" button
            ElevatedButton(
              onPressed: _addToWaitingList,
              child: const Text('Add to Waiting List'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}