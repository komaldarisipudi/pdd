import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Urls.dart';
import 'home.dart'; // Assuming 'Komal' is defined in this file or update the import as needed.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WaitingListScreen(),
    );
  }
}

class WaitingListScreen extends StatefulWidget {
  const WaitingListScreen({Key? key}) : super(key: key);

  @override
  _WaitingListScreenState createState() => _WaitingListScreenState();
}

class _WaitingListScreenState extends State<WaitingListScreen> {
  String from = '';
  String to = '';
  String date = '';
  String seats = '';
  String probability = '';
  String availability = '';

  // Fetch the last waiting list entry from the backend
  void _fetchLastWaitingList() async {
    String url = '${Url.Urls}/get_last_waiting_list'; // Replace with your server URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server returns a success response
        var data = json.decode(response.body);
        setState(() {
          from = data['from'];
          to = data['to'];
          date = data['date'];
          seats = data['seats'];
          probability = data['probability'];
          availability = data['availability'];
        });
      } else {
        // Handle error from server
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle any network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLastWaitingList(); // Fetch the last waiting list entry when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Waiting List'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Center(
              child: Text(
                'Your Waiting List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red, // Red color as per the prompt
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display fetched data
            if (from.isEmpty || to.isEmpty) ...[
              // Loading indicator or error message if no data
              const Center(child: CircularProgressIndicator()),
            ] else ...[
              Text(
                'From: $from → $to',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: $date',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No. of Seats Required: $seats',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Probability to get: $probability',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Availability of Bus: $availability',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Continue Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate directly to the Komal screen when the button is pressed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Komal()), // Replace with your actual Komal class
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for the button
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
