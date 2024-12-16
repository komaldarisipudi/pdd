import 'package:bus/ticket_conformation.dart';
import 'package:flutter/material.dart';


class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with text and back button
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.14, // Adjusted height for the yellow section
            color: Colors.blue[600],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              // Adjusted padding for the text and back button
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(
                          context); // Navigate back when back button is pressed
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
                  // Placeholder for alignment, can be adjusted
                ],
              ),
            ),
          ),

          // Payment Section
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            // Adjusted to give more room for the sheet
            minChildSize: 0.5,
            // Minimum height when collapsed
            maxChildSize: 0.95,
            // Maximum height when expanded, keeps some space above
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
                // Adjust padding for proper alignment
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Payment Details (Simplified)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Method Section
                        Text(
                          'Payment Method',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight
                              .bold),
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight
                              .bold),
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
                                  Image.asset(
                                      'assets/gpay.png', width: 50, height: 50),
                                  SizedBox(height: 8),
                                  Text('Google Pay'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showPaymentConfirmation(context, 'PhonePe');
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/phonepe.png', width: 50,
                                      height: 50),
                                  SizedBox(height: 8),
                                  Text('PhonePe'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showPaymentConfirmation(context, 'Paytm');
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/paytm.png', width: 50,
                                      height: 50),
                                  SizedBox(height: 8),
                                  Text('Paytm'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Total Price Section
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$52.98',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Centering Pay Now Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Simulating payment completion
                              _showPaymentConfirmation(
                                  context, 'Credit/Debit Card');
                            },
                            child: Text('Pay Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              // Pay now button color
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

  // Function to show payment confirmation dialog and navigate to FinOrderPage
  void _showPaymentConfirmation(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text(
              'Your payment via $method has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog and navigate to TicketConfirmationScreen
                Navigator.pop(context); // Close the dialog

                // Example bookingDetails map (you need to replace it with actual data)
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
                    {
                      'name': 'John Doe',
                      'gender': 'Male',
                      'age': 30,
                      'seat': 'A1'
                    },
                    {
                      'name': 'Jane Doe',
                      'gender': 'Female',
                      'age': 28,
                      'seat': 'A2'
                    },
                  ],
                  'totalFare': 52.98,
                };

                // Navigate to TicketConfirmationScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TicketConfirmationScreen(
                            bookingDetails: bookingDetails),
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
}