import 'dart:convert';
import 'package:bus/owner_driverDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Owner home.dart';
import 'Urls.dart';

class route2 extends StatefulWidget {
  @override
  _Route2PageState createState() => _Route2PageState();
}

class _Route2PageState extends State<route2> {
  final TextEditingController _endingPointController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Function to send data to the Flask server
  Future<void> submitDetails() async {
    final String url = '${Url.Urls}/add/endingpoint/details'; // Replace with your Flask server URL

    final Map<String, String> travelDetails = {
      'ending_point': _endingPointController.text,
      'point': _pointController.text,
      'time': _timeController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(travelDetails),
      );

      // Print the response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Travel details updated successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit details')));
      }
    } catch (error) {
      print('Error: $error');
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
              controller: _endingPointController,
              decoration: InputDecoration(
                labelText: 'Ending Point',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pointController,
              decoration: InputDecoration(
                labelText: 'Point',
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
                      MaterialPageRoute(builder: (context) =>  DriverDetailsApp()),
                    );
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
