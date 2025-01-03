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
    final String url1 = '${Url.Urls}/add/travel/details'; // Flask endpoint 1
    final String url2 = '${Url.Urls}/add/bus/travel/details'; // Flask endpoint 2

    final Map<String, String> travelDetails = {
      'starting_point': _startingPointController.text,
      'boarding_point': _boardingPointController.text,
      'time': _timeController.text, // For the first endpoint
      'starting_time': _timeController.text, // For the second endpoint
    };

    try {
      // Send the first request
      final response1 = await http.post(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(travelDetails),
      );

      if (response1.statusCode == 200 || response1.statusCode == 201) {
        // If the first request is successful, send the second request
        final response2 = await http.post(
          Uri.parse(url2),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'starting_point': _startingPointController.text,
            'boarding_point': _boardingPointController.text,
            'starting_time': _timeController.text, // Use the correct field name
          }),
        );

        if (response2.statusCode == 200 || response2.statusCode == 201) {
          // Success for both requests
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Travel details submitted successfully to both endpoints')),
          );
        } else {
          // Debug the second response
          print('Second endpoint failed: ${response2.statusCode} ${response2.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit details to the second endpoint')),
          );
        }
      } else {
        // Handle failure for the first request
        print('First endpoint failed: ${response1.statusCode} ${response1.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit details to the first endpoint')),
        );
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during requests: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
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
