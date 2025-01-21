import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Urls.dart';
import 'home.dart';

class TicketConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  const TicketConfirmationScreen({super.key, required this.bookingDetails});

  Future<Map<String, dynamic>> fetchBusSchedule() async {
    final response = await http.get(Uri.parse('${Url.Urls}/get/last_bus_schedule'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load bus schedule');
    }
  }

  Future<double> fetchBusPrice(String busNumber) async {
    final response = await http.post(
      Uri.parse('${Url.Urls}/get/bus_price'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'bus_number': busNumber}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['price'];
    } else {
      throw Exception('Failed to load bus price');
    }
  }

  // New function to fetch seat number from the API
  Future<int> fetchSeatNumber() async {
    final response = await http.get(Uri.parse('${Url.Urls}/seats_fetch'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['seats'];  // Return the seat number from the response
    } else {
      throw Exception('Failed to fetch seat number');
    }
  }

  // Fetch last person details function
  Future<Map<String, dynamic>> fetchLastPersonDetails() async {
    final response = await http.get(Uri.parse('${Url.Urls}/get_last_person'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load last person details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ticket Confirmed',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchBusSchedule(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available.'));
            }

            final busSchedule = snapshot.data!;
            final busNumber = busSchedule['bus_number'];

            return FutureBuilder<double>(
              future: fetchBusPrice(busNumber), // Fetch the price here
              builder: (context, priceSnapshot) {
                if (priceSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (priceSnapshot.hasError) {
                  return Center(child: Text('Error: ${priceSnapshot.error}'));
                } else if (!priceSnapshot.hasData) {
                  return const Center(child: Text('No price data available.'));
                }

                final busPrice = priceSnapshot.data!;

                // FutureBuilder for fetching seat number
                return FutureBuilder<int>(
                  future: fetchSeatNumber(),
                  builder: (context, seatSnapshot) {
                    if (seatSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (seatSnapshot.hasError) {
                      return Center(child: Text('Error: ${seatSnapshot.error}'));
                    } else if (!seatSnapshot.hasData) {
                      return const Center(child: Text('No seat data available.'));
                    }

                    final seatNumber = seatSnapshot.data!;

                    // Fetch last person details to show name, age, and gender
                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchLastPersonDetails(),
                      builder: (context, personSnapshot) {
                        if (personSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (personSnapshot.hasError) {
                          return Center(child: Text('Error: ${personSnapshot.error}'));
                        } else if (!personSnapshot.hasData) {
                          return const Center(child: Text('No person data available.'));
                        }

                        final personData = personSnapshot.data!;
                        final personName = personData['name'];
                        final personAge = personData['age'];
                        final personGender = personData['gender'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Confirmation Message
                            Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Your ticket is confirmed!',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Bus Operator and Number
                            Text(
                              '${busSchedule['company']} (Bus No: ${busSchedule['bus_number']})',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),

                            // Last Person's Name, Age, Gender
                            Text(
                              'Name: $personName',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Age: $personAge',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Gender: $personGender',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),

                            // Seating Type
                            Text(
                              'Seating Type: ${busSchedule['seating_type']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Boarding: ${busSchedule['boarding']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Ending: ${busSchedule['ending']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(height: 30),

                            // Journey Details
                            _buildDetailRow('Starting Time', busSchedule['travel_time']),
                            _buildDetailRow('Ending Time', busSchedule['ending_time']),
                            const Divider(height: 30),

                            // Seat Number (New added field)
                            Text(
                              'Seat Number: $seatNumber',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Divider(height: 30),

                            // Total Fare (Updated with price fetched from API)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Fare',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹${busPrice.toStringAsFixed(2)}', // Updated total fare
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),

                            // Continue Button
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Komal()), // Navigate to Komal class
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 32.0,
                                  ),
                                ),
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
