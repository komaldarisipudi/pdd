import 'package:flutter/material.dart';

import 'home.dart'; // Replace with the correct path

class TicketConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  const TicketConfirmationScreen({super.key, required this.bookingDetails});

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
        child: Column(
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
              '${bookingDetails['busOperator']} (Bus No: ${bookingDetails['busNumber']})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Class of Service and Driver Info
            Text(
              'Class of Service: ${bookingDetails['classOfService']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Driver: ${bookingDetails['driverName']} (${bookingDetails['driverContact']})',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 30),

            // Journey Details
            _buildDetailRow('Date of Journey', bookingDetails['journeyDate']),
            _buildDetailRow('Boarding Point', '${bookingDetails['boardingPoint']} (${bookingDetails['boardingTime']})'),
            _buildDetailRow('Dropping Point', '${bookingDetails['droppingPoint']} (${bookingDetails['droppingTime']})'),
            const Divider(height: 30),

            // Passenger Details
            Text(
              'Passenger Details',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...bookingDetails['passengers'].map<Widget>((passenger) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '${passenger['name']} (${passenger['gender']}, ${passenger['age']} years) - Seat: ${passenger['seat']}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            const Divider(height: 30),

            // Total Fare
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Fare',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${bookingDetails['totalFare']}',
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
