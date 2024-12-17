import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Owner Bus route1.dart';
import 'Urls.dart';

class TravelDetailsApp extends StatefulWidget {
  @override
  _TravelDetailsAppState createState() => _TravelDetailsAppState();
}

class _TravelDetailsAppState extends State<TravelDetailsApp> {
  final TextEditingController _startingPointController = TextEditingController();
  final TextEditingController _boardingPointController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Function to send data to the Flask server
  Future<void> submitDetails() async {
    final String url = '${Url.Urls}/add/travel/details'; // Replace with your Flask server URL

    final Map<String, String> travelDetails = {
      'starting_point': _startingPointController.text,
      'boarding_point': _boardingPointController.text,
      'time': _timeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(travelDetails),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success, show a message or navigate to the next page
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Travel details updated successfully')));
      } else {
        // Handle failure (400, 500, etc.)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit details')));
      }
    } catch (error) {
      // Handle errors (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back button action
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _startingPointController,
              decoration: InputDecoration(
                labelText: 'Starting Point(Timing)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _boardingPointController,
              decoration: InputDecoration(
                labelText: 'Boarding Point',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    submitDetails(); // Submit details button action
                  },
                  child: Text('Submit Details'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  route1()),
                    );
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
