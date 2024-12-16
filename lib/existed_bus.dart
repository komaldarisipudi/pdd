import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For DateFormat

import 'Urls.dart';

class ExistBusPage extends StatefulWidget {
  @override
  _ExistBusPageState createState() => _ExistBusPageState();
}

class _ExistBusPageState extends State<ExistBusPage> {
  List<dynamic> busDetails = []; // To hold the list of bus details
  List<dynamic> travelDetails = []; // To hold the list of travel details
  List<dynamic> endingDetails = []; // To hold the list of ending details
  bool isLoading = true; // To track loading state

  @override

  void initState() {
    super.initState();
    fetchBusDetails();
    fetchTravelDetails();
    fetchEndingDetails();
  }

  // Function to format the date from string (MM-dd-yyyy to yyyy-MM-dd)
  String formatDate(String date) {
    try {
      final inputFormat = DateFormat("MM-dd-yyyy"); // Change based on input format
      final outputFormat = DateFormat("yyyy-MM-dd"); // Desired output format
      final parsedDate = inputFormat.parse(date); // Parsing the input date string
      return outputFormat.format(parsedDate); // Formatting to the desired format
    } catch (e) {
      print("Error formatting date: $e");
      return ''; // Return empty if parsing fails
    }
  }

  // Function to convert 12-hour format to 24-hour format for time
  String convertTo24HourFormat(String time) {
    try {
      final inputFormat = DateFormat("hh:mm a"); // 12-hour format
      final outputFormat = DateFormat("HH:mm"); // 24-hour format
      final parsedTime = inputFormat.parse(time); // Parsing the input time string
      return outputFormat.format(parsedTime); // Formatting to the desired format
    } catch (e) {
      print("Error converting time: $e");
      return time; // Return original if parsing fails
    }
  }

  // Function to post all bus details to the server
  Future<void> postAllBusDetails() async {
    for (int index = 0; index < busDetails.length; index++) {
      final bus = busDetails[index];
      final travel = index < travelDetails.length ? travelDetails[index] : {};
      final ending = index < endingDetails.length ? endingDetails[index] : {};

      final payload = {
        'bus_number': bus['bus_number'] ?? '',
        'company': bus['bus_company'] ?? '',
        'seats': bus['no_of_seats'] ?? '',
        'starting_point': travel['starting_point'] ?? '',
        'travel_time': convertTo24HourFormat(travel['time'] ?? ''),
        'travel_date': formatDate(travel['date'] ?? ''),
        'ending_point': ending['ending_point'] ?? '',
        'ending_time': convertTo24HourFormat(ending['time'] ?? ''),
      };

      print('Checking for duplicates: $payload');

      try {
        // Check if the record already exists in the database
        final checkResponse = await http.post(
          Uri.parse('${Url.Urls}/check/bus'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'bus_number': bus['bus_number'] ?? ''}),
        );

        if (checkResponse.statusCode == 200) {
          final checkData = json.decode(checkResponse.body);
          if (checkData['exists'] == true) {
            print('Duplicate found, skipping: ${bus['bus_number']}');
            continue; // Skip this record
          }
        } else {
          print('Failed to check for duplicates: ${checkResponse.body}');
          continue; // Skip if the check fails
        }

        // Insert the new record
        final response = await http.post(
          Uri.parse('${Url.Urls}/find/bus'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(payload),
        );

        if (response.statusCode == 201) {
          print('Bus details posted successfully: ${response.body}');
        } else {
          print('Failed to post bus details: ${response.body}');
        }
      } catch (e) {
        print('Error processing bus details: $e');
      }
    }
  }


  // Function to fetch bus details from the API
  Future<void> fetchBusDetails() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/get/details'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        setState(() {
          busDetails = data['bus_details'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load bus details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching bus details: $e');
    }
  }

  // Function to fetch travel details from the API
  Future<void> fetchTravelDetails() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/get/travel_details'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        setState(() {
          travelDetails = data['travel_details'];
        });
      } else {
        throw Exception('Failed to load travel details');
      }
    } catch (e) {
      print('Error fetching travel details: $e');
    }
  }

  // Function to fetch ending details from the API
  Future<void> fetchEndingDetails() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/get/ending_details'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        setState(() {
          endingDetails = data['ending_details'];
        });
      } else {
        throw Exception('Failed to load ending details');
      }
    } catch (e) {
      print('Error fetching ending details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Existing Buses'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Back button action
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : busDetails.isEmpty
          ? Center(child: Text('No bus details found'))
          : ListView.builder(
        itemCount: busDetails.length,
        itemBuilder: (context, index) {
          final bus = busDetails[index];
          final travel = index < travelDetails.length ? travelDetails[index] : {};
          final ending = index < endingDetails.length ? endingDetails[index] : {};

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bus Number: ${bus['bus_number'] ?? 'Not Available'}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text('Company: ${bus['bus_company'] ?? 'Not Available'}'),
                  Text('Seats: ${bus['no_of_seats'] ?? 'Not Available'}'),
                  Text('Seating Type: ${bus['seating_type'] ?? 'Not Available'}'),
                  Text('AC Available: ${bus['ac_available'] == true ? 'Yes' : 'No'}'),
                  SizedBox(height: 8),
                  Text('Starting Point: ${travel['starting_point'] ?? 'Not Available'}'),
                  Text('Travel Time: ${travel['time'] ?? 'Not Available'}'),
                  SizedBox(height: 8),
                  Text('Ending Point: ${ending['ending_point'] ?? 'Not Available'}'),
                  Text('Ending Time: ${ending['time'] ?? 'Not Available'}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: postAllBusDetails, // Call to post bus details
        child: Icon(Icons.send),
        tooltip: 'Post Bus Details',
      ),
    );
  }
}
