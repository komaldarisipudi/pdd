import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For encoding data as JSON
import 'package:bus/ticket_conformation.dart';

import 'Urls.dart';  // Import your TicketConfirmationScreen

class PaymentPage extends StatelessWidget {
  final String passengerName;
  final String passengerGender;
  final int passengerAge;

  const PaymentPage({
    Key? key,
    required this.passengerName,
    required this.passengerGender,
    required this.passengerAge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with text and back button
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.blue[600],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // Payment Section
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Payment Method',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Credit/Debit Card'),
                          ],
                        ),
                        SizedBox(height: 20),

                        // UPI Apps Section
                        Text(
                          'OR Pay Using UPI',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showPaymentConfirmation(context, 'Google Pay');
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/gpay.png', width: 50, height: 50),
                                  SizedBox(height: 4),
                                  Text('Google Pay'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showPaymentConfirmation(context, 'Paytm');
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/paytm.png', width: 50, height: 50),
                                  SizedBox(height: 4),
                                  Text('Paytm'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Pay Now Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _makePayment(context);
                            },
                            child: Text('Pay Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment via $method has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Example bookingDetails map (replace with actual data)
                Map<String, dynamic> bookingDetails = {
                  'busOperator': 'XYZ Travels',
                  'busNumber': 'B123',
                  'classOfService': 'Sleeper',
                  'driverName': 'John Doe',
                  'driverContact': '9876543210',
                  'journeyDate': '2024-11-25',
                  'boardingPoint': 'Station A',
                  'boardingTime': '10:00 AM',
                  'droppingPoint': 'Station B',
                  'droppingTime': '4:00 PM',
                  'passengers': [
                    {'name': 'John Doe', 'gender': 'Male', 'age': 30, 'seat': 'A1'},
                    {'name': 'Jane Doe', 'gender': 'Female', 'age': 28, 'seat': 'A2'},
                  ],
                  'totalFare': 52.98,
                };

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketConfirmationScreen(bookingDetails: bookingDetails),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Send data to backend API
  Future<void> _makePayment(BuildContext context) async {
    final url = Uri.parse('${Url.Urls}/add_person');  // Replace with your actual API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': passengerName,
        'age': passengerAge,
        'gender': passengerGender,
      }),
    );

    if (response.statusCode == 201) {
      _showPaymentConfirmation(context, 'Credit/Debit Card');
    } else {
      // Handle errors if the request fails
      print('Failed to add person: ${response.body}');
    }
  }
}
