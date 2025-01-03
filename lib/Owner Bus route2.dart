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

  // Function to send data to both Flask server endpoints
  Future<void> submitDetails() async {
    final String url1 = '${Url.Urls}/add/endingpoint/details'; // Endpoint 1
    final String url2 = '${Url.Urls}/add/bus/ending/details'; // Endpoint 2

    final Map<String, String> travelDetails = {
      'ending_point': _endingPointController.text,
      'point': _pointController.text,
      'time': _timeController.text,
    };

    final Map<String, String> busTravelDetails = {
      'ending_point': _endingPointController.text,
      'ending_boarding_point': _pointController.text, // Note the field name change
      'ending_time': _timeController.text,           // Note the field name change
    };

    try {
      // Send data to the first endpoint
      final response1 = await http.post(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(travelDetails),
      );

      // Send data to the second endpoint
      final response2 = await http.post(
        Uri.parse(url2),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(busTravelDetails),
      );

      // Print the response for debugging
      print('Response 1 status: ${response1.statusCode}');
      print('Response 1 body: ${response1.body}');
      print('Response 2 status: ${response2.statusCode}');
      print('Response 2 body: ${response2.body}');

      if ((response1.statusCode == 200 || response1.statusCode == 201) &&
          (response2.statusCode == 200 || response2.statusCode == 201)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Travel details updated successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to submit details')));
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
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
                      MaterialPageRoute(builder: (context) => DriverDetailsApp()),
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
