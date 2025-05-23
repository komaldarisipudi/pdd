import 'dart:convert';
import 'package:bus/Owner%20Bus%20route2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Urls.dart';

class route1 extends StatefulWidget {
  @override
  _Route1PageState createState() => _Route1PageState();
}

class _Route1PageState extends State<route1> {
  final TextEditingController _middlePointController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Function to send data to both routes
  Future<void> submitDetails() async {
    final String url1 = '${Url.Urls}/add/middle/details'; // First endpoint
    final String url2 = '${Url.Urls}/add/bus/middle/details'; // Second endpoint

    // Data for the first route
    final Map<String, String> travelDetails1 = {
      'middle_point': _middlePointController.text,
      'point': _pointController.text,
      'time': _timeController.text,
    };

    // Data for the second route
    final Map<String, String> travelDetails2 = {
      'middle_point': _middlePointController.text,
      'middle_boarding_point': _pointController.text,
      'middle_time': _timeController.text,
    };

    try {
      // First POST request to /add/middle/details
      final response1 = await http.post(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(travelDetails1),
      );

      // Second POST request to /add/bus/middle/details
      final response2 = await http.post(
        Uri.parse(url2),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(travelDetails2),
      );

      // Print responses for debugging
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
              controller: _middlePointController,
              decoration: InputDecoration(
                labelText: 'Middle Point',
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
                      MaterialPageRoute(builder: (context) => route2()),
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
