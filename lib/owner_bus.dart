import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Owner Bus route.dart';
import 'Urls.dart'; // Update with your actual route file

void main() {
  runApp(const BusDetailsApp());
}

class BusDetailsApp extends StatelessWidget {
  const BusDetailsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BusDetailsFormScreen(),
    );
  }
}

class BusDetailsFormScreen extends StatefulWidget {
  const BusDetailsFormScreen({Key? key}) : super(key: key);

  @override
  _BusDetailsFormScreenState createState() => _BusDetailsFormScreenState();
}

class _BusDetailsFormScreenState extends State<BusDetailsFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _busCompanyController = TextEditingController();
  final TextEditingController _seatingTypeController = TextEditingController();
  final TextEditingController _numSeatsController = TextEditingController();
  final TextEditingController _seatingArrangementController =
  TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _acAvailableController = TextEditingController();
  final TextEditingController _chargingAvailableController =
  TextEditingController();
  final TextEditingController _tvAvailableController = TextEditingController();

  Future<void> _submitBusDetails() async {
    final busDetails = {
      "bus_number": _busNumberController.text,
      "bus_company": _busCompanyController.text,
      "seating_type": _seatingTypeController.text,
      "no_of_seats": _numSeatsController.text,
      "seating_arrangement": _seatingArrangementController.text,
      "price": _priceController.text,
      "ac_available": _acAvailableController.text, // Yes/No
      "charging_available": _chargingAvailableController.text, // Yes/No
      "tv_available": _tvAvailableController.text, // Yes/No
    };

    try {
      // Send to the first endpoint
      final response1 = await http.post(
        Uri.parse('${Url.Urls}/add/bus/details'), // Replace with actual API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(busDetails),
      );

      if (response1.statusCode == 200 || response1.statusCode == 201) {
        // Send to the second endpoint
        final response2 = await http.post(
          Uri.parse('${Url.Urls}/add/final/bus/details'), // Replace with the final API URL
          headers: {'Content-Type': 'application/json'},
          body: json.encode(busDetails),
        );

        if (response2.statusCode == 200 || response2.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bus details submitted successfully!')),
          );

          // Navigate to the next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TravelDetailsApp(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error in final submission: ${response2.body}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in initial submission: ${response1.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and title
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 30.0),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
                const SizedBox(width: 8.0),
                const Text(
                  "Enter Bus Details",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bus Number
                    TextFormField(
                      controller: _busNumberController,
                      decoration: const InputDecoration(
                        labelText: "Bus Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the bus number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Bus Company
                    TextFormField(
                      controller: _busCompanyController,
                      decoration: const InputDecoration(
                        labelText: "Bus Company",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the bus company';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    // Seating Type
                    TextFormField(
                      controller: _seatingTypeController,
                      decoration: const InputDecoration(
                        labelText: "Seating Type (e.g., Sleeper, Semi Sleeper)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Number of Seats
                    TextFormField(
                      controller: _numSeatsController,
                      decoration: const InputDecoration(
                        labelText: "Number of Seats",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    // Seating Arrangement
                    TextFormField(
                      controller: _seatingArrangementController,
                      decoration: const InputDecoration(
                        labelText: "Seating Arrangement",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Price
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: "Price (per ticket)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    // A/C Available
                    TextFormField(
                      controller: _acAvailableController,
                      decoration: const InputDecoration(
                        labelText: "A/C Available (Yes/No)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Charging Available
                    TextFormField(
                      controller: _chargingAvailableController,
                      decoration: const InputDecoration(
                        labelText: "Charging Available (Yes/No)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // TV Available
                    TextFormField(
                      controller: _tvAvailableController,
                      decoration: const InputDecoration(
                        labelText: "TV Available (Yes/No)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitBusDetails,
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
